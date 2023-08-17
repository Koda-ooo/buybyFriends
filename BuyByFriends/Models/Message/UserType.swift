//
//  UserType.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import MessageKit

struct UserType: SenderType {
    var senderId: String
    var displayName: String
}
