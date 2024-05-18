//
//  InventoryListViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import Combine
import SwiftUI

final class InventoryViewModel: ViewModelObject {
    final class Input: InputObject {
        let inventoryListViewDidLoad = PassthroughSubject<Void, Never>()
        let inventoryListTapped = PassthroughSubject<Inventory, Never>()
        let startButByFriends = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var selectedInventoryList: [String] = []
        @Published var userInfo: UserInfo = UserInfo(dic: [:])
        @Published var profileImageData: Data = Data()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var inventoryByGenre: [InventoryGenre: [Inventory]] = [:]
        @Published fileprivate(set) var isFinishedUploadUserInfo = false
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let userInfoProvider: UserInfoProviderObject
    private let inventoryListProvider: InventoryListProviderObject
    private let notificationProvider: NotificationProviderObject
    private let friendProvider: FriendProviderObject

    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        inventoryListProvider: InventoryListProviderObject = InventoryListProvider(),
        notificationProvider: NotificationProviderObject = NotificationProvider(),
        friendProvider: FriendProviderObject = FriendProvider()
    ) {
        self.userInfoProvider = userInfoProvider
        self.inventoryListProvider = inventoryListProvider
        self.notificationProvider = notificationProvider
        self.friendProvider = friendProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// 持ち物リスト取得の処理
        let inventryResponse = input.inventoryListViewDidLoad
            .flatMap {
                inventoryListProvider.fetchInventoryList()
            }
            .share()

        inventryResponse
            .sink(receiveCompletion: { completaion in
                switch completaion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print("Error:", err.localizedDescription)
                }
            }, receiveValue: { response in
                for genre in InventoryGenre.allCases {
                    let itemsInGenre = response.filter { $0.genreID == genre.rawValue }
                    output.inventoryByGenre[genre] = itemsInGenre
                }
            })
            .store(in: &cancellables)

        /// 持ち物リストタップ時の処理
        input.inventoryListTapped
            .sink(receiveCompletion: { completion in
                print("receiveCompletion: \(completion)")
            }, receiveValue: { _ in
                // TODO: 実装
            })
            .store(in: &cancellables)

        /// ユーザー情報作成（画像保存→ユーザー情報保存）
        input.startButByFriends
            .flatMap {
                userInfoProvider.uploadProfileImage(image: binding.profileImageData)
                    .flatMap(maxPublishers: .max(2)) { imageURL -> AnyPublisher<Bool, Error> in
                        userInfoProvider.uploadUserInfo(userInfo: binding.userInfo, imageURL: imageURL)
                    }
            }
            .sink(receiveCompletion: { completion in
                print("receiveCompletion: \(completion)")
            }, receiveValue: { result in
                output.isFinishedUploadUserInfo = result
            })
            .store(in: &cancellables)

        input.startButByFriends
            .flatMap {
                notificationProvider.uploadNotification()
            }
            .sink(receiveCompletion: { completion in
                print("receiveCompletion:\(completion)")
            }) {
                print("finish")
            }
            .store(in: &cancellables)

        input.startButByFriends
            .flatMap {
                friendProvider.uploadFriend()
            }
            .sink(receiveCompletion: { completion in
                print("receiveCompletion:\(completion)")
            }) {
                print("finish")
            }
            .store(in: &cancellables)

        self.input = input
        self.binding = binding
        self.output = output
    }

    func convertUIImageToData(image: UIImage) {
        if image == UIImage(named: "noimage") { return }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        binding.profileImageData = imageData
    }
}
