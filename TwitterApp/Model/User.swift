//
//  User.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 10/09/24.
//

import FirebaseFirestore
struct User : Identifiable,Decodable{
    // para não ter o id dentro do firebase é so colocar isso
    @DocumentID var id : String?
    let fullname : String
    let profileImageUrl : String
    let username : String
    let email : String
    var following : Int
    var followers : Int
}
