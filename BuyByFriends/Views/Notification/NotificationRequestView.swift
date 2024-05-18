//
//  NotificationRequestView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import SwiftUI

struct NotificationRequestView: View {
    @StateObject var vm: NotificationViewModel
    @State var friendRequestList: [String]

    init(vm: NotificationViewModel = NotificationViewModel(), friendRequestList: [String]) {
        if !friendRequestList.isEmpty {
            vm.input.startToFetchUserInfos.send(friendRequestList)
        }
        _vm = StateObject(wrappedValue: vm)
        self.friendRequestList = friendRequestList
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(self.friendRequestList, id: \.self) { uid in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("tapped")
                        }) {
                            AsyncImage(url: URL(string: vm.binding.userInfos.first(where: {$0.id == uid})?.profileImage ?? "")) { image in
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
                            Text(vm.binding.userInfos.first(where: { $0.id == uid })?.name ?? "")
                                .font(.system(size: 20, weight: .bold))
                            Text("@"+(vm.binding.userInfos.first(where: {$0.id == uid})?.userID ?? ""))
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        // 申請
                        Button(action: {
                            vm.input.startToAcceptFriendRequest.send(vm.binding.userInfos.first(where: {$0.id == uid})?.id ?? "")
                            friendRequestList.removeAll(where: {$0 == uid})
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
    }
}

struct NotificationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRequestView(vm: NotificationViewModel(), friendRequestList: [])
    }
}
