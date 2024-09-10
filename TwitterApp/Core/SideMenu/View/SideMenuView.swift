//
//  SideMenuView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        // se exister um usuario
        if let user = authViewModel.currentUser{
            VStack(alignment:.leading,spacing: 43){
                VStack(alignment:.leading){
                    AsyncImage(url: URL(string: user.profileImageUrl)){ image in
                        image.resizable().frame(width: 50,height: 50).clipShape(Circle())
                        
                    }placeholder: {
                        ProgressView()
                    }
                    VStack(alignment:.leading,spacing:4){
                        Text(user.fullname).font(.headline).bold()
                        Text("@\(user.username)").font(.caption).foregroundStyle(Color.gray)
                        UserStatsView().padding(.vertical)
                    }
                }
                
                ForEach(SideMenuViewModel.allCases,id:\.rawValue){ viewmodel in
                    if viewmodel == .profile{
                        NavigationLink{
                            ProfileView(user: user)
                        } label: {
                            SideMenuRowView(viewmodel: viewmodel)
                        }
                    }else if viewmodel == .logout{
                        Button(action: {authViewModel.signOut()}, label: {
                            SideMenuRowView(viewmodel: viewmodel)
                        })
                    }
                    else {
                        SideMenuRowView(viewmodel: viewmodel)
                    }
                    
                    
                    
                    
                }
                Spacer()
            }.padding(.horizontal)
        }
    }
}



#Preview {
    SideMenuView().environmentObject(AuthViewModel())
}

