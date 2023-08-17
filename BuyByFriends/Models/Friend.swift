//
//  Friend.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation

struct Friend: Identifiable, Hashable, Decodable {
    var id: String
    var friendList: [String]
    var requestList: [String]
    var ngList: [String]
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.friendList = dic["friendList"] as? [String] ?? [""]
        self.requestList = dic["requestList"] as? [String] ?? [""]
        self.ngList = dic["ngList"] as? [String] ?? [""]
    }
}
