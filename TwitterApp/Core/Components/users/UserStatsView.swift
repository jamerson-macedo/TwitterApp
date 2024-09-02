//
//  UserStatsView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct UserStatsView: View {
    var body: some View {
        HStack(spacing:24){
            HStack(spacing:4){
                Text("2").font(.subheadline).bold()
                Text("Following").foregroundStyle(Color.gray)
            }
          
            HStack(spacing:4){
                Text("2").font(.subheadline).bold()
                Text("Followers").foregroundStyle(Color.gray)
            }
        }
    }
}

#Preview {
    UserStatsView()
}
