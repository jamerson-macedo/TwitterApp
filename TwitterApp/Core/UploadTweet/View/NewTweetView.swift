//
//  NewTweetView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct NewTweetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject var tweetViewModel = NewTwitterViewModel()
    // a outra opção seria passar o user como dependencia para essa classe
    @FocusState var isFocused : Bool
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
                    tweetViewModel.postTweet(text: caption)
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
                if let user = viewModel.currentUser{
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }
                TextArea(text: $caption).focused($isFocused)
                    .onAppear{
                    isFocused = true
                }
            }.padding()
        }.onReceive(tweetViewModel.$didUploadTweet) { success in
            if success{
                dismiss()
            }
            else {
                // error message
            }
        }
    }
}

#Preview {
    NewTweetView().environmentObject(AuthViewModel())
}
