//
//  ExploreView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewmodel = ExploreViewModel()
    var body: some View {
        
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(viewmodel.allUsers){ user in
                        NavigationLink{
                            ProfileView(user: user)
                        }label: {
                            UserRowView(user: user)
                        }
                        
                    }
                }
            }
        }.navigationTitle("Search").navigationBarTitleDisplayMode(.inline)
            
    }
    
}

#Preview {
    ExploreView()
}
