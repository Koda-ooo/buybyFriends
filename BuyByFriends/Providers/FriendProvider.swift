//
//  FriendProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

final class FriendProvider: FriendProviderObject {

    func observeFriend(query: Query) -> AnyPublisher<[Friend], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Friend], ListError> in
                do {
                    let friend = try snapshot.documents.compactMap {
                        try $0.data(as: Friend.self)
                    }
                    return Just(friend)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

    func uploadFriend() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let saveDocument = Firestore.firestore().collection("Friends").document(uid)
            let uploadList: [String: Any] = [
                "id": uid,
                "friendList": [],
                "requestList": [],
                "ngList": []
            ]

            saveDocument.setData(
                uploadList
            ) { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    promise(.failure(err.self))
                }
                print("Firestoreへの保存に成功しました。")
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    func fetchFriend(uid: String) -> AnyPublisher<Friend, Error> {
        return Future<Friend, Error> { promise in
            Firestore.firestore().collection("Friends").document(uid).getDocument { (document, err) in
                if let err = err {
                    print("Friend情報の取得に失敗しました。\(err)")
                    promise(.failure(err.self))
                }
                guard let document = document, let dic = document.data() else { return }
                promise(.success(Friend(dic: dic)))
            }
        }.eraseToAnyPublisher()
    }

    func addPartnerRequestList(friend: Friend) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            if friend.ngList.contains(myUid) || friend.requestList.contains(myUid) {
                return print("既に送信済みです。みたいなのを表示させる導線を引く")
            }
            let document = Firestore.firestore().collection("Friends").document(friend.id)
            let updateList: [String: Any] = [
                "requestList": FieldValue.arrayUnion([myUid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }

    func addMyFriendList(uid: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("Friends").document(myUid)
            let updateList: [String: Any] = [
                "friendList": FieldValue.arrayUnion([uid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }

    func addPartnerFriendList(uid: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("Friends").document(uid)
            let updateList: [String: Any] = [
                "friendList": FieldValue.arrayUnion([myUid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }

    func removeMyRequestList(uid: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("Friends").document(myUid)
            let updateList: [String: Any] = [
                "requestList": FieldValue.arrayRemove([uid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }

    func removeMyFriendList(uid: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("Friends").document(myUid)
            let updateList: [String: Any] = [
                "friendList": FieldValue.arrayRemove([uid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }

    func removePartnerFriendList(uid: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("Friends").document(uid)
            let updateList: [String: Any] = [
                "friendList": FieldValue.arrayRemove([myUid])
            ]

            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }

        }.eraseToAnyPublisher()
    }
}
