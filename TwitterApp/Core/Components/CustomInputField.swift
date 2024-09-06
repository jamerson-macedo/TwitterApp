//
//  CustomInputField.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import SwiftUI

struct CustomInputField: View {
    let imageName :String
    let placeholderText : String
    var isSecureField : Bool? = false
    @Binding var text : String
    var body: some View {
        VStack{
            HStack{
                Image(systemName: imageName).resizable().scaledToFit().frame(width: 20,height: 20).foregroundStyle(.gray)
                if isSecureField ?? false{
                    SecureField(placeholderText, text: $text)
                }else {
                    TextField(placeholderText, text: $text)
                }
                
            }
            Divider().background(.gray)
        }
    }
}

#Preview {
    CustomInputField(imageName: "person", placeholderText: "Email", text: .constant(""))
}
