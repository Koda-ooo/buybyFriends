//
//  Message.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import Firebase
import MessageKit

struct Message: Decodable {
    let id: String
    let chatRoomID: String
    let senderID: String
    let message: String
    let messageType: String
    let unread: Bool
    let createdAt: Timestamp
    
    init(dic: [String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.chatRoomID = dic["chatRoomID"] as? String ?? ""
        self.senderID = dic["senderID"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.messageType = dic["messageType"] as? String ?? ""
        self.unread = dic["unread"] as? Bool ?? false
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
