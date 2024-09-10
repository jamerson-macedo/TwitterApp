//
//  PhotoSelectorVIew.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 06/09/24.
//

import SwiftUI

struct PhotoSelectorVIew: View {
    @State private var showImagePicker = false
    @State private var selectedImage : UIImage?
    @State private var profileImage : Image?
    @EnvironmentObject var photoViewModel : AuthViewModel
    var body: some View {
        VStack{
            VStack(alignment:.leading){
                // para completar o background
                HStack{Spacer()}
             Text("Setup account")
                    .font(.largeTitle)
                        .fontWeight(.semibold)
            Text("Add a profile photo").font(.largeTitle)
                    .fontWeight(.semibold)
            }.frame(height: 260)
                .padding(.leading)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedShape(corners: [.bottomRight]))
          
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                if let profileImage = profileImage{
                    
                    profileImage.resizable()
                        .modifier(ProfileImageModifier())
                }else {
                    Image("addphoto").resizable()
                        .renderingMode(.template).modifier(ProfileImageModifier())
                       
                }
               
            }).sheet(isPresented: $showImagePicker,onDismiss: loadImage){
                ImagePicker(image: $selectedImage)
            }
            .padding(.top)
            if let selectedImage = selectedImage{
                Button(action: {
                    photoViewModel.uploadProfileImage(selectedImage)
                }, label: {
                    Text("Continue").font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(width: 340,height: 50)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding()
                    
                }).shadow(color:.gray.opacity(0.5), radius: 10, x: 0,y:0).padding(.top,22)
                
            }
            
            Spacer()
        }.ignoresSafeArea()
    }
    func loadImage(){
        guard let selectedImage = selectedImage else{
            return
        }
        profileImage = Image(uiImage: selectedImage)
    }
    
}
private struct ProfileImageModifier : ViewModifier{
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 180,height: 180)
            .clipShape(Circle())
    }
}

#Preview {
    PhotoSelectorVIew()
}

    
    

