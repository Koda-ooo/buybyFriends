//
//  NotificationViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import Foundation
import Combine
import FirebaseFirestore

final class NotificationViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToFetchUserInfosOfRequest = PassthroughSubject<[String], Never>()
        let startToAcceptFriendRequest = PassthroughSubject<String, Never>()
    }
    
    final class Binding: BindingObject {
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
    private let chatRoomProvider: ChatRoomProviderObject
    
    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        notificationProvider: NotificationProviderObject = NotificationProvider(),
        friendProvider: FriendProviderObject = FriendProvider(),
        chatRoomProvider: ChatRoomProviderObject = ChatRoomProvider()
    ) {
        self.userInfoProvider = userInfoProvider
        self.notificationProvider = notificationProvider
        self.friendProvider = friendProvider
        self.chatRoomProvider = chatRoomProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        input.startToFetchUserInfosOfRequest
            .flatMap { uids in
                userInfoProvider.fetchUserInfosInFriendRequest(query: Firestore.firestore()
                        .collection("UserInfos")
                        .whereField("id", in: uids)
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
                binding.userInfos = result
            }
            .store(in: &cancellables)
        
        input.startToAcceptFriendRequest
            .flatMap { uid in
                friendProvider.addMyFriendList(uid: uid)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
            }
            .store(in: &cancellables)
        
        input.startToAcceptFriendRequest
            .flatMap { uid in
                friendProvider.addPartnerFriendList(uid: uid)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
            }
            .store(in: &cancellables)
        
        input.startToAcceptFriendRequest
            .flatMap { uid in
                friendProvider.removeMyRequestList(uid: uid)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
            }
            .store(in: &cancellables)
        
        input.startToAcceptFriendRequest
            .flatMap { uid in
                chatRoomProvider.createChatRoom(partnerID: uid)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
            }
            .store(in: &cancellables)
        
        /// 組み立てたストリームを反映
        cancellables.formUnion([
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
