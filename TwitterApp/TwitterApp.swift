//
//  TwitterAppApp.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI
import Firebase
@main
struct TwitterApp: App {
    @StateObject var viewModel = AuthViewModel()
    init(){
        // iniciar o firebase
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }.environmentObject(viewModel)
        }
    }
}
