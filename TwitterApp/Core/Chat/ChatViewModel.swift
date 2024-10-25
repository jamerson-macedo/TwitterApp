//
//  ChatViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation
import FirebaseFirestore
class ChatViewModel: ObservableObject {
    @Published var messages: [Messages] = []
    
    func sendMessage(message:String,toUser : User) {
        messages.append(Messages(text: message, isMe: true, timeStamp: Timestamp()))
    }
    
}
