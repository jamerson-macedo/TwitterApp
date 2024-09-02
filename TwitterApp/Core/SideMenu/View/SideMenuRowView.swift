//
//  SideMenuRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct SideMenuRowView: View {
    let viewmodel : SideMenuViewModel
    var body: some View {
        HStack(spacing:16){
            Image(systemName: viewmodel.imageName).font(.headline).foregroundStyle(Color.gray)
            Text(viewmodel.description)
                .foregroundStyle(Color.black)
                .font(.subheadline)
            Spacer()
        }.frame(height: 40)
    }
}

#Preview {
    SideMenuRowView(viewmodel:.profile)
}
