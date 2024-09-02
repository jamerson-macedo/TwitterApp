//
//  ContentView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    var body: some View {
        ZStack(alignment: .topLeading){
            MainTabView().navigationBarHidden(showMenu)
            
            if showMenu{
                ZStack{
                    Color.black.opacity(showMenu ? 0.25 : 0.0)
                }.onTapGesture {
                    withAnimation(.easeInOut){
                        showMenu = false // quando clicar na sombra ela volta
                    }
                }.ignoresSafeArea()
            }
            SideMenuView().frame(width: 300)
                .offset(x: showMenu ? 0 : -300)
                .background(showMenu ? Color.white : Color.clear)
        }.navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement:.navigationBarLeading){
                    Button(action: {
                        withAnimation(.easeInOut){
                            showMenu.toggle()
                        }
                    }, label: {
                        Circle().frame(width: 32,height: 32)
                    })
                }
            }
            .onAppear{
                showMenu = false
            }
        
    }
}

#Preview {
    ContentView()
}
