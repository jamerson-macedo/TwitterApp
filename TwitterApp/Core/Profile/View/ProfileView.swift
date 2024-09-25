//
//  ProfileView.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 02/09/24.
//

import SwiftUI

struct ProfileView: View {
    let isFollowing : Bool
    @State private var selectedFilter : TweetFilterViewModel = .tweets
    @Namespace var animation
    @Environment(\.presentationMode) var mode
    @ObservedObject var profileViewModel : ProfileViewModel
    // queremos receber os dados
    
    init(user:User,isFollowing:Bool){
        // passo o usuario para a viewmodel ao inves de passar para uma variavel de campo
        self.profileViewModel = ProfileViewModel(user: user)
        self.isFollowing = isFollowing
        
    }
    
    var body: some View {
        VStack(alignment : .leading){
            headerView
            actionButtons
            userInfo
            tweetFilterBar
            tweetsView
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear{
            profileViewModel.isFollowing()
        }
    }
}

#Preview {
    ProfileView(user: User(fullname: "jamerson", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/twitter-a398c.appspot.com/o/profile_image%2F6AEDABE2-0A8F-4CD9-AA0E-27FA36F6F1F6?alt=media&token=dad3d01f-9f53-429c-a8a6-fa400259edc1", username: "Jamerson", email: "Jamerson@gmail.com"), isFollowing: true)
}

extension ProfileView {
    var headerView : some View{
        ZStack(alignment:.bottomLeading){
            Color(.systemBlue).ignoresSafeArea()
            VStack{
                Button(action: {
                    mode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "arrow.left").resizable()
                        .frame(width: 20,height: 16)
                        .foregroundColor(Color.white)
                        .offset(x: 16,y:-2)
                })
                
                AsyncImage(url: URL(string:profileViewModel.user.profileImageUrl )){ image in
                    image.resizable().scaledToFill()
                        .clipShape(Circle())
                    
                }placeholder: {
                    ProgressView()
                }
                
                .frame(width: 72,height: 72).offset(x: 16,y: 24)
            }
        }.frame(height: 96)
    }
    var actionButtons : some View{
        HStack(spacing:12){
            Spacer()
            Image(systemName: "bell.badge").font(.title3).padding(6).overlay{
                Circle().stroke(Color.gray,lineWidth: 0.75)
            }
            if isFollowing == false{
                Button(action: {
                    // go to editProfile
                }, label: {
                    
                    Text("Edit Profile").font(.subheadline).bold()
                        .foregroundStyle(Color.black)
                        .frame(width: 120,height: 32).overlay{
                            RoundedRectangle(cornerRadius: 20).stroke(Color.gray,lineWidth: 0.75)
                        }
                    
                })
            }else {
                Button(action: {
                    profileViewModel.toggleFollowState()
                }, label: {
                    Text(profileViewModel.ISFollowing ? "Following" : "Follow")
                                        .font(.headline)
                                        .padding()
                                        .frame(width: 200, height: 50)
                                        .background(profileViewModel.ISFollowing ? Color.red : Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)})
            }
            
        }.padding(.trailing)
    }
    var userInfo : some View{
        VStack(alignment: .leading,spacing: 4){
            HStack{
                Text(profileViewModel.user.fullname).font(.title2).bold()
                Image(systemName: "checkmark.seal.fill").foregroundStyle(Color.blue)
            }
            Text("@\(profileViewModel.user.username)")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text("Minha bio").font(.subheadline).padding(.vertical)
            
            HStack(spacing:24){
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                    Text("Carnauba")
                }
                
                HStack{
                    Image(systemName: "link")
                    Text("www.google.com")
                }
            }
            
            .font(.caption)
            .foregroundStyle(Color.gray)
            UserStatsView(user: profileViewModel.user).padding(.vertical)
        }.padding(.horizontal)
    }
    var tweetFilterBar : some View{
        HStack{
            ForEach(TweetFilterViewModel.allCases, id:\.rawValue){ option in
                VStack{
                    Text(option.title).font(.subheadline)
                        .fontWeight(selectedFilter == option ? .semibold : .regular)
                        .foregroundStyle( selectedFilter == option ? Color.black : .gray)
                    if selectedFilter == option{
                        Capsule().foregroundColor(.blue).frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    }else {
                        Capsule().foregroundColor(.clear).frame(height: 3)
                    }
                }.onTapGesture {
                    withAnimation(.easeInOut){
                        self.selectedFilter = option
                    }
                }
                
            }
        }.overlay(Divider().offset(x:0,y:16))
    }
    var tweetsView : some View{
        ScrollView{
            LazyVStack{
                ForEach(profileViewModel.tweets(filter: self.selectedFilter)){ tweets in
                    TweetRowView(tweet: tweets) .padding().onAppear{
                        profileViewModel.fetchLikedTweets()
                    }
                    
                    
                }
            }
        }.onAppear(){
            profileViewModel.fetchTweetsById()
        }
    }
}
