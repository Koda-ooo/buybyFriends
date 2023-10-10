//
//  InventoryList.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/23.
//

import Foundation

struct Inventory: Identifiable, Hashable {
    var id: String
    var genreID: Int
    var name: String
    var selected: Bool
    var sequence: Int
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.genreID = dic["genreID"] as? Int ?? 0
        self.name = dic["name"] as? String ?? ""
        self.selected = dic["selected"] as? Bool ?? false
        self.sequence = dic["sequence"] as? Int ?? 0
    }
}

enum InventoryGenre: Int, CaseIterable, Comparable {
    
    static func < (lhs: InventoryGenre, rhs: InventoryGenre) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case outer = 1
    case tops = 2
    case bottoms = 3
    case allIn = 4
    case shoes = 5
    case accessory = 6
    case goods = 7
    case other = 100
    
    var text: String {
        switch self {
        case .outer:
            return "アウター"
        case .tops:
            return "トップス"
        case .bottoms:
            return "ボトムス"
        case .allIn:
            return "オールイン"
        case .shoes:
            return "シューズ"
        case .accessory:
            return "アクセサリー"
        case .goods:
            return "小物"
        case .other:
            return "その他"
        }
    }
}
