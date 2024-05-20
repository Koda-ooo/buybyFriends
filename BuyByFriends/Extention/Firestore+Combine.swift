//
//  Firestore+Combine.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/06.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: Firestore+Combine
extension Firestore {
    /// 取得
    func fetch<T: Codable>(ref: Query) -> AnyPublisher<[T], Error> {
        return Future<[T], Error> { promise in
            ref.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                if let snapshot = snapshot {
                    do {
                        let entities: [T] = try snapshot.documents.compactMap {
                            try Self.Decoder().decode(T.self, from: $0.data(), in: $0.reference)
                        }
                        promise(.success(entities))
                    } catch let error {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    /// 追加
    func add<T: Codable>(ref: DocumentReference, data: T) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let `self` = self else { return }

            do {
                let encodeData = try self.encode(data: data)
                ref.setData(encodeData) { error in

                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    promise(.success(()))
                }
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// 削除
    func delete(ref: DocumentReference) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            ref.delete { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    private func encode<T: Codable>(data: T) throws -> [String: Any] {
        do {
            return try Firestore.Encoder().encode(data)
        } catch {
            throw FirestoreEncodeError()
        }
    }
}

// MARK: - Custom Error
struct FirestoreEncodeError: Error {}
