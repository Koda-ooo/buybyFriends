//
//  ChatRoom.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import FirebaseFirestore

struct ChatRoom: Identifiable, Decodable, Hashable {
    var id: String
    var members: [String]
    var latestMessageID: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? []
        self.latestMessageID = dic["latestMessageID"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
