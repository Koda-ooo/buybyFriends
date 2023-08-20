//
//  DeliveryProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/20.
//

import Foundation
import Combine

protocol DeliveryProviderObject {
    func createDelivery(post: Post, adress: Adress) -> AnyPublisher<Void, Error>
}
