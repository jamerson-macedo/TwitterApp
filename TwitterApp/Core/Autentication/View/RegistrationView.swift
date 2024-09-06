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
    @Environment(\.dismiss) var dismiss
    // não inicia em nenhum lugar
    // apenas na main ai serve para todos
    @EnvironmentObject var viewmodel : AuthViewModel
    var body: some View {
        VStack{
            //headerview
            VStack(alignment:.leading){
                // para completar o background
                HStack{Spacer()}
             Text("Get started.")
                    .font(.largeTitle)
                        .fontWeight(.semibold)
            Text("Create your account").font(.largeTitle)
                    .fontWeight(.semibold)
            }.frame(height: 260)
                .padding(.leading)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedShape(corners: [.bottomRight]))
            // edittext
            VStack(spacing : 48){
                CustomInputField(imageName: "envelope", placeholderText: "Email",text: $email)
                CustomInputField(imageName: "person", placeholderText: "Username",text: $username)
                CustomInputField(imageName: "person", placeholderText: "Full name",text: $fullname)
                CustomInputField(imageName: "lock", placeholderText: "Password",isSecureField: true, text: $password)
            }.padding(.horizontal,32)
                .padding(.top,44)
           
            Button(action: {
                viewmodel.register(withEmail: email, password: password, fullname: fullname, userName: username)
            }, label: {
                Text("Sign up").font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(width: 340,height: 50)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .padding()
                
            }).shadow(color:.gray.opacity(0.5), radius: 10, x: 0,y:0).padding(.top,22)
            
            Spacer()
            Button{
                dismiss()
            } label: {
                HStack{
                    Text("Already have an account?").font(.footnote)
                    Text("Sign in").font(.footnote).fontWeight(.semibold)
                }
            }.padding(.bottom,32)
                .foregroundStyle(.blue)

        }.ignoresSafeArea()
            .navigationBarHidden(true)
    }
}

#Preview {
    RegistrationView()
}
