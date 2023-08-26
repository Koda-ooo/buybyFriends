//
//  PurchaseProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/16.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore
import Stripe

protocol PurchaseProviderProtocol {
    func createPaymentIntent(post: Post) -> AnyPublisher<String, Error>
    func updatePost(postID: String) -> AnyPublisher<Bool, Error>
}

final class PurchaseProvider: PurchaseProviderProtocol {
    lazy var functions = Functions.functions()
    
    func createPaymentIntent(post: Post) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            self.functions.httpsCallable("createPaymentIntent").call(["price": post.price]) { result, err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    if let clientSecret = (result?.data as? [String: Any])?["clientSecret"] as? String {
                        PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                        promise(.success(clientSecret))
                    } else {
                        print("受信データなし")
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updatePost(postID: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Firestore.firestore().collection("Posts").whereField("id", isEqualTo: postID).getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                
                let id = querySnapshot?.documents.first?.documentID
                let document = Firestore.firestore().collection("Posts").document(id!)
                
                document.updateData([
                    "isSold": true,
                    "buyer": uid
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        promise(.success(true))
                    }
                }
            })
        }.eraseToAnyPublisher()
    }
    
}
