//
//  LoginView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        VStack{
            //headerview
            VStack(alignment:.leading){
                // para completar o background
                HStack{Spacer()}
             Text("Hello.")
                    .font(.largeTitle)
                        .fontWeight(.semibold)
            Text("Welcome Back").font(.largeTitle)
                    .fontWeight(.semibold)
            }.frame(height: 260)
                .padding(.leading)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedShape(corners: [.bottomRight]))
            // edittext
            VStack(spacing : 48){
                CustomInputField(imageName: "envelope", placeholderText: "Email",text: $email)
                CustomInputField(imageName: "lock", placeholderText: "Password",isSecureField: true, text: $password)
            }.padding(.horizontal,32)
                .padding(.top,44)
            HStack{
                Spacer()
                NavigationLink {
                   Text("forgetView")
                } label: {
                    Text("Forgot Password?").font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.blue)
                        .padding(.top)
                        .padding(.trailing,23)
                }

            }
            Button(action: {
                viewModel.login(withEmail: email, password: password)
            }, label: {
                Text("Sign In").font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(width: 340,height: 50)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .padding()
                
            }).shadow(color:.gray.opacity(0.5), radius: 10, x: 0,y:0)
            
            Spacer()
            NavigationLink {
                RegistrationView().navigationBarHidden(true)
            } label: {
                HStack{
                    Text("Don't have an account?").font(.footnote)
                    Text("Sign Up").font(.footnote).fontWeight(.semibold)
                }
            }.padding(.bottom,32)
                .foregroundStyle(.blue)
                .transition(.slide) // Tipo de transição (exemplo)
                                .animation(.easeInOut(duration: 0.5), value: 1)
            
                

        }.ignoresSafeArea()
            .navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
