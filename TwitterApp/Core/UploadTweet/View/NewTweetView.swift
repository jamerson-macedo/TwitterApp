//
//  NewTweetView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI
import UIKit

struct NewTweetView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var tweetViewModel = NewTwitterViewModel()
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @FocusState var isFocused: Bool
    @State private var selectedImage: UIImage?
    @State private var caption = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            // Cabeçalho com Cancel e Tweet
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    tweetViewModel.postTweet(text: caption, image: selectedImage)
                } label: {
                    Text("Tweet").bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
            
            // Campo de texto e botão de imagem
            HStack(alignment: .top) {
                if let user = viewModel.currentUser {
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                TextArea(text: $caption)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                
                // Botão para abrir a ActionSheet (Galeria/Câmera)
                Button {
                    showActionSheet.toggle()
                } label: {
                    Image(systemName: "photo.artframe")
                        .font(.title)
                }
                .padding(.leading)
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Selecione uma opção"),
                        buttons: [
                            .default(Text("Abrir Galeria")) {
                                sourceType = .photoLibrary
                                showImagePicker = true
                            },
                            .default(Text("Tirar Foto")) {
                                sourceType = .camera
                                showImagePicker = true
                            },
                            .cancel()
                        ]
                    )
                }
            }
            .padding()
            
            // Mostrar a imagem selecionada, se houver
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: sourceType)
        }
        .onReceive(tweetViewModel.$didUploadTweet) { success in
            if success {
                dismiss()
            }
        }
    }
}

#Preview {
    NewTweetView().environmentObject(AuthViewModel())
}
