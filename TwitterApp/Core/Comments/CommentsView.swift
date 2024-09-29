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
    @FocusState private var focusedField: Bool
    @EnvironmentObject var notificationViewmodel : NotificationsViewModel
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
                Spacer()
                Text("Comments").foregroundStyle(.black).bold()
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
                    if let user = viewmodel.tweet.user{
                        AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                            image.resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .padding(.leading,10)
                        } placeholder: {
                            Circle()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .padding(.leading,10)
                                .redacted(reason: .placeholder)
                        }
                    }
                    TextField("Add a comment in post of \(viewmodel.tweet.user?.username ?? "")", text: $comments)
                        .padding(.all,10)
                        .foregroundStyle(.black)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.6)
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 10)
                        .focused($focusedField)
                        .onAppear{
                            focusedField = true
                        }
                        
                    
                    // Botão de enviar
                    Button(action: {
                        // Adicionar comentário
                        viewmodel.addComment(commentText: comments) { newCommentID in
                            // Após adicionar, guarda o ID do comentário
                            lastCommentID = newCommentID
                            
                            // Limpar o campo de comentário
                            comments = ""
                            self.notificationViewmodel .sendNotification(toUserId: viewmodel.tweet.user?.id ?? "", postId: viewmodel.tweet.id, type: .comment)
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
                        Image(systemName: "arrow.up")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(comments.isEmpty ? Color.gray : Color .blue)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                           
                            .animation(.spring(), value: comments.isEmpty)
                    }
                    .padding(.trailing, 10)
                    .disabled(comments.isEmpty)
                }
                .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    CommentsView(tweet: Tweet(uid: "", tweet: "Ola mundo", likes: 1, timestamp: Timestamp(), numberOfComments: 1,numberOfRetweets: 0))
}
