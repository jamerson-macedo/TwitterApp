//
//  PhotoSelectorVIew.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 06/09/24.
//

import SwiftUI

struct PhotoSelectorView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var showActionSheet = false
    @EnvironmentObject var photoViewModel: AuthViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Para completar o background
                HStack { Spacer() }
                Text("Setup account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Add a profile photo")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(height: 260)
            .padding(.leading)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedShape(corners: [.bottomRight]))

            // Botão para selecionar imagem
            Button(action: {
                showActionSheet.toggle()
            }, label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .modifier(ProfileImageModifier())
                } else {
                    Image("addphoto")
                        .resizable()
                        .renderingMode(.template)
                        .modifier(ProfileImageModifier())
                }
            })
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
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $selectedImage, sourceType: sourceType)
            }
            .padding(.top)

            // Exibir o botão de continuar se a imagem for selecionada
            if let selectedImage = selectedImage {
                Button(action: {
                    photoViewModel.uploadProfileImage(selectedImage)
                }, label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(width: 340, height: 50)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding()
                })
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                .padding(.top, 22)
            }

            Spacer()
        }
        .ignoresSafeArea()
    }

    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        profileImage = Image(uiImage: selectedImage)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 180, height: 180)
            .clipShape(Circle())
    }
}

#Preview {
    PhotoSelectorView()
}

    
    

