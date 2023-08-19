//
//  SearchFriendsView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import SwiftUI

struct SearchFriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject var vm = SearchFriendsViewModel()
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("友達を追加、検索する", text: vm.$binding.searchText)
                .onSubmit {
                    UIApplication.shared.closeKeyboard()
                }
                .onChange(of: vm.binding.searchText) { newValue in
                    if newValue == "" {
                        vm.binding.userInfos.removeAll()
                    }
                }
        }
        .padding()
        .background(Color(.systemGray6))
        .padding()
        
        if vm.binding.userInfos.count == 0 {
            ShareViewInSearchFrindView()
        }
        
        ScrollView {
            LazyVStack {
                ForEach(0..<vm.binding.userInfos.count, id: \.self) { num in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("tapped")
                        }) {
                            AsyncImage(url: URL(string: vm.binding.userInfos[num].profileImage)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(
                            width: UIScreen.main.bounds.width*0.15,
                            height: UIScreen.main.bounds.width*0.15
                        )
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(vm.binding.userInfos[num].name)
                                .font(.system(size: 20, weight: .bold))
                            Text("@"+vm.binding.userInfos[num].userID)
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        if appState.session.friend.friendList.contains(vm.binding.userInfos[num].id) {
                            // 友達取り消す
                            Button(action: {
                                vm.input.startNotToBeFriend.send()
                            }) {
                                Text("友達")
                                    .bold()
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        } else {
                            // 申請
                            Button(action: {
                                vm.binding.selectedUserInfo = vm.binding.userInfos[num]
                                vm.input.startToRequestToBeFriend.send()
                            }) {
                                Text("友達追加")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .padding()
                            .background(.black)
                            .cornerRadius(20)
                        }
                        
                        
                    }
                }
                .padding()
            }
        }
        .navigationTitle("探す")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            
        }
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            vm.input.startToFetchUserInfoByUserID.send()
        }
    }
    
}

struct ShareViewInSearchFrindView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: appState.session.userInfo.profileImage)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFill()
            .clipShape(Circle())
            .frame(
                width: UIScreen.main.bounds.width*0.15,
                height: UIScreen.main.bounds.width*0.15
            )
            VStack(alignment: .leading, spacing: 5) {
                Text("友達を招待する")
                    .font(.system(size: 18, weight: .bold))
                Text("@"+appState.session.userInfo.userID)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
            }
            
        }
        .padding()
        .background(Color(.systemGray6))
        .padding()
        .clipShape(Capsule())
    }
}

struct SearchFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsView()
    }
}
