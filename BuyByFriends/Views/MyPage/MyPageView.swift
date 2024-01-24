//
//  MyPageView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var vm: MyPageViewModel = MyPageViewModel()
    var userUID: String
    
    init(userUID: String) {
        self.userUID = userUID
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
//                    元のコード
                    AsyncImage(url: URL(string: vm.output.userInfo.profileImage)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
////                    モック画像呼び出し↓ Kota
//                    Image(vm.output.userInfo.profileImage)
//                        .resizable()
                    
                    .frame(
                        width: UIScreen.main.bounds.height*0.11,
                        height: UIScreen.main.bounds.height*0.11
                    )
                    .clipShape(Circle())
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            VStack(spacing: 5) {
                                Text("\(vm.output.posts.count)")
                                Text("出品")
                            }
                            Spacer()
                            VStack(spacing: 5) {
                                Text("\(vm.output.friend.friendList.count)")
                                Text("フレンド")
                            }
                        }
                        .padding(.leading, 20)
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(value: Destination.MyPage.editProfile) {
                                Text("プロフィールを編集")
                                    .font(.system(size: 15, weight: .medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(red: 0.47, green: 0.47, blue: 0.5, opacity: 0.2))
                                    )
                            }
                        }
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Button(action: {
                        
                    }) {
                        Image(uiImage: UIImage(named: "monochrome_Instagram") ?? UIImage())
                    }
                    
                    Text(vm.output.userInfo.name)
                        .font(.system(size: 20, weight: .bold))
                    
                }
                
                Text("@\(vm.output.userInfo.userID)")
                    .font(.system(size: 17, weight: .regular))
                
                if vm.output.userInfo.selfIntroduction != "" {
                    Text("\(vm.output.userInfo.selfIntroduction)")
                        .font(.system(size: 17, weight: .regular))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            
            HStack(spacing: 30) {
            
                NavigationLink(value: Destination.MyPage.InventoryList) {
                    Text("持ち物リスト")
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .font(.system(size: 15, weight: .medium))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }.foregroundColor(.gray)
                
                if !appState.session.userInfo.wishList.isEmpty {
                    Button(action: {
                        vm.binding.isShownHalfWishListView.toggle()
                    }) {
                        Text("ウィッシュリスト")
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .font(.system(size: 15, weight: .medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                    .foregroundColor(.gray)
                    
                } else {
                    NavigationLink(value: Destination.MyPage.wishList) {
                        Text("ウィッシュリスト")
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .font(.system(size: 15, weight: .medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }.foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(
                columns: Array(repeating: .init(.flexible(), spacing: 5), count: 3),
                spacing: 5
            ) {
                ForEach(vm.output.posts) { post in
                    NavigationLink(value: post) {
                        if let imageURLString = post.images.first {
                            AsyncImage(url: URL(string: imageURLString)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .frame(
                        minHeight: UIScreen.main.bounds.height*0.15,
                        maxHeight: UIScreen.main.bounds.height*0.15
                    )
                    .cornerRadius(5)
                }
            }
            .padding(.horizontal, 5)
        }
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Destination.MyPage.self) { destination in
            switch destination {
            case .editProfile:
                EditProfileView()
            case .InventoryList:
                EmptyView()
            case .wishList:
                WishListView()
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                Button(action: {
                    vm.binding.isShownMyPageHumbergerMenu = true
                }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .sheet(isPresented: vm.$binding.isShownMyPageHumbergerMenu){
            MyPageHumbergerMenuView()
        }
        .sheet(isPresented: vm.$binding.isShownHalfWishListView){
            HalfWishListView()
                .presentationDetents([.height(240)])
        }
        .onAppear {
//                vm.input.loadMockData.send() // モックデータを読み込む
            self.vm.input.startToFetchInfos.send(userUID) /*元のコード*/
        }
    }
}

// 元のプレビュー
struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(userUID: "CL5obaAWkIVCqmH0Nl2avs3tFCi2").environmentObject(AppState())
    }
}

//// モック用プレビュー
//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(userUID: "1").environmentObject(AppState()) // ここで任意のuserUIDを設定
//            .onAppear {
//                let viewModel = MyPageViewModel()
//                viewModel.input.loadMockData.send() // モックデータを読み込む
//                viewModel.input.startToFetchInfos.send("1") // IDが"1"のユーザーデータをフェッチ
//            }
//    }
//}
