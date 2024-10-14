//
//  ChatViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import Foundation
class ChatViewModel: ObservableObject {
    @Published var messages: [Messages] = []
}
