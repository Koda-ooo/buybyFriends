//
//  Post.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/06.
//

import Foundation
import Firebase

struct Post: Identifiable, Codable, Hashable {
    var id: String
    var userUID: String
    var userID: String
    var images: [String]
    var explain: String
    var category: String
    var brand: String
    var size: String
    var condition: String
    var price: Int
    var isSold: Bool
    var buyer: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.userUID = dic["userUID"] as? String ?? ""
        self.userID = dic["userID"] as? String ?? ""
        self.images = dic["images"] as? [String] ?? [""]
        self.explain = dic["explain"] as? String ?? ""
        self.category = dic["category"] as? String ?? ""
        self.brand = dic["brand"] as? String ?? ""
        self.size = dic["size"] as? String ?? ""
        self.condition = dic["condition"] as? String ?? ""
        self.price = dic["price"] as? Int ?? 0
        self.isSold = dic["isSold"] as? Bool ?? false
        self.buyer = dic["buyer"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
