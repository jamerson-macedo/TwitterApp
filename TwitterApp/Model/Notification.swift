//
//  Notification.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 29/09/24.
//
import FirebaseFirestore
struct Notification: Identifiable, Codable {
    @DocumentID var id : String?
    var type: NotificationType // Tipo de notificação: Like, Comment, Retweet
    var fromUserId: String      // Quem executou a ação
    var toUserId: String        // Quem recebe a notificação
    var postId: String?         // O ID do post relevante (se aplicável)
    var timestamp: Timestamp    // Quando ocorreu a notificação
    var fromUsername: String?   // Nome do usuário que enviou a notificação
}

enum NotificationType: String, Codable {
    case like = "like"
    case comment = "comment"
    case retweet = "retweet"
}
