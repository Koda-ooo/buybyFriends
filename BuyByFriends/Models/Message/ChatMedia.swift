//
//  ChatMedia.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/29.
//

import Foundation
import UIKit
import MessageKit

struct ChatMedia: MediaItem {
    var url: URL?
    var image: UIImage?
    
    /// プレースホルダー画像の取得
    var placeholderImage: UIImage {
        return UIImage()
    }
    
    /// サイズの取得
    var size: CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    }
    
    /// URLによるメディアの生成
    static func new(url: URL?) -> ChatMedia {
        ChatMedia(url: url, image: nil)
    }
    
    /// 画像によるメディアの生成
    static func new(image: UIImage?) -> ChatMedia {
        ChatMedia(url: nil, image: image)
    }
}
