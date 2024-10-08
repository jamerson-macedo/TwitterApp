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
    @StateObject var feedViewModel = FeedViewModel()
    @StateObject var notificationViewModel = NotificationsViewModel()
    @State private var selectedFilter : FeedFilter = .foryou
    @Namespace var animation
    var body: some View {
        ZStack {
            // Conteúdo do feed
            NavigationView {
                ScrollView(showsIndicators: false) {
                    HStack(){
                        ForEach(FeedFilter.allCases, id:\.rawValue){ option in
                            VStack{
                                Text(option.title).font(.subheadline)
                                    .fontWeight(selectedFilter == option ? .semibold : .regular)
                                    .foregroundStyle( selectedFilter == option ? Color.black : .gray)
                                if selectedFilter == option{
                                    Capsule().foregroundColor(.blue).frame(height: 3)
                                        .matchedGeometryEffect(id: "filterfeed", in: animation)
                                }else {
                                    // se não ele fica sem cor
                                    Capsule().foregroundColor(.clear).frame(height: 3)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    self.selectedFilter = option
                                }
                            }
                            
                            
                        }
                        
                    }.frame(width: 200)
                        .overlay(Divider().offset(x:0,y:16))
                    
                    LazyVStack(alignment: .center) {
                        ForEach(feedViewModel.tweets(filter: self.selectedFilter)) { tweet in
                            TweetRowView(tweet: tweet, isRetweet: false).padding()
                        }
                    }
                    
                }.refreshable {
                    Task{
                        await feedViewModel.fetchTweets()
                    }
                }
                // na hstack que esta os 2 itens eu faco o gesto e vejo ate o final
                .gesture(DragGesture().onEnded({ value in
                    handleSwipe(value: value.translation)
                }))
                .navigationTitle("Home") // Título na toolbar
                .navigationBarTitleDisplayMode(.inline) // Exibe a toolbar de maneira compacta
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showMenu.toggle()
                            }
                        }) {
                            if let user = viewModel.currentUser {
                                AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                                    image.resizable()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                        .redacted(reason: .placeholder)
                                }
                            }
                        }
                    }
                }
            }
            .disabled(showMenu) // Desabilita a interação com a tela se o menu estiver aberto
            
            // Botão flutuante no canto inferior direito
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
            .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200) // Posição do botão
            .fullScreenCover(isPresented: $showNewTweetView,onDismiss: {
                // quando fechar ele faz essa ação
                Task {
                    await feedViewModel.fetchTweets()
                }
            }) {
                NewTweetView()
            }
            
            // Sombra do menu
            if showMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showMenu = false
                        }
                    }
            }
            
            // O side menu
            HStack {
                SideMenuView()
                    .frame(width: 300)
                    .background(Color.white)
                    .offset(x: showMenu ? 0 : -300)
                    .animation(.easeInOut, value: showMenu)
                Spacer()
            }
            .zIndex(1) // Controla a sobreposição do side menu em relação ao conteúdo
        }.onAppear{
           
            
        }
        .task {
            await feedViewModel.fetchTweets()
            await viewModel.fetchUser()
        }
    }
    
    
    func handleSwipe(value: CGSize) {
        let threshold: CGFloat = 50 // define ate onde tem que arrastar para mudar
        
        if value.width > threshold { // Deslizar para a direita
            moveToPreviousTab()
        } else if value.width < -threshold { // Deslizar para a esquerda
            moveToNextTab()
        }
    }
    func moveToNextTab() {
        if let currentIndex = FeedFilter.allCases.firstIndex(of: selectedFilter),
           currentIndex < FeedFilter.allCases.count - 1 {
            withAnimation(.easeInOut) {
                selectedFilter = FeedFilter.allCases[currentIndex + 1]
            }
        }
    }
    func moveToPreviousTab() {
        if let currentIndex = FeedFilter.allCases.firstIndex(of: selectedFilter),
           currentIndex > 0 {
            
            withAnimation(.easeInOut) {
                selectedFilter = FeedFilter.allCases[currentIndex - 1]
            }
        }
    }
}
#Preview {
    FeedView().environmentObject(AuthViewModel())
}
