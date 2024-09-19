//
//  CommentsView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import SwiftUI
import FirebaseCore
import SwiftUI

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewmodel: CommentsViewModel
    @State var comments = ""
    @State private var lastCommentID: String? // Armazenar o ID do último comentário adicionado
    
    init(tweet: Tweet) {
        self.viewmodel = CommentsViewModel(tweet: tweet)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                
                Text("Comments").bold()
                Spacer()
            }
            .padding()
            
            Spacer()
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(viewmodel.comments) { comment in
                        CommentsRowView(comments: comment)
                            .id(comment.id) // Definindo o ID de cada comentário
                    }
                }
                
                // Campo de texto para adicionar um novo comentário
                HStack {
                    TextField("Add a comment...", text: $comments)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 10)
                    
                    // Botão de enviar
                    Button(action: {
                        // Adicionar comentário
                        viewmodel.addComment(commentText: comments) { newCommentID in
                            // Após adicionar, guarda o ID do comentário
                            lastCommentID = newCommentID
                            
                            // Limpar o campo de comentário
                            comments = ""
                            
                            // Garante que a rolagem ocorra após a atualização da interface
                            DispatchQueue.main.async {
                                if let lastCommentID = lastCommentID {
                                    withAnimation {
                                        scrollViewProxy.scrollTo(lastCommentID, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Circle())
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            .scaleEffect(comments.isEmpty ? 0.9 : 1.1)
                            .animation(.spring(), value: comments.isEmpty)
                    }
                    .padding(.trailing, 10)
                    .disabled(comments.isEmpty) // Desabilita o botão se o campo estiver vazio
                }
                .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    CommentsView(tweet: Tweet(uid: "", tweet: "Ola mundo", likes: 1, timestamp: Timestamp()))
}
