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
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            guard let document = document else {return}
            guard let user = try? document.data(as: User.self) else {return}
            print("DEBUG : \(user.username)")
            completion(user)
        }
    }
    func fetchAllUsers(completion : @escaping ([User]) -> Void){
       
        Firestore.firestore().collection("users").getDocuments { document, _ in
            guard let documents = document?.documents else {return}
            let users = documents.compactMap { query in
                try? query.data(as:User.self)
            }
            
            completion(users)
        }
    }
}
