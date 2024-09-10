//
//  RoundedShape.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 03/09/24.
//

import SwiftUI
struct RoundedShape : Shape{
    // qual a borda que vai arredondar ?
    var corners : UIRectCorner // informa quais cantos vai arredondar 
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 80, height: 80))
        return Path(path.cgPath)
    }

}
