//
//  NotificationService.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 29/09/24.
//
import FirebaseFirestore
import Firebase

class NotificationService {
    
    static let shared = NotificationService() // Singleton para acesso fácil
    
    private init() {} // Inicializador privado para garantir que seja um singleton
    
    // Função para buscar o nome do usuário
    func fetchUserInfo(userId: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Erro ao buscar o usuário: \(error.localizedDescription)")
                completion(nil) // Retorna nil em caso de erro
                return
            }
            
            if let document = document, document.exists {
                do {
                    // Tenta decodificar o documento como um objeto `User`
                    let user = try document.data(as: User.self) // Decodifica para a struct User
                    completion(user) // Retorna o objeto `User`
                } catch {
                    print("Erro ao decodificar o usuário: \(error.localizedDescription)")
                    completion(nil) // Retorna nil em caso de erro na decodificação
                }
            } else {
                completion(nil) // Retorna nil se o documento não existir
            }
        }
    }

    
    // Função para buscar notificações e incluir o nome do usuário
    func fetchNotifications(for userId: String, completion: @escaping ([Notification]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Erro ao buscar notificações: \(error.localizedDescription)")
                    completion([]) // Retorna um array vazio em caso de erro
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([]) // Retorna vazio se não houver notificações
                    return
                }
                
                var notifications: [Notification] = []
                let dispatchGroup = DispatchGroup() // Para esperar todas as buscas de usuário terminarem
                
                for doc in documents {
                    if var notification = try? doc.data(as: Notification.self) {
                        dispatchGroup.enter() // Entramos no grupo para sincronizar as operações
                        
                        // Buscar o usuário baseado no fromUserId da notificação
                        self.fetchUserInfo(userId: notification.fromUserId) { user in
                            if let user = user {
                                // Atualizamos a notificação com os detalhes do usuário
                                notification.fromUsername = user.username
                                notification.fromUserProfileImageUrl = user.profileImageUrl
                            }
                            notifications.append(notification)
                            dispatchGroup.leave() // Sai do grupo após concluir a busca
                        }
                    }
                }
                
                // Após todas as buscas de usuário terminarem, retornamos as notificações
                dispatchGroup.notify(queue: .main) {
                    completion(notifications)
                }
            }
    }

    // Função para enviar notificação
    func sendNotification(toUserId: String, fromUserId: String, postId: String?, type: NotificationType) {
        let db = Firestore.firestore()
        
        // Adiciona o campo toUserId que estava faltando
        let notificationData: [String: Any] = [
            "type": type.rawValue,
            "fromUserId": fromUserId,
            "toUserId": toUserId, // Adicionando toUserId
            "postId": postId ?? "",
            "timestamp": Timestamp(date: Date()),
            "fromUsername" : "",
            "fromUserProfileImageUrl" : ""
        ]
        
        // Salva a notificação no Firestore
        db.collection("users").document(toUserId).collection("notifications").addDocument(data: notificationData) { error in
            if let error = error {
                print("Erro ao enviar notificação: \(error.localizedDescription)")
            } else {
                print("Notificação enviada com sucesso!")
            }
        }
    }
}




