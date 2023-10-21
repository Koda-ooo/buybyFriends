//
//  InitialViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/21.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class InitialViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToObserveAuthChange = PassthroughSubject<Void, Never>()
        let startToObserveNotification = PassthroughSubject<Void, Never>()
        let startToObserveFriend = PassthroughSubject<Void, Never>()
        let startToObserveDelivery = PassthroughSubject<Void, Never>()
        let startToObservePosts = PassthroughSubject<Void, Never>()
        
        let startToLogOut = PassthroughSubject<Void, Never>()
        
        let startToFetchUserInfo = PassthroughSubject<String, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var selectedView: Tab = Tab.first
        @Published var oldSelectedView: Tab = Tab.first
        
        //遷移系
        @Published var isShownPostView = false
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var userInfo = UserInfo(dic: [:])
        @Published fileprivate(set) var notification: Notification = Notification(dic: [:])
        @Published fileprivate(set) var friend: Friend = Friend(dic: [:])
        @Published fileprivate(set) var delivery: [Delivery] = []
        @Published fileprivate(set) var posts: [Post] = []
        @Published fileprivate(set) var uid: String = ""
        
        @Published fileprivate(set) var isSignIn: Bool = false
        @Published fileprivate(set) var isLoggedIn = false
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    private let authProvider: AuthProviderObject
    private let userInfoProvider: UserInfoProviderObject
    private let notificationProvider: NotificationProviderObject
    private let friendProvider: FriendProviderObject
    private let deliveryProvider: DeliveryProviderObject
    private let postProvider: PostProviderProtocol
    
    init(authProvider: AuthProviderObject = AuthProvider(),
         userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
         notificationProvider: NotificationProviderObject = NotificationProvider(),
         friendProvider: FriendProviderObject = FriendProvider(),
         deliveryProvider: DeliveryProviderObject = DeliveryProvider(),
         postProvider: PostProviderProtocol = PostProvider()
    ) {
        self.authProvider = authProvider
        self.userInfoProvider = userInfoProvider
        self.notificationProvider = notificationProvider
        self.friendProvider = friendProvider
        self.deliveryProvider = deliveryProvider
        self.postProvider = postProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        input.startToLogOut
            .flatMap {
                authProvider.signOut()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { _ in
            }
            .store(in: &cancellables)
        
        /// ユーザーのログイン情報を監視
        input.startToObserveAuthChange
            .flatMap {
                authProvider.observeAuthChange()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { result in
                if result != nil {
                    input.startToFetchUserInfo.send(result!.uid)
                    input.startToObserveNotification.send()
                    input.startToObserveFriend.send()
                    input.startToObserveDelivery.send()
                    input.startToObservePosts.send()
                    output.uid = result!.uid
                } else {
                    output.userInfo = UserInfo(dic: [:])
                    output.isLoggedIn = false
                }
            }
            .store(in: &cancellables)
        
        ///通知情報取得
        input.startToObserveNotification
            .flatMap {
                notificationProvider.observeNotification(
                    query: Firestore.firestore()
                        .collection("Notifications")
                        .whereField("id", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                        .limit(to: 1)
                )
            }.sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                if result.count != 0 {
                    output.notification = result[0]
                }
            }
            .store(in: &cancellables)
        
        ///フレンド情報取得
        input.startToObserveNotification
            .flatMap {
                friendProvider.observeFriend(
                    query: Firestore.firestore()
                        .collection("Friends")
                        .whereField("id", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                        .limit(to: 1)
                )
            }.sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                if result.count != 0 {
                    output.friend = result[0]
                }
            }
            .store(in: &cancellables)
        
        /// Delivery情報取得
        input.startToObserveDelivery
            .flatMap {
                deliveryProvider.observeDelivery(
                    query: Firestore.firestore()
                        .collection("Deliveries")
                        .whereField("userIDs", arrayContains: Auth.auth().currentUser?.uid ?? "")
                        .whereField("isFinish", isEqualTo: false)
                )
            }.sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                if result.count != 0 {
                    output.delivery = result
                } else {
                    output.delivery = []
                }
            }
            .store(in: &cancellables)
        
        ///　ユーザー情報を取得
        input.startToFetchUserInfo
            .flatMap { id in
                userInfoProvider.fetchUserInfoo(id: id)
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { result in
                guard let result = result else {
                    return output.isSignIn = true
                }
                output.userInfo = result
                output.isLoggedIn = true
                
            }
            .store(in: &cancellables)
        
        ///　投稿情報を取得
        input.startToObservePosts
            .flatMap {
                postProvider.observePosts(query: Firestore.firestore()
                    .collection("Posts")
                    .whereField("userUID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                )
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { result in
                if !result.isEmpty {
                    output.posts = result
                } else {
                    output.posts = []
                }
            }
            .store(in: &cancellables)
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
