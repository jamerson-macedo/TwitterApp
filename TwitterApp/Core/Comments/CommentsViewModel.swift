//
//  CommentsViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import Foundation

class CommentsViewModel : ObservableObject {
    @Published var comments: [Comments] = []
    
    @Published var tweet: Tweet
    private let commentsService = TweetService()
    
    init(tweet : Tweet) {
        self.tweet = tweet
        fetchComments()
    
    }
    func addComment(commentText : String) {
        commentsService.addComments(tweet: tweet, commentText: commentText)
    }
    func fetchComments() {
        commentsService.fetchComments(tweet: tweet){ comments in
            self.comments = comments
            print(comments.count)
        }
    }
}
