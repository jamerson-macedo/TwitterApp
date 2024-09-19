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
            HStack(alignment: .top) {
                if let user = viewmodel.comments.user {
                    // Foto de perfil do usuário
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    // Nome e username
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .font(.headline)
                            .bold()
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(viewmodel.comments.timestamp.timeAgoDisplay())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            
            // Texto do comentário
            Text(viewmodel.comments.comments)
                .font(.body)
                .padding(.top, 8)
                .fixedSize(horizontal: false, vertical: true) // Expande verticalmente
            
            // Barra divisora para separar comentários
            Divider()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

#Preview {
    CommentsRowView( comments: Comments(comments: "Estou infomando que estou fazendo um c", timestamp: Timestamp.init(),user: User(fullname: "Jamerson", profileImageUrl: "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*U4gZLnRtHEeJuc6tdVLwPw.png", username: "zezin", email: "")))
}
