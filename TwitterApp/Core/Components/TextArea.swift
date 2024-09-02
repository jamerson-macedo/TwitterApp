//
//  TextArea.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct TextArea: View {
    @Binding var text : String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("What`s happening?")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 150, maxHeight: 300)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
        }
    }
}


