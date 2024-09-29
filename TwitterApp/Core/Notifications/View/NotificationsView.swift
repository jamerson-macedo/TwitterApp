//
//  NotificationsView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var viewModel: NotificationsViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.notifications) { notification in
                HStack {
                    HStack {
                        viewModel.notificationMessage(for: notification)
                        Text(notification.timestamp.timeAgoDisplay())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    // Se houver um post relacionado, adiciona um link para detalhes do post
                    if let postId = notification.postId {
                        // NavigationLink(destination: PostDetailView(postId: postId)) {
                        //   Image(systemName: "arrow.right")
                    }
                }
            }
            .padding(.vertical, 8)
            .navigationTitle("Notificações")
            .navigationBarTitleDisplayMode(.inline)
            // Mova o navigationTitle para dentro do NavigationView
        }
        .onAppear {
            viewModel.fetchNotifications() // Buscar notificações ao abrir a tela
        }
    }
}


#Preview {
    NotificationsView().environmentObject(NotificationsViewModel())
}
