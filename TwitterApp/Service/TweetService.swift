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
    func uploadTweet(_ tweet: String,image : String?, completion : @escaping (Bool) -> Void) {
        // id do usuario
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // objeto do twitter
        let data = ["uid":uid,
                    "tweet":tweet,
                    "likes" : 0,
                    "numberOfComments" : 0,
                    "numberOfRetweets" : 0,
                    "timestamp" : Timestamp(date: Date()),
                    "imageTweet" : image
        ] as [String : Any?]
        // criei um doc com id aleatorio e dentro dele tem o id do usuario e os dados do twitter
        Firestore.firestore().collection("tweets").document().setData(data as [String : Any]) { error in
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
// MARK: - COMMENTS
extension TweetService{
    
    func addComments(tweet: Tweet, commentText: String, completion: @escaping (Comments?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
              let tweetId = tweet.id else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let tweetsRef = db.collection("tweets").document(tweetId)
        
        // Busca os dados do usuário
        db.collection("users").document(userId).getDocument { documentSnapshot, error in
            if let error = error {
                print("Erro ao buscar dados do usuário: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Usa compactMap para criar o objeto `User` se os dados existirem
            let user = documentSnapshot?.data().flatMap { data in
                User(
                    id: userId,
                    fullname: data["fullname"] as? String ?? "Unknown",
                    profileImageUrl: data["profileImageUrl"] as? String ?? "",
                    username: data["username"] as? String ?? "Unknown",
                    email: data["email"] as? String ?? "Unknown",
                    following: data["following"] as? Int ?? 0,
                    followers: data["followers"] as? Int ?? 0
                    
                )
            }
            
            guard let user = user else {
                print("Dados do usuário não encontrados")
                completion(nil)
                return
            }
            
            // Cria o novo comentário
            let newComment = Comments(
                id: UUID().uuidString,
                comments: commentText,
                timestamp: Timestamp(date: Date()),
                user: user
            )
            
            // Dados para persistir no Firestore
            let newCommentRef = [
                "uid": userId,
                "commentText": commentText,
                "timestamp": Timestamp(date: Date())
            ] as [String: Any]
            
            // Adiciona o comentário no Firestore
            tweetsRef.collection("comments").addDocument(data: newCommentRef) { error in
                if let error = error {
                    print("Erro ao adicionar comentário: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    print("Comentário adicionado com sucesso")
                    tweetsRef.updateData(["numberOfComments": tweet.numberOfComments + 1])
                    completion(newComment)
                }
            }
        }
    }
    
    func fetchComments(tweet: Tweet, completion: @escaping ([Comments]) -> Void) {
        guard let tweetId = tweet.id else { return }
        var commentList: [Comments] = []
        let db = Firestore.firestore()
        
        let tweetsRef = db.collection("tweets").document(tweetId).collection("comments")
        
        // DispatchGroup para garantir que as buscas assíncronas sejam concluídas
        let group = DispatchGroup()
        
        tweetsRef.order(by: "timestamp", descending: false).getDocuments { querySnapshot, error in
            if let error = error {
                print("DEBUG error fetching comments: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([]) // Retorna uma lista vazia se não houver documentos
                return
            }
            
            for doc in documents {
                let data = doc.data()
                let commentText = data["commentText"] as? String
                let timestamp = data["timestamp"] as? Timestamp
                guard let userId = data["uid"] as? String else { continue }
                
                // Entra no DispatchGroup para cada comentário
                group.enter()
                
                // Busca os dados do usuário
                db.collection("users").document(userId).getDocument { userSnapshot, error in
                    defer { group.leave() } // Sai do DispatchGroup após a busca ser concluída
                    
                    if let error = error {
                        print("DEBUG error fetching user: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let userData = userSnapshot?.data() else { return }
                    let user = User(
                        id: userId,
                        fullname: userData["fullname"] as? String ?? "Unknown",
                        profileImageUrl: userData["profileImageUrl"] as? String ?? "",
                        username: userData["username"] as? String ?? "Unknown",
                        email: userData["email"] as? String ?? "Unknown",
                        following: userData["following"] as? Int ?? 0,
                        followers: userData["followers"] as? Int ?? 0
                        
                    )
                    
                    // Cria o objeto Comment
                    let comment = Comments(
                        id: doc.documentID,
                        comments: commentText ?? "",
                        timestamp: timestamp ?? Timestamp(),
                        user: user
                    )
                    
                    // Adiciona o comentário à lista
                    commentList.append(comment)
                }
            }
            
            // Quando todas as buscas forem concluídas, chamamos o completion handler
            group.notify(queue: .main) {
                completion(commentList)
            }
        }
    }
    
}
// MARK: - RETWEETS
extension TweetService{
    func retweet(_ tweet: Tweet){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else{return}
        let db = Firestore.firestore()
        let tweetsRef = db.collection("tweets").document(tweetId)
        
        let userLikesRef = Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-retweets")
        userLikesRef.document(tweetId).setData([:]){ error in
            if let error{
                print("Error retweeting tweet: \(error.localizedDescription)")
            }else {
                tweetsRef.updateData(["numberOfRetweets": tweet.numberOfRetweets + 1])
                print("RETWEEETED SUCCESSFULLY")
            }
            
        }
        
        
    }
    func unRetweet(_ tweet: Tweet){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else{return}
        let db = Firestore.firestore()
        let tweetsRef = db.collection("tweets").document(tweetId)
        
        let userRetweet = Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-retweets")
        userRetweet.document(tweetId).delete{ error in
            if let error{
                print("Error retweeting tweet: \(error.localizedDescription)")
            }else {
                tweetsRef.updateData(["numberOfRetweets": tweet.numberOfRetweets + 1])
                print("RETWEEETED SUCCESSFULLY")
            }
            
        }
        
        
    }
    
    
    func fetchReTweets(forUid uid : String, completion : @escaping ([Tweet]) -> Void){
        var tweets = [Tweet]()
        // primeiro vou na colecao que os usuairos deram like e vou pehar so o id que tem la
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-retweets").getDocuments{ documents, error in
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
    func checkIfUserRetweet(_ tweet : Tweet, completion : @escaping(Bool)-> Void){
        // vejo minha lista de likes
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .collection("users-retweets")
            .document(tweetId).getDocument(){ document, error in
                // se o documento existir então deu like
                guard let document = document else { return }
                completion(document.exists)
            }
    }
}
extension TweetService{
    // pegando o id de todos usuarios que sigo
    func fetchFollowingUserIDs(completion: @escaping ([String]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Erro: UID do usuário atual não encontrado")
            return
        }
        
        Firestore.firestore()
            .collection("users")
            .document(currentUserId)
            .collection("following")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Erro ao buscar usuários seguidos: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Erro: Nenhum documento encontrado na subcoleção 'following'")
                    completion([])  // Retorna lista vazia se não houver documentos
                    return
                }
                
                let userIDs = documents.compactMap { $0.documentID }
                print("Usuários seguidos (IDs): \(userIDs)")  // Log para verificar os IDs obtidos
                completion(userIDs)
            }
    }
    func fetchTweetsOfFollowedUsers(completion: @escaping ([Tweet]) -> Void) {
        fetchFollowingUserIDs { userIDs in
            guard !userIDs.isEmpty else {
                completion([]) // Se o usuário não seguir ninguém, retorna uma lista vazia
                print("CHEGOU AQUI")
                return
            }
            
            Firestore.firestore()
                .collection("tweets")
                .whereField("uid", in: userIDs) // Filtro para buscar tweets apenas dos usuários seguidos
                .order(by: "timestamp", descending: true)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        completion([])  // Retorna uma lista vazia em caso de erro
                        print("Erro ao buscar tweets: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        completion([])  // Retorna uma lista vazia se não houver documentos
                        return
                    }
                    
                    let tweets = documents.compactMap { query in
                        try? query.data(as: Tweet.self)
                    }
                    
                    completion(tweets)
                    print("DEBUG ITENS BUSCADOS: \(tweets)")
                }
        }
    }
    
}
