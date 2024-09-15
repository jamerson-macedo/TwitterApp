//
//  SearchBar.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 13/09/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text :String
    var body: some View {
        HStack{
            TextField("Search...",text: $text).padding(8)
                .padding(.horizontal,24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            // com o overlay ele entra dentro do layout
                .overlay {
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                            .padding(.leading,8)
                    
                    }
                }
        }.padding(.horizontal,4)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
