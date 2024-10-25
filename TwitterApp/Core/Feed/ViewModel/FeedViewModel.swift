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
    
    
    func fetchTweets() async {
        do {
            // Fetch dos tweets
            let fetchedTweets = try await TweetService.shared.fetchTweets()
            
            // Atualizar os tweets na main thread
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.tweets = fetchedTweets
            }

            // Fetch dos usuários para cada tweet de maneira assíncrona
            for i in 0..<fetchedTweets.count {
                let uid = fetchedTweets[i].uid
                if let user = try? await UserService.shared.fetchUser(withUid: uid) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.tweets[i].user = user
                    }
                }
            }

            // Fetch dos tweets dos usuários seguidos
            let fetchedFollowingTweets = try await TweetService.shared.fetchTweetsOfFollowedUsers()
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.followingTweets = fetchedFollowingTweets
            }

            // Fetch dos usuários para os tweets dos usuários seguidos
            for i in 0..<fetchedFollowingTweets.count {
                let uid = fetchedFollowingTweets[i].uid
                if let user = try? await UserService.shared.fetchUser(withUid: uid) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.followingTweets[i].user = user
                    }
                }
            }

        } catch {
            print("Erro ao carregar tweets: \(error)")
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
