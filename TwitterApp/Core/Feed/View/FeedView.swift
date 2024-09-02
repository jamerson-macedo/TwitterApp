//
//  FeedView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct FeedView: View {
    @State private var showNewTweetView = false
    var body: some View {
        ZStack(alignment : .bottomTrailing){
            ScrollView{
                LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                    ForEach(1...10, id: \.self) { _ in
                        TweetRowView().padding()
                    }
                })
                
            }
            Button{
                showNewTweetView.toggle()
            } label: {
                Image(systemName: "bird").resizable().renderingMode(.template)
                    .frame(width: 28,height: 28).padding()
            }.background(Color.blue)
                .foregroundStyle(Color.white)
                .clipShape(Circle())
                .padding()
                .fullScreenCover(isPresented: $showNewTweetView) {
                    NewTweetView()
                }
        }
    }
}

#Preview {
    FeedView()
}
