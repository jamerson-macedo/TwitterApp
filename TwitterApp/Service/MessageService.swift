//
//  MessageService.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 15/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
struct MessageService {
    
    static let shared = MessageService()
    private let db = Firestore.firestore()
    private init() {}  // Impede a criação de outras instâncias
    
    func sendMessage(text : String, user : User) {
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Date().timeIntervalSince1970
        guard let userId = user.id else { return }
        
        Firestore.firestore().collection("conversations")
            .document(fromId)
            .collection(user.id!)
            .addDocument(data: [
                "text": text,
                "fromId": fromId,
                "toId": userId,
                "timestamp": UInt(timestamp)
            ]) { err in
                if err != nil {
                    print("ERROR: \(err!.localizedDescription)")
                    return
                }
                
                Firestore.firestore().collection("last-messages")
                    .document(fromId)
                    .collection("contacts")
                    .document(userId)
                    .setData([
                        "uid": userId,
                        "username": user.username,
                        "photoUrl": user.profileImageUrl,
                        "timestamp": UInt(timestamp),
                        "lastMessage": text
                    ])
            }
        
        
        Firestore.firestore().collection("conversations")
            .document(userId)
            .collection(fromId)
            .addDocument(data: [
                "text": text,
                "fromId": fromId,
                "toId": userId,
                "timestamp": UInt(timestamp)
            ]) { err in
                if err != nil {
                    print("ERROR: \(err!.localizedDescription)")
                    return
                }
                
                Firestore.firestore().collection("last-messages")
                    .document(userId)
                    .collection("contacts")
                    .document(fromId)
                    .setData([
                        "uid": fromId,
                        "username": user.username,
                        "photoUrl": user.profileImageUrl,
                        "timestamp": UInt(timestamp),
                        "lastMessage": text
                    ])
            }
    }
}
