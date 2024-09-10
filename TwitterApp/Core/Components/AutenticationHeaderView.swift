//
//  AutenticationHeaderView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 09/09/24.
//

import SwiftUI

struct AutenticationHeaderView: View {
    let title1: String
    let title2: String
    var body: some View {
           
                VStack(alignment: .leading){
                    HStack{ Spacer() }
                    Text(title1)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text(title2)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .frame(height: 260)
                .padding(.leading)
                .background(Color(.systemBlue))
                .foregroundColor(.white)
                .clipShape(RoundedShape(corners: .bottomRight))
            }
        
    }

#Preview {
    AutenticationHeaderView(title1: "Seja bem vindo",title2: "ola")
}
