//
//  ExploreViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 10/09/24.
//

import Foundation
class ExploreViewModel : ObservableObject{
    
    @Published var allUsers : [User] = []
    @Published var searchText = ""
    
    var searchableUsers : [User]{
        if searchText.isEmpty {
            return allUsers
        }else{
            let lowercasedQuery = searchText.lowercased()
            
            return allUsers.filter { user in
                user.username.contains(lowercasedQuery) || user.fullname.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
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
