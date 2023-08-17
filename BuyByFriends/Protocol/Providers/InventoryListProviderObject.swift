//
//  InventoryListProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine

protocol InventoryListProviderObject {
    func fetchInventoryList() -> AnyPublisher<[Inventory], Error>
}
