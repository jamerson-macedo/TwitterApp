//
//  NewTwitterViewModel.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 17/09/24.
//
import Foundation
import SwiftUI

class NewTwitterViewModel: ObservableObject {
    
    @Published var didUploadTweet: Bool = false
    let service = TweetService()
    var imagePost: String? = nil
    
    func postTweet(text: String, image: UIImage?) {
        if let image = image {
            print("DEBUG: A imagem está disponível: \(image)")
            
            // Faz o upload da imagem
            ImageUploade.uploadImageTweet(image: image) { [weak self] imageUrl in
                guard let self = self else { return }
                
                // A URL da imagem já é um valor não opcional (String)
                self.imagePost = imageUrl
                print("DEBUG: URL da imagem recebida: \(imageUrl)")
                
                // Agora podemos fazer o upload do tweet com a imagem
                self.uploadTweetWithImage(text: text, image: imageUrl)
            }
        } else {
            // Se não houver imagem, apenas faz o upload do tweet com o texto
            uploadTweetWithImage(text: text, image: nil)
        }
    }
    
    func uploadTweetWithImage(text: String, image: String?) {
        service.uploadTweet(text, image: image) { success in
            if success {
                // Tweet foi enviado com sucesso
                self.didUploadTweet = true
                print("DEBUG: Tweet enviado com sucesso.")
            } else {
                // Mostrar uma mensagem de erro, caso o upload do tweet falhe
                print("ERROR: Falha ao enviar o tweet.")
            }
        }
    }
}
