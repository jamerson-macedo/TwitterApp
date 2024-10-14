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
            List(viewmodel.users){ contact in
                //                        NavigationLink(destination: ChatView(contact: contact)){
                ContactsRowView(user: contact)
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
                    viewmodel.getAllUsers()
                }
            
        }
        
    }
}


#Preview {
    ContactsView(viewmodel: MessagesViewModel())
}
