//
//  MessageKindType.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/29.
//

import Foundation

enum MessageKindType {
    case text(message: String)
    case image(mediaItem: ChatMedia)
}
