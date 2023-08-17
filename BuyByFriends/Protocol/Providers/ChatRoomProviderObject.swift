//
//  ChatRoomProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import Combine
import FirebaseFirestore

protocol ChatRoomProviderObject {
    func createChatRoom(partnerID: String) -> AnyPublisher<Void, Error>
    func observeChatRoom(query: Query) -> AnyPublisher<[ChatRoom], ListError>
    func updateLatestMessageID(chatRoomID: String, messageID: String) -> AnyPublisher<Void, Error>
}
