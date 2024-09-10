//
//  ExploreViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 10/09/24.
//

import Foundation
class ExploreViewModel : ObservableObject{
    
    @Published var allUsers : [User] = []
    private var service = UserService()
    init(){
        fetchAllUsers()
    }
    
    func fetchAllUsers(){
        service.fetchAllUsers { users in
            self.allUsers = users
        }
    }
}
