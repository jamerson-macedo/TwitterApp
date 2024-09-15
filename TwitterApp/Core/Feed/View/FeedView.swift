//
//  FeedView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//
import SwiftUI
struct FeedView: View {
    @State private var showNewTweetView = false
    @State private var showMenu = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVStack(alignment: .center) {
                        ForEach(1...10, id: \.self) { _ in
                            TweetRowView().padding()
                        }
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showMenu.toggle()
                            }
                        }, label: {
                            if let user = viewModel.currentUser {
                                AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                                    image.resizable()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        })
                    }
                }
                
                Button {
                    showNewTweetView.toggle()
                } label: {
                    Image(systemName: "bird")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .padding()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
                .fullScreenCover(isPresented: $showNewTweetView) {
                    NewTweetView()
                }
            }
            .disabled(showMenu)
            
            if showMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showMenu = false
                        }
                    }
            }
            
            HStack {
                SideMenuView()
                    .frame(width: 300)
                    .background(Color.white)
                    .offset(x: showMenu ? 0 : -300)
                    .animation(.easeInOut, value: showMenu)
                
                Spacer()
            }
            .zIndex(1)
        }
    }
}

#Preview {
    FeedView().environmentObject(AuthViewModel())
}
