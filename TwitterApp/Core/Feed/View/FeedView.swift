//
//  FeedView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//
import SwiftUI

struct FeedView: View {
    @State private var showNewTweetView = false // Estado de tela de novo Tweet
    @State private var showMenu = false // Menu tabbar
    
    @EnvironmentObject var viewModel: AuthViewModel // viewmodel com informacoes do usuario
    @StateObject var feedViewModel = FeedViewModel() // informacoes dos tweets
    
    @State private var selectedFilter: FeedFilter = .foryou // filtros
    @Namespace var animation // animacao dos filtros
    @Binding var selectedTab: Int  // Índice da aba selecionada
    @State private var scrollToTop: Bool = false  // Controla o scroll para o topo

    var body: some View {
        ZStack {
            // Conteúdo do feed
            NavigationView {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            // Filtros
                            HStack {
                                ForEach(FeedFilter.allCases, id: \.rawValue) { option in
                                    VStack {
                                        Text(option.title)
                                            .font(.subheadline)
                                            .fontWeight(selectedFilter == option ? .semibold : .regular)
                                            .foregroundStyle(selectedFilter == option ? Color.black : .gray)
                                        if selectedFilter == option {
                                            Capsule().foregroundColor(.blue).frame(height: 3)
                                                .matchedGeometryEffect(id: "filterfeed", in: animation)
                                        } else {
                                            Capsule().foregroundColor(.clear).frame(height: 3)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            self.selectedFilter = option
                                        }
                                    }
                                }
                            }
                            .frame(width: 200)
                            .overlay(Divider().offset(x: 0, y: 16))

                            // Lista de Tweets
                            LazyVStack(alignment: .center) {
                                ForEach(feedViewModel.tweets(filter: self.selectedFilter)) { tweet in
                                    TweetRowView(tweet: tweet, isRetweet: false)
                                        .padding()
                                        .id(tweet.id)
                                }
                            }
                            .id("top")  // ID para ele saber onde é o topo
                        }
                    }
                    .refreshable {
                        feedViewModel.fetchTweets() // toda vez que fazer isso
                        // busca novos tweets
                    }
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.inline)
                    .onChange(of: selectedTab) { newValue in
                        // se o valor for zero que é o valor da tab home
                        if newValue == 0 {
                            // Aba "Home" foi clicada, role para o topo
                            withAnimation {
                                // proxy é gerenciador do scrollview
                                proxy.scrollTo("top", anchor: .top)
                            }
                        }
                    }
                }
            }
            .disabled(showMenu)  // Desabilita a interação com a tela se o menu estiver aberto

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
            .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200)  // Posição do botão
            .fullScreenCover(isPresented: $showNewTweetView, onDismiss: {
                // quando fechar ele faz essa ação
                feedViewModel.fetchTweets()
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
            .zIndex(1)  // Controla a sobreposição do side menu em relação ao conteúdo
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}
#Preview {
    FeedView(selectedTab: .constant(0)).environmentObject(AuthViewModel())
}
