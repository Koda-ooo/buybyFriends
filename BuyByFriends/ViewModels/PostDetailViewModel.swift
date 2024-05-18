//
//  PostDetailViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/14.
//

import Foundation
import Combine

final class PostDetailViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToFetchUserInfo = PassthroughSubject<String, Never>()

        // いいね
        let startToAddFavaritePosts = PassthroughSubject<Void, Never>()
        let startToRemoveFavaritePosts = PassthroughSubject<Void, Never>()

        // ブックマーク
        let startToAddBookmarkPosts = PassthroughSubject<Void, Never>()
        let startToRemoveBookmarkPosts = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var post: Post = Post(dic: [:])

        @Published var favariteFlag: Bool = false
        @Published var bookmarkFlag: Bool = false

        @Published var isMovedPurchaseView: Bool = false
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var userInfo: UserInfo = UserInfo(dic: [:])
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let listProvider: ListProviderProtocol
    private let userInfoProvider: UserInfoProviderObject

    init(listProvider: ListProviderProtocol = ListProvider(),
         userInfoProvider: UserInfoProviderObject = UserInfoProvider()
    ) {
        self.listProvider = listProvider
        self.userInfoProvider = userInfoProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// ユーザー情報取得
        input.startToFetchUserInfo
            .flatMap { id in
                return userInfoProvider.fetchUserInfo(id: id)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { userInfo in
                output.userInfo = userInfo
            }
            .store(in: &cancellables)

        input.startToAddFavaritePosts
            .flatMap {
                return userInfoProvider.addFavaritePosts(postID: binding.post.id)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                binding.favariteFlag = result
            }.store(in: &cancellables)

        input.startToRemoveFavaritePosts
            .flatMap {
                return userInfoProvider.removeFavaritePosts(postID: binding.post.id)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                binding.favariteFlag = !result
            }.store(in: &cancellables)

        input.startToAddBookmarkPosts
            .flatMap {
                return userInfoProvider.addBookmarkPosts(postID: binding.post.id)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                binding.bookmarkFlag = result
            }.store(in: &cancellables)

        input.startToRemoveBookmarkPosts
            .flatMap {
                return userInfoProvider.removeBookmarkPosts(postID: binding.post.id)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                binding.bookmarkFlag = !result
            }.store(in: &cancellables)

        self.input = input
        self.binding = binding
        self.output = output
    }
}
