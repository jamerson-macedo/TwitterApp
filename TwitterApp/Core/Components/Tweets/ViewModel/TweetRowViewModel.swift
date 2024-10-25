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
    
    
    init(tweet: Tweet, _ isRetweeting: Bool) {
        self.tweet = tweet
        self.isRetweeting = isRetweeting
        checkIfUserLikedTweet()
        checkIfUserRetweetedTweet()
        
    }
    
   
    func likeTweet() {
        // Se já estiver processando, não executa novamente
        guard !isProcessing else { return }
        isProcessing = true  // Inicia a operação

        TweetService.shared.likeTweet(tweet) { [weak self] in
            guard let self = self else { return }
            self.tweet.didLike = true
            self.tweet.likes += 1
            self.isProcessing = false
        }
    }
    func unlikeTweet(){
        guard !isProcessing else { return }
        TweetService.shared.unlikeTweet(tweet){[weak self] in
            guard let self = self else { return }
            self.tweet.didLike = false
            self.tweet.likes -= 1
            self.isProcessing = false
        
        }
    }
    // so para atualizar a view
    func checkIfUserLikedTweet(){
        TweetService.shared.checkIfUserLikedTweet(tweet){[weak self]  didlike in
            if didlike{
                guard let self = self else { return }
                self.tweet.didLike = true
            }
            
        }
    }
    func retweet(){
        TweetService.shared.retweet(tweet)
        
        self.tweet.didRetweet = true
        self.tweet.numberOfRetweets += 1
     
    }
    func unRetweet(){
        TweetService.shared.unRetweet(tweet)
        self.tweet.didRetweet = false
        self.tweet.numberOfRetweets -= 1
        
    }
    
    func checkIfUserRetweetedTweet(){
        TweetService.shared.checkIfUserRetweet(tweet){[weak self] didRetweet in
            if didRetweet{
                guard let self = self else { return }
                self.tweet.didRetweet = true
            }
            
        }
    }
}

