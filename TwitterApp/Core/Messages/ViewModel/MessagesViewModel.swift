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
    let service =  UserService.shared
    func getUsersLastMessage() {
        
    }
    func getAllUsers() {
        UserService.shared.fetchAllUsers { [weak self ] users in
            guard let self else {return}
            self.users = users
        }
    }
}
