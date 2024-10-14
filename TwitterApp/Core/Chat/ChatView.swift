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
    let user : User
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    ForEach(chatviewModel.messages){ messages in
                        MessageRowView(message: messages)
                        
                    }
                    
                   
                }
                CustomTextField(text: $text) {
                    //chatviewModel.sendmessage()
                }
            }.toolbar {
                ToolbarItem(placement: .navigation) {
                    Image(systemName: "arrow.left")
                }
                ToolbarItem(placement:.navigation) {
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
                    Text(user.username).font(.headline)
                }
            }
        }
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
