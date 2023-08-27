//
//  DeliveryProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/20.
//

import Foundation
import Combine
import FirebaseFirestore

protocol DeliveryProviderObject {
    func createDelivery(post: Post, adress: Adress) -> AnyPublisher<Void, Error>
    func updateIsSent(delivery: Delivery) -> AnyPublisher<Void, Error>
    func updateIsReceive(delivery: Delivery) -> AnyPublisher<Void, Error>
    func updateIsFinish(delivery: Delivery, post: Post) -> AnyPublisher<Int, Error>
    func observeDelivery(query: Query) -> AnyPublisher<[Delivery], ListError>
}
