//
//  ChatView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//
import SwiftUI

struct ChatView: View {
    @StateObject var chatviewModel = ChatViewModel()
    @State var text: String = ""
    let user: User
    @Environment(\.dismiss) private var dismiss  // Controla a navegação manualmente

    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatviewModel.messages) { message in
                    MessageRowView(message: message)
                }
            }

            CustomTextField(text: $text) {
                chatviewModel.sendMessage(message: text, toUser : user)
            }
            .padding(.bottom, 8)
        }
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .redacted(reason: .placeholder)
                }
            }

            ToolbarItem(placement: .principal) {
                Text(user.username)
                    .font(.headline)
            }
        }
        .navigationBarBackButtonHidden(true) 
    }
}

#Preview {
    let exampleUser = User(
        fullname: "Jamerson",
        profileImageUrl: "https://via.placeholder.com/150",
        username: "Joseph",
        email: "jamerson@gmail.com",
        following: 0,
        followers: 0
    )
    ChatView(user: exampleUser)
}
