//
//  DeliveryProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/20.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

struct DeliveryProvider: DeliveryProviderObject {
    func updateIsSent(delivery: Delivery) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let document = Firestore.firestore().collection("Deliveries").document(delivery.id)
            document.updateData([
                "isSent": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func updateIsReceive(delivery: Delivery) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let document = Firestore.firestore().collection("Deliveries").document(delivery.id)
            document.updateData([
                "isReceived": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func updateIsFinish(delivery: Delivery, post: Post) -> AnyPublisher<Int, Error> {
        return Future<Int, Error> { promise in
            let document = Firestore.firestore().collection("Deliveries").document(delivery.id)
            document.updateData([
                "isFinish": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    promise(.success((post.price)))
                }
            }
        }.eraseToAnyPublisher()
    }

    func createDelivery(post: Post, adress: Adress) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userIDs = [uid, post.userUID]
            let docID = UUID().uuidString

            let docData: [String: Any] = [
                "id": docID,
                "adress": [
                    "postNumber": adress.postNumber,
                    "prefecture": adress.prefecture,
                    "city": adress.city,
                    "number": adress.number,
                    "buildingName": adress.buildingName,
                    "kanjiName": adress.kanjiName,
                    "kanaName": adress.kanaName,
                    "phoneNumber": adress.phoneNumber,
                    "email": adress.email
                ],
                "userIDs": userIDs,
                "buyerID": uid,
                "sellerID": post.userUID,
                "postID": post.id,
                "isSent": false,
                "isReceived": false,
                "isFinish": false,
                "createdAt": Timestamp()
            ]

            Firestore.firestore().collection("Deliveries").document(docID).setData(docData) { err in
                if let err = err {
                    print("ChatRoom情報の保存に失敗しました。\(err)")
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    func observeDelivery(query: Query) -> AnyPublisher<[Delivery], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Delivery], ListError> in
                do {
                    let delivery = try snapshot.documents.compactMap {
                        try $0.data(as: Delivery.self)
                    }
                    return Just(delivery)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

}
