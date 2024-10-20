//
//  UserInfoProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine
import FirebaseFirestore

protocol UserInfoProviderObject {
    func fetchUserInfo(id: String) -> AnyPublisher<UserInfo, Error>
    func fetchUserInfoo(id: String) -> AnyPublisher<UserInfo?, Error>
    func fetchUserInfos(userID: String) -> AnyPublisher<[UserInfo], Error>

    func observeUserInfos(query: Query) -> AnyPublisher<[UserInfo], ListError>

    func uploadProfileImage(image: Data) -> AnyPublisher<String, Error>
    func uploadUserInfo(userInfo: UserInfo, imageURL: String) -> AnyPublisher<Bool, Error>

    func updateBudget(mount: Int) -> AnyPublisher<Void, Error>
    func updateInventory(inventory: [Inventory]) -> AnyPublisher<Void, Error>

    func addFavaritePosts(postID: String) -> AnyPublisher<Bool, Error>
    func addBookmarkPosts(postID: String) -> AnyPublisher<Bool, Error>

    func removeFavaritePosts(postID: String) -> AnyPublisher<Bool, Error>
    func removeBookmarkPosts(postID: String) -> AnyPublisher<Bool, Error>

    func saveWishList(genre: InventoryGenre, text: String) -> AnyPublisher<Bool, Error>
    func removeWishList() -> AnyPublisher<Bool, Error>
}
