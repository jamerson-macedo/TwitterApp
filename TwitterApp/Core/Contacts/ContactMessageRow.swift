//
//  ContactMessageRow.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI

struct ContactMessageRow: View {
    var user: User
    var body: some View {
        HStack(spacing : 12){
            AsyncImage(url: URL(string: user.profileImageUrl)){ image in
                image.resizable().frame(width: 56,height: 56).clipShape(Circle())
                
            }placeholder: {
                ProgressView()
            }/*.frame(width: 50)*/
            VStack(alignment:.leading,spacing: 4){
                Text(user.username).font(.subheadline).bold().foregroundStyle(Color.black)
                Text("Ultima mensagem enviada:").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            
        }.padding(.horizontal)
            .padding(.vertical,4)
    }
}

#Preview {
    ContactMessageRow(user: User(fullname: "Jamerson", profileImageUrl: "", username: "Joseph", email: "Jamerson@gmail.com", following: 0, followers: 0))
}
