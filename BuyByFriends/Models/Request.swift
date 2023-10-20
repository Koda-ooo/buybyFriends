//
//  Request.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/09/03.
//

import Foundation
import Firebase

struct Request: Identifiable, Hashable {
    var id: String
    var type: String
    var userID: String
    
    var explain: String
    var category: String
    var brand: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.type = dic["type"] as? String ?? ""
        self.userID = dic["userID"] as? String ?? ""
        self.explain = dic["explain"] as? String ?? ""
        self.category = dic["category"] as? String ?? ""
        self.brand = dic["brand"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}

enum RequestType {
    case inventory
}
