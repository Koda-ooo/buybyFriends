//
//  ListProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine
import FirebaseFirestore

protocol ListProviderProtocol {
    func observePosts(query: Query) -> AnyPublisher<[Post], ListError>
    func downloadUserImageData(userInfo: UserInfo) -> AnyPublisher<(imageData: Data, userInfo: UserInfo), Error>
    func downloadPostImageData(imageURL: String) -> AnyPublisher<(imageData: Data, imageURL: String), Error>
}
