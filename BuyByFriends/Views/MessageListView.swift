//
//  MessageListView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import SwiftUI

struct MessageListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject var vm = MessageListViewModel()

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("検索", text: vm.$binding.searchText)
                .onSubmit {
                    UIApplication.shared.closeKeyboard()
                }
        }
        .padding()
        .background(Color(.systemGray6))
        .padding()

        Spacer()

        ScrollView {
            LazyVStack {
                ForEach(vm.output.chatRooms, id: \.self) { chatRoom in
                    MessageListButtonView(vm: self.vm, chatRoom: chatRoom)
                }
                .padding()
            }
        }
        .navigationTitle("メッセージ")
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
        .onAppear {
            vm.input.startToObserveChatRoom.send()
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}

struct MessageListButtonView: View {
    @StateObject var vm: MessageListViewModel
    var chatRoom: ChatRoom

    static var df: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "M/dd HH:mm"
        return df
    }

    var body: some View {
        NavigationLink(value: chatRoom) {
            HStack(spacing: 15) {
                if let imageURLString = vm.output.userInfos[chatRoom.members.first ?? ""]?.profileImage {
                    AsyncImage(url: URL(string: imageURLString)) { image in
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
                }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(vm.output.userInfos[chatRoom.members.first ?? ""]?.userID ?? "")
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .medium))
                        Text(vm.output.latestMessages[chatRoom.id]?.messageType == "text" ? vm.output.latestMessages[chatRoom.id]?.message ?? "": "画像を送信しました")
                            .lineLimit(1)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    Spacer()

                    Text(MessageListButtonView.df.string(from: vm.output.latestMessages[chatRoom.id]?.createdAt.dateValue() ?? Date()))
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
