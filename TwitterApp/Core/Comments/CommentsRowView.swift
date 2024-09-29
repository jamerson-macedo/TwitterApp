//
//  ComentsRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import SwiftUI
import FirebaseCore
import SwiftUI

struct CommentsRowView: View {
    @ObservedObject var viewmodel: CommentsRowViewModel
    
    init(comments: Comments) {
        self.viewmodel = CommentsRowViewModel(comments: comments)
    }
    
    var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               HStack(alignment: .top, spacing: 12) {
                   // Foto de perfil do usuário à esquerda
                   if let user = viewmodel.comments.user {
                       AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                           image.resizable()
                               .frame(width: 40, height: 40)
                               .clipShape(Circle())
                       } placeholder: {
                           Circle()
                               .frame(width: 40, height: 40)
                               .clipShape(Circle())
                               .redacted(reason: .placeholder)
                       }
                   }

                   // Nome, conteúdo do comentário e coração à direita da imagem
                   VStack(alignment: .leading, spacing: 4) {
                       // Nome do usuário e timestamp
                       HStack {
                           Text(viewmodel.comments.user?.username ?? "")
                               .font(.subheadline)
                               .bold()
                               .foregroundColor(.black)

                           Text(viewmodel.comments.timestamp.timeAgoDisplay())
                               .font(.caption)
                               .foregroundColor(.gray)

                           Spacer() // Garante que o nome e o timestamp fiquem no topo
                       }

                       // Comentário e ícone de coração
                       HStack {
                           // Texto do comentário
                           Text(viewmodel.comments.comments)
                               .font(.body)
                               .foregroundColor(.black)
                               .fixedSize(horizontal: false, vertical: true) // Expande verticalmente, mas não horizontalmente
                               .multilineTextAlignment(.leading) // Garante que o texto comece alinhado à esquerda
                           
                           Spacer()

                           // Ícone de coração e contagem de likes
                           Button(action: {
                               // Ação de like
                           }) {
                               HStack(spacing: 2) {
                                   Image(systemName: "heart")
                                       .font(.subheadline)
                                       .foregroundColor(.gray)
                               }
                           }
                       }
                   }
               }

               Divider()
                   .background(Color.gray.opacity(0.5)) // Cor da divisória
           }
           .padding(.vertical, 8)
           .padding(.horizontal)
       }
   }
#Preview {
    CommentsRowView( comments: Comments(comments: "Est", timestamp: Timestamp.init(),user: User(fullname: "Jamerson", profileImageUrl: "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*U4gZLnRtHEeJuc6tdVLwPw.png", username: "zezin", email: "",following: 0,followers: 0)))
}
