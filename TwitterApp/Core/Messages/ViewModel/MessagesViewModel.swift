//
//  MessagesViewMode.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class MessagesViewModel : ObservableObject {
    @Published var messages: [ContactWithLastMessage] = []
    @Published var users : [User] = []
    let service =  UserService()
    func getUsersLastMessage() {
        
    }
    func getAllUsers() {
        service.fetchAllUsers { users in
            self.users = users
        }
    }
}
