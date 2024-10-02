//
//  CommentsRowViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 19/09/24.
//

import Foundation

class CommentsRowViewModel : ObservableObject {
    @Published var comments: Comments
    init(comments: Comments) {
        self.comments = comments
    }
}
