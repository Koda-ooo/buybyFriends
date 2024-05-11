//
//  FriendProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FriendProviderObject {
    func observeFriend(query: Query) -> AnyPublisher<[Friend], ListError>
    func uploadFriend() -> AnyPublisher<Void, Error>
    func fetchFriend(uid: String) -> AnyPublisher<Friend, Error>

    func addPartnerRequestList(friend: Friend) -> AnyPublisher<Void, Error>
    func removeMyRequestList(uid: String) -> AnyPublisher<Void, Error>

    func addMyFriendList(uid: String) -> AnyPublisher<Void, Error>
    func addPartnerFriendList(uid: String) -> AnyPublisher<Void, Error>

    func removeMyFriendList(uid: String) -> AnyPublisher<Void, Error>
    func removePartnerFriendList(uid: String) -> AnyPublisher<Void, Error>
}
