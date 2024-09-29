//
//  TwitterAppApp.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
@main
struct TwitterApp: App {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Verifica se o Facebook pode lidar com o URL
        let handledByFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        // Verifica se o Google pode lidar com o URL
        let handledByGoogle = GIDSignIn.sharedInstance.handle(url)
        
        // Retorna true se qualquer um dos serviços conseguiu lidar com o URL
        return handledByFacebook || handledByGoogle
    }

    
    
    // essa instancia fica por todo o app
    @StateObject var viewModel = AuthViewModel()
    @StateObject var notificationsViewModel = NotificationsViewModel()
    
    init(){
        // iniciar o firebase
        FirebaseApp.configure()
        // Inicializar Facebook SDK
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                didFinishLaunchingWithOptions: nil
            )
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(viewModel)
            .environmentObject(notificationsViewModel)
        }
    }
}
