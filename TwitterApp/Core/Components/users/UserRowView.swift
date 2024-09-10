//
//  UserRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct UserRowView: View {
    let user : User
    var body: some View {
      
        HStack(spacing : 12){
            AsyncImage(url: URL(string: user.profileImageUrl)){ image in
                image.resizable().frame(width: 56,height: 56).clipShape(Circle())
                
            }placeholder: {
                ProgressView()
            }/*.frame(width: 50)*/
            VStack(alignment:.leading,spacing: 4){
                Text(user.username).font(.subheadline).bold().foregroundStyle(Color.black)
                Text(user.fullname).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            
        }.padding(.horizontal)
            .padding(.vertical,4)
    }
}

#Preview {
    UserRowView(user: User(fullname: "", profileImageUrl: "", username: "", email: ""))
}
