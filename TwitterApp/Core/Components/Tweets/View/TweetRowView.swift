//
//  TweetRowView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI
import FirebaseCore

struct TweetRowView: View {
    @ObservedObject var viewmodel : TweetRowViewModel
    @State var showComments : Bool = false
    
    init(tweet : Tweet) {
        self.viewmodel = TweetRowViewModel(tweet: tweet)
    }
    
    var body: some View {
        VStack(alignment:.leading){
            
            HStack(alignment : .top,spacing: 12){
                if let user = viewmodel.tweet.user{
                    AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                        image.resizable()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            // Nome completo sem truncamento
                            Text(user.fullname)
                                .font(.subheadline)
                                .bold()
                                .lineLimit(1) // Limita o nome a uma linha
                                .layoutPriority(1) // Dá prioridade ao nome completo para ocupar espaço

                            // Nome de usuário
                            Text("@\(user.username)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.tail) // Trunca o username se for muito longo
                                .layoutPriority(0) // Menor prioridade que o nome completo
                            // Timestamp
                            Spacer()
                            Text(viewmodel.tweet.timestamp.timeAgoDisplay())
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Conteúdo do tweet
                        Text(viewmodel.tweet.tweet)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                }
            }
            HStack(){
                Button(action: {
                    showComments.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "bubble.left").font(.subheadline).sheet(isPresented:$showComments,onDismiss: {
                            
                        }){
                            CommentsView(tweet: viewmodel.tweet)
                        }
                        Text(viewmodel.tweet.numberOfComments > 0 ? "\(viewmodel.tweet.numberOfComments)" : " ")
                            .font(.subheadline)
                    }
                    
                })
                Spacer()
                Button(action: {
                    viewmodel.retweet()
                }, label: {
                    HStack{
                        Image(systemName: "arrow.2.squarepath").font(.subheadline)
                        Text(viewmodel.tweet.numberOfRetweets > 0 ? "\(viewmodel.tweet.numberOfRetweets)" : " ")
                            .font(.subheadline)
                    }
                    
                })
                Spacer()
                Button(action: {
                    if !(viewmodel.isProcessing) {
                           viewmodel.tweet.didLike ?? false ? viewmodel.unlikeTweet() : viewmodel.likeTweet()
                       }
                }, label: {
                    HStack {
                        Image(systemName: viewmodel.tweet.didLike ?? false ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundStyle(viewmodel.tweet.didLike ?? false ? .red : .gray)
                        
                        // Espaço fixo para o número de likes
                        Text(viewmodel.tweet.likes > 0 ? "\(viewmodel.tweet.likes)" : " ")
                            .font(.subheadline)
                          
                    }
                }).disabled(viewmodel.isProcessing)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bookmark").font(.subheadline)
                })
            }.padding()
                .foregroundStyle(Color.gray)
            Divider()
        }
    }
}


