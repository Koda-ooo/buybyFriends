//
//  MyPageViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/19.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class MyPageViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToFetchInfos = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var uid: String = ""
        
        @Published var isMyPage: Bool = false
        @Published var isShownMyPageHumbergerMenu: Bool = false
        @Published var isShownHalfWishListView: Bool = false
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var userInfo: UserInfo = UserInfo(dic: [:])
        @Published fileprivate(set) var posts: [Post] = []
        @Published fileprivate(set) var friend: Friend = Friend(dic: [:])
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let myPageProvider: MyPageProviderProtocol
    private let userInfoProvider: UserInfoProviderObject
    private let postProvider: PostProviderProtocol
    private let friendProvider: FriendProviderObject
    
    init(
        myPageProvider: MyPageProviderProtocol = MyPageProvider(),
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        postProvider: PostProviderProtocol = PostProvider(),
        friendProvider: FriendProviderObject = FriendProvider()
    ) {
        self.myPageProvider = myPageProvider
        self.userInfoProvider = userInfoProvider
        self.postProvider = postProvider
        self.friendProvider = friendProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        let isValidMyPage = binding.$uid
            .map { uid in
                return uid == Auth.auth().currentUser?.uid
            }
            .replaceError(with: false)
        
        input.startToFetchInfos
            .flatMap {
                userInfoProvider.observeUserInfos(query: Firestore.firestore()
                    .collection("UserInfos")
                    .whereField("id", isEqualTo: binding.uid))
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                if let userInfo = result.first {
                    output.userInfo = userInfo
                }
            }
            .store(in: &cancellables)
        
        input.startToFetchInfos
            .flatMap {
                postProvider.observePosts(query: Firestore.firestore()
                    .collection("Posts")
                    .whereField("userUID", isEqualTo: binding.uid)
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
                output.posts = result
                output.posts.sort{ (m1, m2) -> Bool in
                    let m1Date = m1.createdAt.dateValue()
                    let m2Date = m2.createdAt.dateValue()
                    return m1Date > m2Date
                }
            }
            .store(in: &cancellables)
        
        input.startToFetchInfos
            .flatMap {
                friendProvider.observeFriend(query: Firestore.firestore()
                    .collection("Friends")
                    .whereField("id", isEqualTo: binding.uid)
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
                if let friend = result.first {
                    output.friend = friend
                }
            }
            .store(in: &cancellables)
        
        /// 組み立てたストリームを反映
        cancellables.formUnion([
            isValidMyPage.assign(to: \.isMyPage, on: binding)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
    
    func startToFetchInfos() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if binding.uid != uid {
            self.input.startToFetchInfos.send()
            self.binding.isMyPage = false
        } else {
            self.binding.isMyPage = true
        }
    }
}
