//
//  SideMenuView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        
        if let user = authViewModel.currentUser {
            VStack(alignment: .leading, spacing: 43) {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView().frame(width: 80, height: 80)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .font(.title2)
                            .bold()
                            .padding(.top,10)
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        UserStatsView(user: authViewModel.currentUser!)
                            .padding(.vertical)
                    }
                }

                ForEach(SideMenuViewModel.allCases, id: \.rawValue) { viewmodel in
                    if viewmodel == .profile {
                        
                        NavigationLink(destination: ProfileView(user: user,isFollowing:  false)) {
                          
                            SideMenuRowView(viewmodel: viewmodel)
                            
                        }
                    } else if viewmodel == .logout {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            SideMenuRowView(viewmodel: viewmodel)
                        }
                    } else {
                        SideMenuRowView(viewmodel: viewmodel)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
#Preview {
    SideMenuView().environmentObject(AuthViewModel())
}

