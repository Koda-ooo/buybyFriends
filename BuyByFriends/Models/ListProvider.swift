//
//  ListProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ListProvider: ListProviderProtocol {
    let db = Firestore.firestore()
    
    func observePosts(query: Query) -> AnyPublisher<[Post], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Post], ListError> in
                do {
                    let posts = try snapshot.documents.compactMap {
                        try $0.data(as: Post.self)
                    }
                    return Just(posts)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func downloadUserImageData(userInfo: UserInfo) -> AnyPublisher<(imageData: Data, userInfo: UserInfo), Error> {
        return Future<(imageData: Data, userInfo: UserInfo), Error> { promise in
            guard let url = URL(string: userInfo.profileImage) else { return }
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    promise(.success((imageData: data ?? Data(), userInfo: userInfo)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func downloadPostImageData(imageURL: String) -> AnyPublisher<(imageData: Data, imageURL: String), Error> {
        return Future<(imageData: Data, imageURL: String), Error> { promise in
            guard let url = URL(string: imageURL) else { return }
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    promise(.success((imageData: data ?? Data(), imageURL: imageURL)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
