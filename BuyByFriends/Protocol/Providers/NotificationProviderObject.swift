//
//  NotificationProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation
import Combine
import FirebaseFirestore

protocol NotificationProviderObject {
    func observeNotification(query: Query) -> AnyPublisher<[Notification], ListError>
    func uploadNotification() -> AnyPublisher<Void, Error>
}
