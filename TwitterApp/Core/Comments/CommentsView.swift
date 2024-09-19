//
//  CommentsView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import SwiftUI
import FirebaseCore
struct CommentsView: View {
    @ObservedObject var viewmodel : CommentsViewModel
    @State var comments = ""
    init (tweet : Tweet) {
        self.viewmodel = CommentsViewModel(tweet:tweet)
    }
    
    var body: some View {
        VStack{
            Text("Comments")
            Spacer()
            ScrollView{
                ForEach(viewmodel.comments){ comments in
                    CommentsRowView(comments: comments)
                }
            }
            HStack{
                TextField("Add a comment", text: $comments)
                Button{
                    viewmodel.addComment(commentText: comments)
                }label: {
                    Image(systemName: "paperplane.fill")
                }
            }.padding()
        }.onAppear{
            viewmodel.fetchComments()
        }
    }
}

#Preview {
    CommentsView(tweet: Tweet(uid: "", tweet: "Ola mundo", likes: 1, timestamp: Timestamp()))
}
