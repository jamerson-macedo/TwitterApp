//
//  MessagesView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var viewmodel = MessagesViewModel()
    @State var text = ""
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                // viewmodel is loading ?
                ForEach(viewmodel.messages){contacts in
                    
                    NavigationLink {
                        //ChatView(contact: contacts)
                        
                    } label: {
                        
                        ContactMessageRow(user: contacts)
                    }
                    
                    
                }.onAppear{
                    viewmodel.getUsersLastMessage()
                }
            }
            .navigationTitle("Messages")
            .searchable(text: $text,prompt: "Search Profile")
            .toolbar{
                ToolbarItemGroup( placement: .navigationBarTrailing){
                    
                    Button("", systemImage: "message"){ isPresented.toggle()
                        
                    }.sheet(isPresented: $isPresented, content: {
                        ContactsView(viewmodel: viewmodel)
                    })
                    
                }
            }
            
        }
    }
}



#Preview {
    MessagesView(viewmodel: MessagesViewModel())
}
