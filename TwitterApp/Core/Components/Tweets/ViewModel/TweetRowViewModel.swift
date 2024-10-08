//
//  TweetRowViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 18/09/24.
//
import Foundation
@MainActor
class TweetRowViewModel: ObservableObject{
    @Published var tweet: Tweet
    @Published var isProcessing = false // variavel para controlar o numero de cliques
    @Published var isRetweeting = false
    let service = TweetService()
    
    
    init(tweet: Tweet, _ isRetweeting: Bool) {
        self.tweet = tweet
        self.isRetweeting = isRetweeting
        checkIfUserLikedTweet()
        checkIfUserRetweetedTweet()
        
    }
    
   
    func likeTweet(){
        // se tiver carregando ja volta
        guard !isProcessing else { return }
        isProcessing = true  // Inicia a operação
        service.likeTweet(tweet){
            self.tweet.didLike = true
            self.tweet.likes += 1
            self.isProcessing = false
        }
    }
    func unlikeTweet(){
        guard !isProcessing else { return }
        service.unlikeTweet(tweet){
            self.tweet.didLike = false
            self.tweet.likes -= 1
            self.isProcessing = false
        
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
    func retweet(){
        service.retweet(tweet)
        
        self.tweet.didRetweet = true
        self.tweet.numberOfRetweets += 1
     
    }
    func unRetweet(){
        service.unRetweet(tweet)
        self.tweet.didRetweet = false
        self.tweet.numberOfRetweets -= 1
        
    }
    
    func checkIfUserRetweetedTweet(){
        service.checkIfUserRetweet(tweet){ didRetweet in
            if didRetweet{
                self.tweet.didRetweet = true
            }
            
        }
    }
}

