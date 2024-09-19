//
//  ComentsRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import SwiftUI
import FirebaseCore
struct CommentsRowView: View {
    @ObservedObject var viewmodel : CommentsRowViewModel
    init(comments : Comments) {
        self.viewmodel = CommentsRowViewModel(comments: comments)
    }
    var body: some View {
        VStack {
            HStack{
                if let user = viewmodel.comments.user {
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    Text(user.username)
                    
                }
            }
            Text(viewmodel.comments.comments)
        }
        
    }
}

//#Preview {
//    CommentsRowView( comments: [Comments(comments: "o que foi ussi", timestamp: Timestamp.init())])
//}
