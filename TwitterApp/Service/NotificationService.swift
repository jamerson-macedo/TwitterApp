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
    func fetchUserName(userId: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Erro ao buscar o nome do usuário: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String
                completion(username)
            } else {
                completion(nil)
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
                
                let dispatchGroup = DispatchGroup() // Para esperar que todas as buscas de nome de usuário terminem
                
                for doc in documents {
                    var notification = try? doc.data(as: Notification.self)
                    if let notification = notification {
                        dispatchGroup.enter() // Entra no grupo antes de buscar o nome do usuário
                        
                        // Buscar o nome do usuário baseado no fromUserId
                        self.fetchUserName(userId: notification.fromUserId) { username in
                            var updatedNotification = notification
                            updatedNotification.fromUsername = username // Adiciona o nome do usuário
                            notifications.append(updatedNotification)
                            dispatchGroup.leave() // Sai do grupo após buscar o nome do usuário
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(notifications) // Retorna todas as notificações após terminar a busca
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
            "fromUsername" : ""
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




