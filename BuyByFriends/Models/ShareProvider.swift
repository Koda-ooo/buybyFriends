//
//  ShareProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/18.
//

import Foundation
import Combine
import SwiftUI

protocol ShareProviderProtocol {
    func shareToInstagramStory(imageData: Data) -> Future<Void, Error>
    func shareOnTwitter() -> Future<Void, Error>
    func shareOnLINE() -> Future<Void, Error>
}

final class ShareProvider: ShareProviderProtocol {
    let urlToBuyByFriends = "https://twitter.com" // アプリのURL
    
    func shareToInstagramStory(imageData: Data) -> Future<Void, Error> {
        return Future<Void, Error> { promise in
            _ = InstaStories.Shared.post(
                bgImage: UIImage(named: "noimage") ?? UIImage(),
                stickerData: imageData,
                contentURL: self.urlToBuyByFriends
            )
        }
    }
    
    func shareOnTwitter() -> Future<Void, Error> {
        return Future<Void, Error> { promise in
            let text = "" //ツイート本文
            let hashTag = "#BuyByFriends" //ハッシュタグ
            let completedText = text + "\n" + hashTag + "\n" + "\n" + self.urlToBuyByFriends
            
            //作成したテキストをエンコード
            let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            //エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
            if let encodedText = encodedText,
               let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func shareOnLINE() -> Future<Void, Error> {
        return Future<Void, Error> { promise in
            let urlScheme: String = "https://line.me/R/share?text="
            let text = "" //メッセージ本文
            let completedText = urlScheme + text + "\n" + self.urlToBuyByFriends
            
            //作成したテキストをエンコード
            let encodedURL = completedText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: encodedURL!)
            guard let openUrl = url else { return }
            UIApplication.shared.open(openUrl, options: .init(), completionHandler: nil)
        }
    }
}
