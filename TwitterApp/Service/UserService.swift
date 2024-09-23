//
//  UserService.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 10/09/24.
//


import FirebaseFirestore
import FirebaseAuth
struct UserService {
    func fetchUser(withuid uid : String, completion : @escaping (User)->Void){
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { document, _ in
                guard let document = document else {return}
                guard let user = try? document.data(as: User.self) else {return}
                print("DEBUG : \(user.username)")
                completion(user)
            }
    }
    func fetchAllUsers(completion : @escaping ([User]) -> Void){
        // usuario atual
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").getDocuments { document, _ in
            guard let documents = document?.documents else {return}
            let users = documents.compactMap { query in
                try? query.data(as:User.self)
            }.filter { user in
                // adiciona apenas os diferentes
                user.id != currentUserID
            }
            
            completion(users)
        }
    }
    func followUser(followingUserID: String) {
        let userId = Auth.auth().currentUser!.uid

        // Adiciona o usuário que você quer seguir na subcoleção "following" do usuário atual
        let followingRef = Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("following")
            .document(followingUserID)
        
        followingRef.setData([:]) { error in
            if let error = error {
                print("Erro ao seguir usuário: \(error.localizedDescription)")
                return
            }
            
            // Incrementa o contador de "following" no usuário atual
            Firestore.firestore()
                .collection("users")
                .document(userId)
                .updateData(["following": FieldValue.increment(Int64(1))]) { error in
                    if let error = error {
                        print("Erro ao incrementar o contador de seguindo: \(error.localizedDescription)")
                    }
                }
            
            // Adiciona o usuário atual na subcoleção "followers" do usuário que está sendo seguido
            let followersRef = Firestore.firestore()
                .collection("users")
                .document(followingUserID)
                .collection("followers")
                .document(userId)
            
            followersRef.setData([:]) { error in
                if let error = error {
                    print("Erro ao adicionar seguidor: \(error.localizedDescription)")
                    return
                }

                // Incrementa o contador de "followers" no usuário seguido
                Firestore.firestore()
                    .collection("users")
                    .document(followingUserID)
                    .updateData(["followers": FieldValue.increment(Int64(1))]) { error in
                        if let error = error {
                            print("Erro ao incrementar o contador de seguidores: \(error.localizedDescription)")
                        } else {
                            print("Você está seguindo \(followingUserID) com sucesso!")
                        }
                    }
            }
        }
    }

    func unfollowUser(followingUserID: String) {
        let userId = Auth.auth().currentUser!.uid

        // Remove o usuário da subcoleção "following" do usuário atual
        let followingRef = Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("following")
            .document(followingUserID)
        
        followingRef.delete { error in
            if let error = error {
                print("Erro ao deixar de seguir usuário: \(error.localizedDescription)")
                return
            }
            
            // Decrementa o contador de "following" no usuário atual
            Firestore.firestore()
                .collection("users")
                .document(userId)
                .updateData(["following": FieldValue.increment(Int64(-1))]) { error in
                    if let error = error {
                        print("Erro ao decrementar o contador de seguindo: \(error.localizedDescription)")
                        return
                    }

                    // Remove o usuário atual da subcoleção "followers" do usuário que está sendo seguido
                    let followersRef = Firestore.firestore()
                        .collection("users")
                        .document(followingUserID)
                        .collection("followers")
                        .document(userId)
                    
                    followersRef.delete { error in
                        if let error = error {
                            print("Erro ao remover seguidor: \(error.localizedDescription)")
                        } else {
                            // Decrementa o contador de "followers" no usuário seguido
                            Firestore.firestore()
                                .collection("users")
                                .document(followingUserID)
                                .updateData(["followers": FieldValue.increment(Int64(-1))]) { error in
                                    if let error = error {
                                        print("Erro ao decrementar o contador de seguidores: \(error.localizedDescription)")
                                    } else {
                                        print("Você deixou de seguir \(followingUserID) com sucesso!")
                                    }
                                }
                        }
                    }
                }
        }
    }

    func isFollowing(userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let followingRef = Firestore.firestore()
            .collection("users")
            .document(currentUserId)
            .collection("following")
            .document(userId)
        
        followingRef.getDocument { snapshot, error in
            if let error = error {
                print("Erro ao verificar se está seguindo: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Se o documento existir, significa que o usuário atual está seguindo o usuário fornecido
            completion(snapshot?.exists ?? false)
        }
    }
}

