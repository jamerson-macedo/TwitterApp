//
//  UserStatsView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct UserStatsView: View {
    let user : User
    var body: some View {
        HStack(spacing:24){
            HStack(spacing:4){
                Text("\(user.followers)").font(.subheadline).bold()
                Text("Followers").foregroundStyle(Color.gray)
            }
          
            HStack(spacing:4){
                Text("\(user.following)").font(.subheadline).bold()
                Text("Following").foregroundStyle(Color.gray)
            }
        }
    }
}


