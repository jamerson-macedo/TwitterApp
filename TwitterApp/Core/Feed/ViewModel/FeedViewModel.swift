//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
class FeedViewModel : ObservableObject{
    @Published var tweets: [Tweet] = []
    
    let userService = UserService()
    let service = TweetService()
    
    init(){
        fetchTweets()
    }
    func fetchTweets(){
        
        service.fetchTweets { tweets in
            // preencho a lista com os twitters e depois preencho os usuarios
            self.tweets = tweets
            
            for i in 0..<tweets.count{
                // percorre todos os twitter e adiciona oid
                let uid = tweets[i].uid
                self.userService.fetchUser(withuid: uid){ user in
                    self.tweets[i].user = user
                    
                }
            }
            
            
        }
    }
}
