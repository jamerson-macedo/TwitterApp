//
//  RegistrationView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                
                AutenticationHeaderView(title1: "Get started", title2: "Create your account")
                
                VStack(spacing: 40){
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    
                    CustomInputField(imageName: "person", placeholderText: "Username", text: $username)
                    
                    CustomInputField(imageName: "person", placeholderText: "Full name", text: $fullname)
                    
                    CustomInputField(
                        imageName: "lock",
                        placeholderText: "password",
                        isSecureField: true,
                        text: $password
                    )
                }
                .padding(32)
                
                Button {
                    viewModel.register(withEmail: email, password: password, fullname: fullname, username: username)
                } label: {
                    Text("Sign up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 100, x: 0, y: 0)
                
                Spacer()
                HStack(spacing: 10){
                    Button {
                        viewModel.signInWithGoogle()
                    }label: {
                        Image("google").resizable().scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .frame(width: 50, height: 50)
                    }
                    Button {
                        //
                    }label: {
                        Image("facebook").resizable().scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .frame(width: 50, height: 50)
                    }
                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        Text("Sign in")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea()
            // quando o usuario cadastra
            .navigationDestination(isPresented: $viewModel.didAuthenticateUser) {
                PhotoSelectorVIew()
            }
        }
    }
}
#Preview {
    RegistrationView().environmentObject(AuthViewModel())
}
