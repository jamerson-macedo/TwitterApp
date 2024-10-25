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

    init(){
        fetchAllUsers()
    }
    
    func fetchAllUsers(){
        UserService.shared.fetchAllUsers { [ weak self ] users in
            guard let self = self else { return }
            self.allUsers = users
        }
    }
}
