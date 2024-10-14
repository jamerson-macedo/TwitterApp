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
    @Published var messages: [User] = []
    let service =  UserService()
    func getUsersMessages() {
        service.fetchAllUsers { users in
            self.messages=users
            print(users)
        }
    }
}
