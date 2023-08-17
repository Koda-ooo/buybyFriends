//
//  NotificationProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

final class NotificationProvider: NotificationProviderObject {
    
    func observeNotification(query: Query) -> AnyPublisher<[Notification], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Notification], ListError> in
                do {
                    let notification = try snapshot.documents.compactMap {
                        try $0.data(as: Notification.self)
                    }
                    return Just(notification)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func uploadNotification() -> AnyPublisher<Void, Error> {
        return Future<Void,Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let saveDocument = Firestore.firestore().collection("Notifications").document(uid)
            let uploadList: [String: Any] = [
                "id": uid,
                "unreadRequest": false,
                "unreadMessage": false,
                "requests": []
            ]
            
            saveDocument.setData(
                uploadList
            ){ (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    promise(.failure(err.self))
                }
                print("Firestoreへの保存に成功しました。")
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}
