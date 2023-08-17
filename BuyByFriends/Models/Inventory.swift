//
//  InventoryList.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/23.
//

import Foundation

struct Inventory: Identifiable, Hashable {
    var id: Int
    var name: String
    var selected: Bool
    var sequence: Int
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? Int ?? 0
        self.name = dic["name"] as? String ?? ""
        self.selected = dic["selected"] as? Bool ?? false
        self.sequence = dic["sequence"] as? Int ?? 0
    }
}
