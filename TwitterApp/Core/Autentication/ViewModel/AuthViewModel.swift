//
//  AuthViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
class AuthViewModel : ObservableObject{
    @Published var userSession : FirebaseAuth.User?
   
    
    init(){
        // quando iniciar se tiver usuario ele ja registra
        self.userSession = Auth.auth().currentUser
        print("DEBUG: O USUARIO É\(self.userSession)")
    }
    func login(withEmail email : String, password : String){
        
    }
    func register(withEmail email : String, password : String , fullname:String,userName : String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG: FAILED \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {return}
            self.userSession = user
        }
    }
    
}
