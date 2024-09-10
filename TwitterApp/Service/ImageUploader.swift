//
//  ImageUploader.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 06/09/24.
//

import FirebaseStorage
import UIKit
struct ImageUploade{
    // manda para o firebase a imagem e retorna a url para colocar no firestore
    static func uploadImage(image:UIImage, completion : @escaping(String)->Void){
        // compressão
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(fileName)")
        
        ref.putData(imageData,metadata: nil) { _, error in
            if let error = error{
                print("DEBUG : FAILED PUT IMAGE \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, _ in
                guard let url = url?.absoluteString else {return }
                completion(url)
            }
            
        }
    }
}


