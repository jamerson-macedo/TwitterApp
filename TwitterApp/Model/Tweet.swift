//
//  Tweet.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import FirebaseFirestore
struct Tweet : Identifiable,Decodable {
    @DocumentID var id : String?
    let uid : String
    let tweet : String
    var likes : Int
    let timestamp : Timestamp
    
    var user : User?
}

