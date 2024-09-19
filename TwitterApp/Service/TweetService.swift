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
// MARK: - LIKES
extension TweetService{
    func likeTweet(_ tweet : Tweet, completion : @escaping()-> Void){
        // o usuario que clicou
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // referencia do tweet
        guard let tweetId = tweet.id else { return }
        // referencia para a nova tabela
        let userLikesRef = Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-likes")
       
        // referencia para atualizar o objeto do tweet
        Firestore
            .firestore()
            .collection("tweets")
            .document(tweetId)
            .updateData(["likes":tweet.likes + 1]){ _ in
                // passa so o id pra ficar registrado
                userLikesRef.document(tweetId).setData([:]){ error in
                    completion()
                }
        }
        
    }
    func unlikeTweet(_ tweet : Tweet, completion : @escaping()-> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // referencia do tweet
        guard let tweetId = tweet.id else { return }
        // verifico se o tweet ja ta maior que 0
        // so entra aqui se for maior que 1
        guard tweet.likes > 0 else { return }
        
        let userLikesRef = Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-likes")
        
        Firestore
            .firestore()
            .collection("tweets")
            .document(tweetId)
            .updateData(["likes":tweet.likes - 1]){ _ in
                    // depois tem que deletar la do users-likes
                userLikesRef.document(tweetId).delete{ error in
                    completion()
                    
                }
                
            }
        
    }
    func checkIfUserLikedTweet(_ tweet : Tweet, completion : @escaping(Bool)-> Void){
        // vejo minha lista de likes
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-likes")
            .document(tweetId).getDocument(){ document, error in
                // se o documento existir então deu like
                guard let document = document else { return }
                completion(document.exists)
            }
    }
    func fetchLikesTweets(forUid uid : String, completion : @escaping ([Tweet]) -> Void){
        var tweets = [Tweet]()
        // primeiro vou na colecao que os usuairos deram like e vou pehar so o id que tem la
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-likes").getDocuments{ documents, error in
                // me retorna so os ids
                guard let documents = documents?.documents else { return }
                documents.forEach { doc in
                    // para cada um dos ids eu vou buscar eles agora
                 
                    let tweetId = doc.documentID
                    Firestore.firestore().collection("tweets").document(tweetId)
                        .getDocument(){ document, error in
                            guard let tweet = try? document?.data(as:Tweet.self) else { return }
                            tweets.append(tweet)
                            completion(tweets)
                    }
                    
                }
               
            }
    }
}
