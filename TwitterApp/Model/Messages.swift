//
//  Messages.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation
import FirebaseFirestore
struct Messages :Identifiable,Decodable{
    @DocumentID var id : String?
    let text : String
    let isMe : Bool
    let timeStamp : Timestamp
}
