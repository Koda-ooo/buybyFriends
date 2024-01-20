//
//  InventoryList.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/23.
//

import Foundation

struct Inventory: Identifiable, Hashable {
    var id: String
    var name: String
    var selected: Bool
    var sequence: Int
    var genreID: Int
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.selected = dic["selected"] as? Bool ?? false
        self.sequence = dic["sequence"] as? Int ?? 0
        self.genreID = dic["genreID"] as? Int ?? 0
    }
}

enum InventoryGenre {
    case outer
    case tops
    case bottoms
    case allIn
    case shoes
    case accessory
    case goods
    case othrers
    
    var name: String {
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
        case .othrers:
            return "その他"
        }
    }
    
    var id: Int {
        switch self {
        case .outer:
            return 1
        case .tops:
            return 2
        case .bottoms:
            return 3
        case .allIn:
            return 4
        case .shoes:
            return 5
        case .accessory:
            return 6
        case .goods:
            return 7
        case .othrers:
            return 100
        }
    }
    
    var sequence: Int {
        switch self {
        case .outer:
            return 1
        case .tops:
            return 2
        case .bottoms:
            return 3
        case .allIn:
            return 4
        case .shoes:
            return 5
        case .accessory:
            return 6
        case .goods:
            return 7
        case .othrers:
            return 100
        }
    }
    
    static func names() -> [String] {
        return [
            InventoryGenre.outer.name,
            InventoryGenre.tops.name,
            InventoryGenre.bottoms.name,
            InventoryGenre.allIn.name,
            InventoryGenre.shoes.name,
            InventoryGenre.accessory.name,
            InventoryGenre.goods.name,
            InventoryGenre.othrers.name
        ]
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
