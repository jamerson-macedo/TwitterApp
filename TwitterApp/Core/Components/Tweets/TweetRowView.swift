//
//  TweetRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct TweetRowView: View {
    let tweet : Tweet
    var body: some View {
        VStack(alignment:.leading){
            
            HStack(alignment : .top,spacing: 12){
                if let user = tweet.user{
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment:.leading,spacing: 4){
                        
                        
                        HStack{
                            Text(user.fullname).font(.subheadline).bold()
                            Text("@\(user.username)").foregroundStyle(.gray).font(.caption)
                            Text("2w").foregroundStyle(.gray).font(.caption)
                        }
                        
                        Text(tweet.tweet).font(.headline).multilineTextAlignment(.leading)
                    }
                    
                    
                }
            }
            HStack(){
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bubble.left").font(.subheadline)
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "arrow.2.squarepath").font(.subheadline)
                    
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "heart").font(.subheadline)
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bookmark").font(.subheadline)
                })
            }.padding()
                .foregroundStyle(Color.gray)
            Divider()
        }
    }
}


