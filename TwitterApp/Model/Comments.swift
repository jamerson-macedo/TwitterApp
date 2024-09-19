//
//  Comments.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import FirebaseFirestore
struct Comments : Identifiable,Decodable {
    @DocumentID var id : String?
    let comments : String

    let timestamp : Timestamp

    var user : User?
}
