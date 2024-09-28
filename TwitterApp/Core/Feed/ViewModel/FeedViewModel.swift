//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
class FeedViewModel : ObservableObject{
    @Published var tweets: [Tweet] = []
    @Published var followingTweets : [Tweet] = []
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
        service.fetchTweetsOfFollowedUsers{ tweets in
            self.followingTweets = tweets
            for i in 0..<tweets.count{
                let uid = tweets[i].uid
                self.userService.fetchUser(withuid: uid){ user in
                    self.followingTweets[i].user = user
                }
                
            }
        }
        
        
    }
  
    func tweets(filter : FeedFilter)->[Tweet]{
        switch filter{
        case .foryou:
            return tweets
        case .following:
            return followingTweets// retornar apenas do que eu sigo
        }
    }
}
enum FeedFilter : Int, CaseIterable{
    case foryou
    case following
    
    var title:String{
        switch self{
        case .foryou : return  "For you"
        case .following : return  "Following"
        }
    }
}
