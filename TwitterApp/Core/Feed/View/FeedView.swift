//
//  FeedView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        ScrollView{
            LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                ForEach(1...10, id: \.self) { _ in
                    TweetRowView().padding()
                }
            })
        }
    }
}

#Preview {
    FeedView()
}
