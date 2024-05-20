//
//  MockMessage.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import UIKit
import MessageKit

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kindType: MessageKindType

    var kind: MessageKind {
        switch kindType {
        case .text(message: let message):
            return .attributedText(NSAttributedString(
                string: message,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18.0),
                    .foregroundColor: UIColor.black
                ]))
        case .image(mediaItem: let mediaItem):
            return .photo(mediaItem)
        }
    }

    /// テキストメッセージの生成
    static func new(sender: SenderType, messageId: String, sentDate: Date, message: String) -> ChatMessage {
        return ChatMessage(
            sender: sender,
            messageId: messageId,
            sentDate: sentDate,
            kindType: .text(message: message)
        )
    }

    /// 画像メッセージの生成（URLから）
    static func new(sender: SenderType, messageId: String, sentDate: Date, url: String) -> ChatMessage {
        return ChatMessage(
            sender: sender,
            messageId: messageId,
            sentDate: sentDate,
            kindType: .image(mediaItem: ChatMedia.new(url: URL(string: url)))
        )
    }

    /// 画像メッセージの生成（UIImageから）
    static func new(sender: SenderType, messageId: String, sentDate: Date, image: UIImage) -> ChatMessage {
        return ChatMessage(
            sender: sender,
            messageId: messageId,
            sentDate: sentDate,
            kindType: .image(mediaItem: ChatMedia.new(image: image))
        )
    }
}
