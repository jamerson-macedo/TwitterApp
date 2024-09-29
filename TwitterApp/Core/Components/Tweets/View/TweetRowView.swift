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
    @State private var showAlert = false
    @EnvironmentObject var notificationviewModel : NotificationsViewModel
    
    init(tweet : Tweet, isRetweet : Bool) {
        self.viewmodel = TweetRowViewModel(tweet: tweet,isRetweet)
        
    }
    
    var body: some View {
        
        VStack(alignment:.leading){
            if let user = viewmodel.tweet.user{
                if viewmodel.isRetweeting {
                    HStack {
                        Image(systemName: "arrow.2.squarepath").font(.subheadline)
                        Text("Reposted for you")
                    }
                }
                HStack(alignment : .top,spacing: 12){
                    NavigationLink(destination: ProfileView(user: user,isFollowing: true)) {
                        AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                            image.resizable()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                                .redacted(reason: .placeholder)
                            
                        }
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
                    if viewmodel.tweet.didRetweet ?? false{
                        
                        self.showAlert.toggle()
                    }else  {
                        viewmodel.retweet()
                        notificationviewModel.sendNotification(toUserId: viewmodel.tweet.user?.id ?? "", postId: viewmodel.tweet.id, type: .comment)
                    }
                    viewmodel.checkIfUserRetweetedTweet()
                    
                    
                }, label: {
                    HStack{
                        Image(systemName: "arrow.2.squarepath").font(.subheadline).foregroundStyle(viewmodel.tweet.didRetweet ?? false ? .blue : .gray )
                        Text(viewmodel.tweet.numberOfRetweets > 0 ? "\(viewmodel.tweet.numberOfRetweets)" : " ")
                            .font(.subheadline)
                        
                        
                    }
                    
                }).alert(isPresented: $showAlert){
                    Alert(
                        title: Text("Undo Retweet"),
                        message: Text("Are you sure you want to undo the retweet?"),
                        primaryButton: .destructive(Text("Undo")) {
                            // Ação de desfazer o retweet
                            viewmodel.unRetweet()
                            viewmodel.checkIfUserRetweetedTweet()
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer()
                Button(action: {
                    if !(viewmodel.isProcessing) {
                        viewmodel.tweet.didLike ?? false ? viewmodel.unlikeTweet() : viewmodel.likeTweet()
                        notificationviewModel.sendNotification(toUserId: viewmodel.tweet.user?.id ?? "", postId: viewmodel.tweet.id, type: .like)
                    }
                }, label: {
                    HStack {
                        Image(systemName: viewmodel.tweet.didLike ?? false ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .symbolEffect(.bounce, value: viewmodel.tweet.didLike)
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


