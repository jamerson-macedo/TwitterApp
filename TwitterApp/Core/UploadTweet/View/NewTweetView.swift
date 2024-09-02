//
//  NewTweetView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct NewTweetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var caption = ""
    var body: some View {
        VStack{
            HStack{
                Button{
                    dismiss()
                }label: {
                    Text("Cancel")
                }
                Spacer()
                Button{
                    print("tweet")
                }label: {
                    Text("Tweet").bold()
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }.padding()
            HStack(alignment : .top){
                Circle().frame(width:64,height: 64)
                TextArea(text: $caption)
            }.padding()
        }
    }
}

#Preview {
    NewTweetView()
}
