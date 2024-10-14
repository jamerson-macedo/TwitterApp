//
//  ContactsViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation
class ContactsViewModel: ObservableObject {
    @Published var contacts: [User] = []
}
