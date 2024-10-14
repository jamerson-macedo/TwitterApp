//
//  ContactView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI

struct ContactsView: View {
    @StateObject var viewmodel : MessagesViewModel
    @State var search = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            List(viewmodel.messages){ contact in
                //                        NavigationLink(destination: ChatView(contact: contact)){
                ContactMessageRow(user:contact)
            }.navigationTitle("New Chat")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $search,prompt: "Search by Name")
                .toolbar(content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    
                })
                .onAppear{
                    viewmodel.getUsersMessages()
                }
            
        }
        
    }
}


#Preview {
    ContactsView(viewmodel: MessagesViewModel())
}
