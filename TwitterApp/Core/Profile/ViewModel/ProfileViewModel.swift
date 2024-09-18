//
//  ProfileViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
class ProfileViewModel: ObservableObject {
    @Published var tweets: [Tweet] = []
    private let twitterService = TweetService()
    // aqui to com o usuario clicado
    @Published var user: User
    init (user: User) {
        self.user = user
        self.fetchTweetsById()
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
    
}
