//
//  ChatRoomProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class ChatRoomProvider: ChatRoomProviderObject {
    
    func createChatRoom(partnerID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let members = [uid, partnerID]
            let docID = UUID().uuidString
            
            let docData: [String:Any] = [
                "id": docID,
                "members": members,
                "latestMessageID": "",
                "createdAt": Timestamp()
            ]
            
            Firestore.firestore().collection("ChatRooms").document(docID).setData(docData) { err in
                if let err = err {
                    print("ChatRoom情報の保存に失敗しました。\(err)")
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func observeChatRoom(query: Query) -> AnyPublisher<[ChatRoom], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[ChatRoom], ListError> in
                do {
                    let chatrooms = try snapshot.documents.compactMap {
                        try $0.data(as: ChatRoom.self)
                    }
                    return Just(chatrooms)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func updateLatestMessageID(chatRoomID: String, messageID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let document = Firestore.firestore().collection("ChatRooms").document(chatRoomID)
            let updateList: [String: Any] = [
                "latestMessageID": messageID
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
