//
//  TweetRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct TweetRowView: View {
    var body: some View {
        VStack(alignment:.leading){
            HStack(alignment : .top,spacing: 12){
                Circle().frame(width: 56,height: 56)
                VStack(alignment:.leading,spacing: 4){
                    HStack{
                        Text("Jamerson").font(.subheadline).bold()
                        Text("@jamersonMacedo").foregroundStyle(.gray).font(.caption)
                        Text("2W").foregroundStyle(.gray).font(.caption)
                    }
                    Text("I belive in God").font(.headline).multilineTextAlignment(.leading)
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
            Divider()
        }
    }
}

#Preview {
    TweetRowView()
}
