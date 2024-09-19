//
//  ProfileViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
class ProfileViewModel: ObservableObject {
    @Published var tweets: [Tweet] = []
    @Published var likedTweets: [Tweet] = []
    private let twitterService = TweetService()
    private let userService = UserService()
    // aqui to com o usuario clicado
    @Published var user: User
    init (user: User) {
        self.user = user
        self.fetchTweetsById()
        self.fetchLikedTweets()
    }
    func fetchTweetsById() {
        // pego o id dele atual que veio do click
        guard let uid = user.id else { return }
        // vou buscar os twitters pelo id
     
        twitterService.fetchTweetsById(forUid: uid) { tweets in
            // os twitters que tiver o id dele dentro vem todos pra ca
            self.tweets = tweets
            //
           // para cada twitter que veio
            for i in 0..<tweets.count {
                // associo cada twitter a o usuario
                self.tweets[i].user = self.user
            }
            
        }
    }
    func fetchLikedTweets() {
        guard let uid = user.id else { return }
        twitterService.fetchLikesTweets(forUid: uid){ likedTweets in
            self.likedTweets = likedTweets
            print("DEBUG : \(likedTweets.count)")
            for i in 0..<likedTweets.count{
                // percorre todos os twitter e adiciona oid
                let uid = likedTweets[i].uid
                self.userService.fetchUser(withuid: uid){ user in
                    self.likedTweets[i].user = user
                    
                }
            }
            
        }
    }
    func tweets(filter : TweetFilterViewModel)->[Tweet]{
        switch filter{
        case .tweets:
            return tweets
        case .replies:
            return tweets
        case .likes:
            return likedTweets
        }
    }
    
}
