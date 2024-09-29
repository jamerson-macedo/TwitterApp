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
                    // Exibe a imagem de perfil do usuário
                    if let imageUrl = notification.fromUserProfileImageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        // Exibe o nome do usuário e a mensagem da notificação
                        viewModel.notificationMessage(for: notification)
                        Text(notification.timestamp.timeAgoDisplay())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Notificações")
            .onAppear {
                viewModel.fetchNotifications() // Buscar notificações ao abrir a tela
            }
        }
    }
}


#Preview {
    NotificationsView().environmentObject(NotificationsViewModel())
}
