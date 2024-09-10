//
//  ImagePicker.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 06/09/24.
//

import Foundation
import SwiftUI
struct ImagePicker : UIViewControllerRepresentable{
    @Binding var image : UIImage?
    @Environment(\.dismiss) var dismiss
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
   
    
    
}
extension ImagePicker{
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
        let parent : ImagePicker
        init (_ parent : ImagePicker){
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            parent.image = image
            parent.dismiss()
        }
    }
}
