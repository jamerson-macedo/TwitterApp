//
//  CommentsViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: [Comments] = []
    @Published var tweet: Tweet
    @Published var user: User?
    
    init(tweet: Tweet) {
        self.tweet = tweet
        fetchComments()
    }
    
    func addComment(commentText: String, completion: @escaping (String?) -> Void) {
        TweetService.shared.addComments(tweet: tweet, commentText: commentText) { [weak self] newComment in
            guard let self = self, let newComment = newComment else {
                completion(nil)
                return
            }
            self.comments.append(newComment)
            self.tweet.numberOfComments += 1
            completion(newComment.id)
        }
    }
    func fetchComments() {
        TweetService.shared.fetchComments(tweet: tweet) { [weak self] comments in
            guard let self = self else { return }
            self.comments = comments
        }
    }
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let fetchedUser = try await UserService.shared.fetchUser(withUid: uid)
            self.user = fetchedUser
        } catch {
            print("Erro ao buscar usuário: \(error.localizedDescription)")
        }
    }
}
