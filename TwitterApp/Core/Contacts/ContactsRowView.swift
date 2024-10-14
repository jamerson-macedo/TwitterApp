//
//  ContactsRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI

struct ContactsRowView: View {
    let user : User
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                image
                    .resizable()
                    .frame(width: 56, height: 56)
                    .scaledToFit()
                    .clipShape(Circle())
            } placeholder: {
                ProgressView().frame(width: 56,height: 56)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
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
    ContactsRowView(user: exampleUser)
}
