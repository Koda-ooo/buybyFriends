//
//  MessageProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/27.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class MessageProvider: MessageProviderObject {

    func observeMessage(query: Query) -> AnyPublisher<[Message], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Message], ListError> in
                do {
                    let messages = try snapshot.documents.compactMap {
                        try $0.data(as: Message.self)
                    }
                    return Just(messages)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

    func createTextMessage(chatRoomID: String, text: String) -> AnyPublisher<Message, Error> {
        return Future<Message, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let saveMessage = Firestore.firestore().collection("ChatRooms").document(chatRoomID).collection("Messages").document()

            let messageData = [
                "id": saveMessage.documentID,
                "chatRoomID": chatRoomID,
                "senderID": uid,
                "message": text,
                "messageType": "text",
                "unread": true,
                "createdAt": Timestamp()
            ] as [String: Any]

            saveMessage.setData(messageData) { err in
                if let err = err {
                    print("メッセージ情報の保存に失敗しました。\(err)")
                    promise(.failure(err))
                    return
                }
                promise(.success(Message(dic: messageData)))
            }
        }.eraseToAnyPublisher()
    }

    func createImageURL(image: Data) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("message_image").child(fileName)

            storageRef.putData(image, metadata: nil) { (_, err) in
                if let err = err {
                    print("Firestorageへの保存に失敗しました。\(err)")
                    return
                }
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        print("Firestorageからのダウンロードに失敗しました。\(err)")
                        return
                    }
                    guard let urlString = url?.absoluteString else { return }
                    promise(.success(urlString))
                }
            }
        }.eraseToAnyPublisher()
    }

    func createImageMessage(chatRoomID: String, imageURL: String) -> AnyPublisher<Message, Error> {
        return Future<Message, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let saveMessage = Firestore.firestore().collection("ChatRooms").document(chatRoomID).collection("Messages").document()

            let messageData = [
                "id": saveMessage.documentID,
                "chatRoomID": chatRoomID,
                "senderID": uid,
                "message": imageURL,
                "messageType": "image",
                "unread": true,
                "createdAt": Timestamp()
            ] as [String: Any]

            saveMessage.setData(messageData) { err in
                if let err = err {
                    print("メッセージ情報の保存に失敗しました。\(err)")
                    promise(.failure(err))
                    return
                }
                promise(.success(Message(dic: messageData)))
            }
        }.eraseToAnyPublisher()
    }

    func fetchMessage(chatRoomID: String, messageID: String) -> AnyPublisher<Message, Error> {
        return Future<Message, Error> { promise in
            Firestore.firestore()
                .collection("ChatRooms").document(chatRoomID)
                .collection("Messages").document(messageID)
                .getDocument { (document, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                guard let document = document, let dic = document.data() else { return }
                promise(.success(Message(dic: dic)))
            }
        }.eraseToAnyPublisher()
    }
}
