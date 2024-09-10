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
class AuthViewModel : ObservableObject{
   // a trla principal ta observando essa variavel, se ela for nula vai pro login se não vai para a principal
        @Published var userSession: FirebaseAuth.User?
        //This property below is for The navigation to the profilePhotoSelectorView
        @Published var didAuthenticateUser = false
        @Published var currentUser: User?
        private var tempUserSession: FirebaseAuth.User?
    
    init(){
        // quando iniciar se tiver usuario ele ja registra
        self.userSession = Auth.auth().currentUser
        print("DEBUG: O USUARIO É\(self.userSession?.uid)")
    }
    func login(withEmail email : String, password : String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG : ", error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {return}
            self.userSession = user
        }
        
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
                   "uid": user.uid
               ]
               // quando o usuario é criado ele abre a tela para colocar a foto
               Firestore.firestore().collection("users")
               
                   .document(user.uid).setData(data) { _ in
                       self.didAuthenticateUser = true
                   }
               
           }
       }
    
    func signOut(){
        userSession = nil
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
                        print("DEBUG : USUARIO CADASTRADO TUDO CERTO")
                      //so that when we register a new user we can fetch the details of the currently registered user.
                    }
            }
        }
}
