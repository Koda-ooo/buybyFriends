//
//  SearchFriendsViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

final class SearchFriendsViewModel: ViewModelObject {
    
    final class Input: InputObject {
        let startToFetchUserInfoByUserID = PassthroughSubject<Void, Never>()
        let startToRequestToBeFriend = PassthroughSubject<Void, Never>()
        let startNotToBeFriend = PassthroughSubject<Void, Never>()
        
//        // モックデータ読み込み用のイベントを追加 kota
//        let loadMockData = PassthroughSubject<Void, Never>()

    }
    
    final class Binding: BindingObject {
        @Published var searchText:String = ""
        @Published var selectedUserInfo: UserInfo = UserInfo(dic: [:])
        @Published var userInfos: [UserInfo] = []
    }
    
    final class Output: OutputObject {
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    
    private let userInfoProvider: UserInfoProviderObject
    private let notificationProvider: NotificationProviderObject
    private let friendProvider: FriendProviderObject
    
    private let pushNotificationSender: PushNotificationSender
    
    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        notificationProvider: NotificationProviderObject = NotificationProvider(),
        friendProvider: FriendProviderObject = FriendProvider(),
        pushNotificationSender: PushNotificationSender = PushNotificationSender()
    ) {
        self.userInfoProvider = userInfoProvider
        self.notificationProvider = notificationProvider
        self.friendProvider = friendProvider
        self.pushNotificationSender = pushNotificationSender
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
////       ダミーユーザーの読み込み kota
//        self.binding.userInfos = UserInfo.MOCK_USER

        
        input.startToFetchUserInfoByUserID
            .flatMap {
                userInfoProvider.fetchUserInfos(userID: binding.searchText)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { result in
                binding.userInfos = result
            }
            .store(in: &cancellables)
        
        //フレンドリクエストを飛ばす
        input.startToRequestToBeFriend
            .flatMap {
                friendProvider.fetchFriend(uid: binding.selectedUserInfo.id)
                    .flatMap { friend in
                        friendProvider.addPartnerRequestList(friend: friend)
                    }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) {
                pushNotificationSender.sendPushNotification(
                    to: binding.selectedUserInfo.fcmToken,
                    userId: Auth.auth().currentUser?.uid ?? "",
                    title: "Test",
                    body: "Hello"
                ) {
                    print("送信完了")
                }
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
