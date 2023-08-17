//
//  PostProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI
import FirebaseFirestore

protocol PostProviderProtocol {
    func fetchSelectedImages(images: [PHPickerResult]) -> Future<[UIImage], Error>
    func createImageURL(post: Post, images: [UIImage]) -> Future<Post, Error>
    func savePostToFirestore(post: Post) -> AnyPublisher<Bool, Error>
    func observePosts(query: Query) -> AnyPublisher<[Post], ListError>
}
