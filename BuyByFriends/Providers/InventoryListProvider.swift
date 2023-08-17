//
//  InventoryListProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine
import FirebaseFirestore

final class InventoryListProvider: InventoryListProviderObject {
    func fetchInventoryList() -> AnyPublisher<[Inventory], Error> {
        return Future<[Inventory], Error> { promise in
            var inventoryList = [Inventory]()
            Firestore.firestore().collection("InventoryList").getDocuments { (documents, err) in
                if let err = err {
                    print("持ち物リスト情報の取得に失敗しました。\(err)")
                    return
                }
                guard let documents = documents else {
                    print("持ち物リストの情報が存在しません")
                    return
                }
                for document in documents.documents {
                    let inventory = Inventory(dic: document.data())
                    inventoryList.append(inventory)
                }
                inventoryList.sort{ (m1, m2) -> Bool in
                    let m1Date = m1.sequence
                    let m2Date = m2.sequence
                    return m1Date < m2Date
                }
                promise(.success(inventoryList))
            }
        }.eraseToAnyPublisher()
    }
}
