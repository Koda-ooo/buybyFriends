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
        let startToFetchUserInfos = PassthroughSubject<[String], Never>()
        let startToFetchPosts = PassthroughSubject<[String], Never>()
        let startToAcceptFriendRequest = PassthroughSubject<String, Never>()

        let startToUpdateIsSentFlag = PassthroughSubject<Delivery, Never>()
        let startToUpdateIsReceivedFlag = PassthroughSubject<Delivery, Never>()
        let startToUpdateIsFinishFlag = PassthroughSubject<(delivery: Delivery, post: Post), Never>()
        let startToUpdateBudget = PassthroughSubject<Int, Never>()
    }

    final class Binding: BindingObject {
        @Published var userInfos: [UserInfo] = []
        @Published var posts: [Post] = []
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
    private let postProvider: PostProviderProtocol
    private let deliveryProvider: DeliveryProviderObject

    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        notificationProvider: NotificationProviderObject = NotificationProvider(),
        friendProvider: FriendProviderObject = FriendProvider(),
        chatRoomProvider: ChatRoomProviderObject = ChatRoomProvider(),
        postProvider: PostProviderProtocol = PostProvider(),
        deliveryProvider: DeliveryProviderObject = DeliveryProvider()
    ) {
        self.userInfoProvider = userInfoProvider
        self.notificationProvider = notificationProvider
        self.friendProvider = friendProvider
        self.chatRoomProvider = chatRoomProvider
        self.postProvider = postProvider
        self.deliveryProvider = deliveryProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        input.startToFetchUserInfos
            .flatMap { uids in
                userInfoProvider.observeUserInfos(query: Firestore.firestore()
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

        input.startToFetchPosts
            .flatMap { postIDs in
                postProvider.observePosts(query: Firestore.firestore()
                    .collection("Posts")
                    .whereField("id", in: postIDs))
            }
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("FINISH")
                }
            } receiveValue: { posts in
                binding.posts = posts
            }
            .store(in: &cancellables)

        input.startToUpdateIsSentFlag
            .flatMap { delivery in
                deliveryProvider.updateIsSent(delivery: delivery)
            }
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("FINISH")
                }
            } receiveValue: { _ in

            }
            .store(in: &cancellables)

        input.startToUpdateIsReceivedFlag
            .flatMap { delivery in
                deliveryProvider.updateIsReceive(delivery: delivery)
            }
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("FINISH")
                }
            } receiveValue: { _ in

            }
            .store(in: &cancellables)

        input.startToUpdateIsFinishFlag
            .flatMap { (delivery, post) in
                deliveryProvider.updateIsFinish(delivery: delivery, post: post)
            }
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("FINISH")
                }
            } receiveValue: { price in
                input.startToUpdateBudget.send(price)
            }
            .store(in: &cancellables)

        input.startToUpdateBudget
            .flatMap { mount in
                userInfoProvider.updateBudget(mount: mount)
            }
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("FINISH")
                }
            } receiveValue: { _ in

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
