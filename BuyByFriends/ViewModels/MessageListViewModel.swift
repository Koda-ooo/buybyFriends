//
//  MessageListViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

final class MessageListViewModel: ViewModelObject {

    final class Input: InputObject {
        let startToObserveChatRoom = PassthroughSubject<Void, Never>()
        let startToFetchUserInfo = PassthroughSubject<String, Never>()
        let startToFetchLatestMessage = PassthroughSubject<ChatRoom, Never>()
    }

    final class Binding: BindingObject {
        @Published var searchText: String = ""
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var chatRooms: [ChatRoom] = []
        @Published fileprivate(set) var latestMessages: [String: Message] = [:]
        @Published fileprivate(set) var userInfos: [String: UserInfo] = [:]
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false

    private var chatRoomProvider: ChatRoomProviderObject
    private var messageProvider: MessageProviderObject
    private var userInfoProvider: UserInfoProviderObject

    init(
        chatRoomProvider: ChatRoomProviderObject = ChatRoomProvider(),
        messageProvider: MessageProviderObject = MessageProvider(),
        userInfoProvider: UserInfoProviderObject = UserInfoProvider()
    ) {
        self.chatRoomProvider = chatRoomProvider
        self.messageProvider = messageProvider
        self.userInfoProvider = userInfoProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        input.startToObserveChatRoom
            .flatMap {
                chatRoomProvider.observeChatRoom(query: Firestore.firestore()
                    .collection("ChatRooms")
                    .whereField("members", arrayContains: Auth.auth().currentUser?.uid ?? "")
                )
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.chatRooms = result

                // メンバー配列から自分のIDを取り除く
                output.chatRooms.indices.forEach {
                    output.chatRooms[$0].members.remove(Auth.auth().currentUser?.uid ?? "")
                }

                for chatRoom in output.chatRooms {
                    // 最新のメッセージが存在するなら情報を取得
                    if chatRoom.latestMessageID != "" {
                        input.startToFetchLatestMessage.send(chatRoom)
                    }

                    for member in chatRoom.members {
                        // ユーザー情報見取得＆自分のIDでなければ、ユーザー情報取得
                        if member != Auth.auth().currentUser?.uid ?? "" && !(output.userInfos.keys.contains(member)) {
                            input.startToFetchUserInfo.send(member)
                        }
                    }

                }
            }
            .store(in: &cancellables)

        // ユーザー情報取得
        input.startToFetchUserInfo
            .flatMap { id in
                userInfoProvider.fetchUserInfo(id: id)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.userInfos = [result.id: result]
            }
            .store(in: &cancellables)

        // 最新メッセージ取得
        input.startToFetchLatestMessage
            .flatMap { chatRoom in
                messageProvider.fetchMessage(chatRoomID: chatRoom.id, messageID: chatRoom.latestMessageID)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.latestMessages = [result.chatRoomID: result]
            }
            .store(in: &cancellables)

        // 組み立てたストリームを反映
        cancellables.formUnion([
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}

/// 前提：
/// ①フレンドからはお互いが削除される
/// ②もう一回友達になることもできる

/// A メッセージが両ユーザー見えない×
/// メリット：メッセージリストに邪魔なものがなく、使いやすい
/// デメリット：削除された方のユーザーが驚く

/// B メッセージを片方のユーザー（消された側）は見える×
/// メリット：片方は急な削除を免れる
/// デメリット：送れないのに残り続ける

/// C メッセージは両ユーザー見える◯
/// メリット：急な削除を免れる
/// デメリット：送れないのに残り続ける
