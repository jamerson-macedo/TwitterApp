//
//  ContentView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    @EnvironmentObject var viewModel : AuthViewModel	
    // enviroment significa que voce pode usar outra viewmodel de outra tela
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
               
            } else  {
                mainInterfaceView
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
extension ContentView{
    var mainInterfaceView : some View{
       
            ZStack(alignment: .topLeading){
                MainTabView().navigationBarHidden(showMenu)
                // cor preta por cima
                if showMenu{
                    ZStack{
                        Color.black.opacity(showMenu ? 0.25 : 0.0)
                    }.onTapGesture {
                        withAnimation(.easeInOut){
                            showMenu = false // quando clicar na sombra ela volta
                        }
                    }.ignoresSafeArea()
                }// depois o menu
                
                SideMenuView().frame(width: 300)
                    .offset(x: showMenu ? 0 : -300)
                    .background(showMenu ? Color.white : Color.clear)
            }.navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.thinMaterial)
                .toolbar{
                    ToolbarItem(placement:.navigationBarLeading){
                        Button(action: {
                            withAnimation(.easeInOut){
                                showMenu.toggle()
                            }
                        }, label: {
                            if let user = viewModel.currentUser{
                                AsyncImage(url: URL(string: user.profileImageUrl)){ image in
                                    image.resizable().frame(width: 32,height: 32).clipShape(Circle())
                                    
                                }placeholder: {
                                    ProgressView()
                                }
                            }})
                    }
                }
                .onAppear{
                    showMenu = false
                   
                }
            
            
    }
}
