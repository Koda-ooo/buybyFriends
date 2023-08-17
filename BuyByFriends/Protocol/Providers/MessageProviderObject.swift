//
//  MessageProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/27.
//

import Foundation
import Combine
import FirebaseFirestore

protocol MessageProviderObject {
    func observeMessage(query: Query) -> AnyPublisher<[Message], ListError>
    func createTextMessage(chatRoomID: String, text: String) -> AnyPublisher<Message, Error>
    func createImageURL(image: Data) -> AnyPublisher<String, Error>
    func createImageMessage(chatRoomID: String, imageURL: String) -> AnyPublisher<Message, Error>
    func fetchMessage(chatRoomID: String, messageID: String) -> AnyPublisher<Message, Error>
}
