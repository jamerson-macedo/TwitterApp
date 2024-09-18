//
//  TweetService.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import FirebaseAuth
import Foundation
import FirebaseFirestore
struct TweetService {
    func uploadTweet(_ tweet: String, completion : @escaping (Bool) -> Void) {
        // id do usuario
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // objeto do twitter
        let data = ["uid":uid,
                    "tweet":tweet,
                    "likes" : 0,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        // criei um doc com id aleatorio e dentro dele tem o id do usuario e os dados do twitter
        Firestore.firestore().collection("tweets").document().setData(data) { error in
            if let error = error{
                completion(false)
                print(error)
                return
            }
            completion(true)
            
        }
    }
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        Firestore.firestore()
            .collection("tweets")
            .order(by: "timestamp",descending: true)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    completion([])
                    print(error)
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                let tweets = documents.compactMap{ query in
                    try? query.data(as: Tweet.self)
                }
                //let tweets = querySnapshot.documents.encode(to: [Tweet].self)
                completion(tweets)
            }
    }
    func fetchTweetsById(forUid uid : String, completion : @escaping ([Tweet]) -> Void){
        Firestore.firestore()
            .collection("tweets")
       
            .whereField("uid", isEqualTo: uid)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    completion([])
                    print(error)
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                let tweets = documents.compactMap{ query in
                    try? query.data(as: Tweet.self)
                }
                //let tweets = querySnapshot.documents.encode(to: [Tweet].self)
                completion(tweets.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()}))
            }
    }
    
}
