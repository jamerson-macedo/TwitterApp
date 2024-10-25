//
//  ProfileViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
import FirebaseAuth
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var tweets: [Tweet] = []
    @Published var likedTweets: [Tweet] = []
    @Published var reTweets : [Tweet] = []
    @Published var ISFollowing: Bool = false
    // Estado reativo que a View irá observar
    
    // aqui to com o usuario clicado
    @Published var user: User
    init (user: User) {
        self.user = user
        self.fetchTweetsById()
       // self.fetchLikedTweets()
        self.isFollowing()
       // self.fetchReTweetsById()
        
    }
    func fetchTweetsById() {
        // pego o id dele atual que veio do click
        guard let uid = user.id else { return }
        // vou buscar os twitters pelo id
        
        TweetService.shared.fetchTweetsById(forUid: uid) {[weak self] tweets in
            // os twitters que tiver o id dele dentro vem todos pra ca
            guard let self else { return }
            self.tweets = tweets
            //
            // para cada twitter que veio
            for i in 0..<tweets.count {
                // associo cada twitter a o usuario
                self.tweets[i].user = self.user
            }
            
        }
    }
    func fetchLikedTweets() async {
        guard let uid = user.id else { return }
        
        // Buscando os tweets que foram curtidos
        do {
            let likedTweets = try await TweetService.shared.fetchLikedTweets(forUid: uid)
            self.likedTweets = likedTweets
            
            // Iterando sobre os tweets e buscando os usuários correspondentes de forma assíncrona
            for i in 0..<likedTweets.count {
                let uid = likedTweets[i].uid
                if let user = try? await UserService.shared.fetchUser(withUid: uid) {
                    self.likedTweets[i].user = user
                }
            }
        } catch {
            print("Erro ao buscar os tweets curtidos: \(error.localizedDescription)")
        }
    }

    func followUser(){
        
        guard let followerID = user.id else { return }
        UserService.shared.followUser(followingUserID:followerID)
        self.ISFollowing.toggle()
        self.user.followers += 1
    }
    func unfollowUser() {
        guard let followerID = user.id else { return }
        UserService.shared.unfollowUser(followingUserID: followerID)
        // Atualiza o estado de forma imediata
        self.ISFollowing.toggle()
        self.user.followers -= 1
    }
    
    func isFollowing() {
        guard let followerID = user.id else { return }
        UserService.shared.isFollowing(userId: followerID) { isFollowing in
            self.ISFollowing = isFollowing  // Atualiza o estado local com base na verificação
        }
    }
    func toggleFollowState() {
            if ISFollowing {
                unfollowUser()
            } else {
                followUser()
            }
        }
    
    func fetchReTweetsById() async {
        guard let uid = user.id else { return }

        do {
            // Busca os retweets de forma assíncrona
            let reTweets = try await TweetService.shared.fetchReTweets(forUid: uid)
            self.reTweets = reTweets
            
            // Itera pelos retweets e busca o usuário associado de forma assíncrona
            for i in 0..<reTweets.count {
                let uid = reTweets[i].uid
                if let user = try? await UserService.shared.fetchUser(withUid: uid) {
                    self.reTweets[i].user = user
                }
            }
        } catch {
            print("Erro ao buscar os retweets: \(error.localizedDescription)")
        }
    }

    func tweets(filter : TweetFilterViewModel)->[Tweet]{
        switch filter{
        case .tweets:
            return tweets
        case .replies:
            return reTweets
        case .likes:
            return likedTweets
        }
    }
    
}
