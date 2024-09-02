//
//  TweetFilterViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import Foundation
enum TweetFilterViewModel : Int, CaseIterable{
    case tweets
    case replies
    case likes
    
    var title:String{
        switch self{
        case .tweets : return  "Tweets"
        case .replies : return  "Replies"
        case .likes : return  "Likes"
        }
    }
}
