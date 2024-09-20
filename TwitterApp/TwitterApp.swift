//
//  TwitterAppApp.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
@main
struct TwitterApp: App {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    // essa instancia fica por todo o app
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        // iniciar o firebase
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(viewModel)
        }
    }
}
