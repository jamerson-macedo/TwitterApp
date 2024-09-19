//
//  TweetRowViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 18/09/24.
//
import Foundation
class TweetRowViewModel: ObservableObject{
    @Published var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        checkIfUserLikedTweet()
    }
    let service = TweetService()
    func likeTweet(){
        service.likeTweet(tweet){
            self.tweet.didLike = true
            self.tweet.likes += 1 
        }
    }
    func unlikeTweet(){
        service.unlikeTweet(tweet){
            self.tweet.didLike = false
            self.tweet.likes -= 1
        
        }
    }
    // so para atualizar a view
    func checkIfUserLikedTweet(){
        service.checkIfUserLikedTweet(tweet){ didlike in
            if didlike{
                self.tweet.didLike = true
            }
            
        }
    }
}

