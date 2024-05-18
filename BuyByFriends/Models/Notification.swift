//
//  Notification.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import Foundation

struct Notification: Identifiable, Hashable, Decodable {
    var id: String
    var unreadRequest: Bool
    var unreadMessage: Bool

    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.unreadRequest = dic["unreadRequest"] as? Bool ?? false
        self.unreadMessage = dic["unreadMessage"] as? Bool ?? false
    }
}
