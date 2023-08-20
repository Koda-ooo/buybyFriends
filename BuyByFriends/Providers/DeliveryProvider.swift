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
    func createDelivery(post: Post, adress: Adress) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userIDs = [uid, post.userID]
            let docID = UUID().uuidString
            
            let docData: [String:Any] = [
                "id": docID,
                "adress": adress,
                "userIDs": userIDs,
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
}
