//
//  NewTwitterViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//

import Foundation
class NewTwitterViewModel: ObservableObject {
    
    @Published var didUploadTweet : Bool = false
    let  service = TweetService()
    
    func postTweet(text: String) {
        service.uploadTweet(text){ success in
            if success {
               // dismisss
                self.didUploadTweet = true
            }
            else {
                // show error message
                
            }
        }
    }
}
