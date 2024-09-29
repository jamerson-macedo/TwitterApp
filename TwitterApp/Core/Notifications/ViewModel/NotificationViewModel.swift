//
//  NotificationViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 29/09/24.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = [] // Lista de notificações
    private var cancellables = Set<AnyCancellable>()
    
    private let service = NotificationService.shared // Instância do serviço

    // Função para buscar notificações
    func fetchNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        service.fetchNotifications(for: currentUserId) { [weak self] notifications in
            DispatchQueue.main.async {
                self?.notifications = notifications // Atualiza as notificações no main thread
                print("Notificacoes chegando, \(self?.notifications)")
            }
        }
    }

    // Função para enviar notificação ao realizar like, retweet, etc.
    func sendNotification(toUserId: String, postId: String?, type: NotificationType) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        service.sendNotification(toUserId: toUserId, fromUserId: currentUserId, postId: postId, type: type)
    }
    
    func notificationMessage(for notification: Notification) -> Text {
        let username = notification.fromUsername ?? "Alguém" // Nome do usuário ou "Alguém" como fallback
        switch notification.type {
        case .like:
            return Text(username).bold() + Text(" curtiu seu post.")
        case .comment:
            return Text(username).bold() + Text(" comentou no seu post.")
        case .retweet:
            return Text(username).bold() + Text(" retweetou seu post.")
        }
    }

}
