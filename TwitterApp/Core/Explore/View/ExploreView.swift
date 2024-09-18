//
//  ExploreView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewmodel = ExploreViewModel()
    @FocusState private var isSearchFocused : Bool
    var body: some View {
    
            VStack{
                SearchBar(text: $viewmodel.searchText).focused($isSearchFocused).onAppear{
                    isSearchFocused = true
                }.padding()
                ScrollView{
                    LazyVStack{
                        ForEach(viewmodel.searchableUsers){ user in
                            NavigationLink{
                                ProfileView(user: user)
                            }label: {
                                UserRowView(user: user)
                            }
                            
                        }
                    }
                }
                
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
       
               
    
    }
}

#Preview {
    ExploreView()
}
