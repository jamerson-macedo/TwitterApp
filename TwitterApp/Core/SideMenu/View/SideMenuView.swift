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
        VStack(alignment:.leading,spacing: 43){
            VStack(alignment:.leading){
                Circle().frame(width: 50,height: 50)
                VStack(alignment:.leading,spacing:4){
                    Text("Jamerson").font(.headline).bold()
                    Text("@Jamerson").font(.caption).foregroundStyle(Color.gray)
                    UserStatsView().padding(.vertical)
                }
            }
            
            ForEach(SideMenuViewModel.allCases,id:\.rawValue){ viewmodel in
                if viewmodel == .profile{
                    NavigationLink{
                        ProfileView()
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


#Preview {
    SideMenuView()
}

