//
//  MessageRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI
import FirebaseFirestore
struct MessageRow: View {
    let message : Messages
    
    var body: some View {
        VStack(alignment: message.isMe ? . trailing: .leading){
            HStack{
                Text(message.text)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
             
                
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10).fill(message.isMe ? Color("messageColor") : Color.white))
        .frame(maxWidth: .infinity,alignment: message.isMe ? . trailing: .leading)
        .padding(.vertical,2)
        .padding(.horizontal,10)
        

    }
}

#Preview {
  
    

    MessageRow(message: Messages( text: "ola", isMe: true, timeStamp : Timestamp()))
}
