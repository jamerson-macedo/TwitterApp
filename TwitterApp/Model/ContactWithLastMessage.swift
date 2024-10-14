//
//  ContactWithLastMessage.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation

struct ContactWithLastMessage: Identifiable {
    var id: String { user.id ?? UUID().uuidString }
    let user: User
    let lastMessage: Messages?
}
