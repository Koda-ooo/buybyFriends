//
//  NotificationRequestView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import SwiftUI

struct NotificationRequestView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var vm: NotificationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<vm.binding.userInfos.count, id: \.self) { num in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("tapped")
                        }) {
                            if let imageURLString = vm.binding.userInfos[num].profileImage {
                                AsyncImage(url: URL(string: imageURLString)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
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
                        // 申請
                        Button(action: {
                            vm.input.startToAcceptFriendRequest.send(vm.binding.userInfos[num].id)
                            vm.binding.userInfos.remove(at: num)
                        }) {
                            Text("追加する")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                        .background(.black)
                        .cornerRadius(20)
                        
                        
                    }
                }
                .padding()
            }
        }
        .onAppear() {
            if !appState.session.friend.requestList.isEmpty {
                vm.input.startToFetchUserInfosOfRequest.send(appState.session.friend.requestList)
            }
        }
    }
}

struct NotificationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTodoView(vm: NotificationViewModel())
    }
}
