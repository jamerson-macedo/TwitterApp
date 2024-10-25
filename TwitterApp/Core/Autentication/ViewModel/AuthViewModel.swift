//
//  AuthViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import FacebookCore
import FacebookLogin
class AuthViewModel : ObservableObject{
    // a trla principal ta observando essa variavel, se ela for nula vai pro login se não vai para a principal
    @Published var userSession: FirebaseAuth.User?
    //This property below is for The navigation to the profilePhotoSelectorView
    @Published var didAuthenticateUser = false
    // o usuario do retorno
    @Published var currentUser: User?
    
    private var tempUserSession: FirebaseAuth.User?
    
    init(){
        // quando iniciar se tiver usuario ele ja registra
        self.userSession = Auth.auth().currentUser
        Task{
           await self.fetchUser()
        }
        
     
    }
    func login(withEmail email : String, password : String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG : ", error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {return}
            self.userSession = user
            Task{
               await self.fetchUser()
            }        }
        
    }
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {return}
            
            
            self.tempUserSession = user
            
            //storing the user data into the firestore database
            let data = [
                "email": email,
                "username": username.lowercased(),
                "fullname": fullname,
                "uid": user.uid,
                "following" : 0,
                "followers" : 0
              
            ]
            // quando o usuario é criado ele abre a tela para colocar a foto
            Firestore.firestore().collection("users")
            
                .document(user.uid).setData(data) { _ in
                    self.didAuthenticateUser = true
                }
            
        }
    }
    func registerWithAuth(id: String ,withEmail email: String, fullname: String, username: String,profileImage : String) {
        
        
        //storing the user data into the firestore database
        let data = [
            "email": email,
            "username": username.lowercased(),
            "fullname": fullname,
            "uid": id,
            "profileImageUrl" : profileImage,
            "following" : 0,
            "followers" : 0
          
           
        ] as [String : Any]
        // quando o usuario é criado ele abre a tela para colocar a foto
        Firestore.firestore().collection("users")
        
            .document(id).setData(data) { _ in
            print("salvo no firebase")
            }
        
    }
    
    
    func signOut(){
        userSession = nil
        tempUserSession = nil
        try? Auth.auth().signOut()
      
    }
    func uploadProfileImage(_ image: UIImage) {
        //se o usuario temporario existir
        // sinal que ja foi feito o cadastro então ele faz o upload da imagem
        guard let uid = tempUserSession?.uid else {return}
        // faz o upload da url que retornou da função
        ImageUploade.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
                    Task{
                       await self.fetchUser()
                    }
                }
        }
    }
    func fetchUser() async {
        // Verifica se o usuário está autenticado
        guard let uid = self.userSession?.uid else { return }

        do {
            // Busca o usuário de maneira assíncrona
            let fetchedUser = try await UserService.shared.fetchUser(withUid: uid)
            
            // Atualiza a UI na main thread
            DispatchQueue.main.async {
                self.currentUser = fetchedUser
            }
        } catch {
            print("ERROR")
        }
    }

    
    // Função para obter o root view controller (para o Google Sign-In)
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        return root
    }
    func signUpWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { [unowned self] result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    // mostra error
                }
                // usuario autenticado
                guard let user = authResult?.user else {return}
                print(user)
                self.registerWithAuth(id: user.uid, withEmail: user.email ?? "usuario@gmal.com", fullname: user.displayName ?? "usuario 1", username: user.displayName ?? "@gmail",profileImage: user.photoURL?.absoluteString ?? "https://www.istockphoto.com/photos/user-profile")
                self.userSession = user
                Task{
                   await self.fetchUser()
                }
            }
        }
    }
    
    func signInWithFacebook() {
        let loginManager = LoginManager()
        
        // Solicita login com permissões de perfil público e e-mail
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            // Tratamento de erro caso algo falhe no processo de login
            if let error = error {
                print("Erro ao fazer login com o Facebook: \(error.localizedDescription)")
                return
            }
            
            // Verifica se o usuário cancelou o login
            guard let result = result, !result.isCancelled else {
                print("Login com o Facebook cancelado")
                return
            }
            
            // Obtem o token de acesso do Facebook
            guard let token = result.token?.tokenString else {
                print("Erro ao obter o token de acesso do Facebook")
                return
            }
            
            // Cria as credenciais do Firebase com o token do Facebook
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            // Faz o login no Firebase com as credenciais do Facebook
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
                    return
                }
                
                // Garante que obtemos o usuário autenticado
                guard let user = authResult?.user else {
                    print("Erro: Usuário não encontrado após autenticação.")
                    return
                }
                
                // Armazena a sessão do usuário
                self.userSession = user
                
                // Busca as informações completas do usuário
                Task{
                   await self.fetchUser()
                }
                print("Usuário autenticado com sucesso com o Facebook!")
            }
        }
    }
    func signUpWithFacebook() {
        let loginManager = LoginManager()
        
        // Solicita login com permissões de perfil público e e-mail
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            // Tratamento de erro caso algo falhe no processo de login
            if let error = error {
                print("Erro ao fazer login com o Facebook: \(error.localizedDescription)")
                return
            }
            
            // Verifica se o usuário cancelou o login
            guard let result = result, !result.isCancelled else {
                print("Login com o Facebook cancelado")
                return
            }
            
            // Obtem o token de acesso do Facebook
            guard let token = result.token?.tokenString else {
                print("Erro ao obter o token de acesso do Facebook")
                return
            }
            
            // Cria as credenciais do Firebase com o token do Facebook
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            // Faz o login no Firebase com as credenciais do Facebook
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
                    return
                }
                
                // Garante que obtemos o usuário autenticado
                guard let user = authResult?.user else {
                    print("Erro: Usuário não encontrado após autenticação.")
                    return
                }
                
                // Faz o registro no Google/Firebase com as informações do usuário
                self.registerWithAuth(
                    id: user.uid,
                    withEmail: user.email ?? "usuario@gmal.com",
                    fullname: user.displayName ?? "Usuario 1",
                    username: user.displayName ?? "@gmail",
                    profileImage: user.photoURL?.absoluteString ?? "https://www.istockphoto.com/photos/user-profile"
                )
                
                // Armazena a sessão do usuário
                self.userSession = user
                
                // Busca as informações completas do usuário
                Task{
                   await self.fetchUser()
                }
                print("Usuário autenticado com sucesso com o Facebook!")
            }
        }
    }

    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { [unowned self] result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    // mostra error
                }
                // usuario autenticado
                guard let user = authResult?.user else {return}
                self.userSession = user
                Task{
                   await self.fetchUser()
                }            }
        }
    }
   
    
}
