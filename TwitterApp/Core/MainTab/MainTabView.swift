//
//  MainTabView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var authViewmodel : AuthViewModel
    var body: some View {
        TabView(selection: $selectedIndex){
            FeedView().tabItem {
                Image(systemName: "house")
            }.tag(0)
            ExploreView().tabItem {
                Image(systemName: "magnifyingglass")
            }.tag(1)
            MessagesView().tabItem {
                Image(systemName: "envelope")
            }.tag(2)
            NotificationsView().tabItem {
                Image(systemName: "bell")
            }.tag(3)
            ProfileView(user: authViewmodel.currentUser!, isFollowing: false).tabItem {
                Image(systemName: "person")
            }.tag(4)
           
        }
    }
}

#Preview {
    MainTabView()
}
