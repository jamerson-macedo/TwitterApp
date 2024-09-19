//
//  CommentsViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
class CommentsViewModel : ObservableObject {
    @Published var comments: [Comments] = []
    @Published var tweet: Tweet
    private let commentsService = TweetService()
    
    init(tweet : Tweet) {
        self.tweet = tweet
        fetchComments()
        
    }
    func addComment(commentText: String, completion : @escaping (String?)->Void) {
        commentsService.addComments(tweet: tweet, commentText: commentText){ newcomment in
            if let newcomment = newcomment {
                DispatchQueue.main.async {
                    self.comments.append(newcomment)
                    // tenho que retornar para a view o id do novo comentario para a view atualizar
                    completion(newcomment.id)
                }
            }
            
        }
    }
    
    func fetchComments() {
        commentsService.fetchComments(tweet: tweet){ comments in
            
            DispatchQueue.main.async {
                self.comments = comments
            }
            print(comments.count)
        }
    }
}
