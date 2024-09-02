//
//  SideMenuViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//
// fazer dessa forma fica mais facil a manutenção
import Foundation
enum SideMenuViewModel : Int,CaseIterable{
    case profile
    case lists
    case bookmarks
    case logout
    
    var description : String{
        switch self{
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .bookmarks:return "Bookmarks"
        case .logout: return "logout"
        }
    }
    var imageName : String{
        switch self{
        case .profile: return "person"
        case .lists: return "list.bullet"
        case .bookmarks:return "bookmark"
        case .logout: return "arrow.left.square"
        }
    }
}
