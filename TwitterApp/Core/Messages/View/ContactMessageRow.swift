//
//  ContactMessageRow.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI
import FirebaseCore

struct ContactMessageRow: View {
    var user: ContactWithLastMessage

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.user.profileImageUrl)) { image in
                image
                    .resizable()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView().frame(width: 56,height: 56)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(user.user.username)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                Text("Última mensagem: \(user.lastMessage?.text ?? "Sem mensagem")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
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

    let exampleMessage = Messages(
        id: "1",
        text: "Oi, tudo bem?",
        isMe: true,
        timeStamp: Timestamp(date: Date())
    )

    let contactWithMessage = ContactWithLastMessage(
        user: exampleUser,
        lastMessage: exampleMessage
    )

    ContactMessageRow(user: contactWithMessage)
}
