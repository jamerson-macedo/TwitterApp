//
//  ContentView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ContentView: View {
  
    @EnvironmentObject var viewModel : AuthViewModel	
    // enviroment significa que voce pode usar outra viewmodel de outra tela
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
               
            } else  {
             MainTabView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}

