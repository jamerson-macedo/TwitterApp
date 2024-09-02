//
//  UserRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct UserRowView: View {
    var body: some View {
        
        HStack(spacing : 12){
            Circle().frame(width: 50)
            VStack(alignment:.leading,spacing: 4){
                Text("jamesrson").font(.subheadline).bold().foregroundStyle(Color.black)
                Text("jamesrson").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            
        }.padding(.horizontal)
            .padding(.vertical,4)
    }
}

#Preview {
    UserRowView()
}
