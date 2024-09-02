//
//  ExploreView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    LazyVStack{
                        ForEach(0...10, id: \.self){_ in
                            NavigationLink{
                                ProfileView()
                            }label: {
                                UserRowView()
                            }
                            
                            
                        }
                    }
                }
            }.navigationTitle("Search").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExploreView()
}
