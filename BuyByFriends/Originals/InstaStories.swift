//
//  InstaStories.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/09.
//

import Foundation
import UIKit

class InstaStories: NSObject {

    private let urlScheme = URL(string: "instagram-stories://share")!
    private let urlSchemeWithFacebookAppID = URL(string: "instagram-stories://share?source_application={FacebookAppID記載}")

    enum OptionsKey: String {
        case stickerImage = "com.instagram.sharedSticker.stickerImage"
        case bgImage = "com.instagram.sharedSticker.backgroundImage"
        case bgVideo = "com.instagram.sharedSticker.backgroundVideo"
        case bgTopColor = "com.instagram.sharedSticker.backgroundTopColor"
        case bgBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
        case contentUrl = "com.instagram.sharedSticker.contentURL"
    }

    /// 背景画像を投稿
    func post(bgImage: UIImage, stickerImage: UIImage? = nil, contentURL: String? = nil) -> Bool {
        var items: [[String: Any]] = [[:]]
        // Background Image
        let bgData = bgImage.pngData()!
        items[0].updateValue(bgData, forKey: OptionsKey.bgImage.rawValue)
        // Sticker Image
        if stickerImage != nil {
            let stickerData = stickerImage!.pngData()!
            items[0].updateValue(stickerData, forKey: OptionsKey.stickerImage.rawValue)
        }
        // Content URL
        if contentURL != nil {
            items[0].updateValue(contentURL as Any, forKey: OptionsKey.contentUrl.rawValue)
        }
        let isPosted = post(items)
        return isPosted
    }

    /// 背景画像を投稿
    func post(bgImage: UIImage, stickerData: Data? = nil, contentURL: String? = nil) -> Bool {
        var items: [[String: Any]] = [[:]]
        // Background Image
        let bgData = bgImage.pngData()!
        items[0].updateValue(bgData, forKey: OptionsKey.bgImage.rawValue)
        // Sticker Data
        if let stickerData = stickerData {
            items[0].updateValue(stickerData, forKey: OptionsKey.stickerImage.rawValue)
        }
        // Content URL
        if contentURL != nil {
            items[0].updateValue(contentURL as Any, forKey: OptionsKey.contentUrl.rawValue)
        }
        let isPosted = post(items)
        return isPosted
    }

    /// 背景動画を投稿
    func post(bgVideoUrl: URL, stickerImage: UIImage? = nil, contentURL: String? = nil) -> Bool {
        var items: [[String: Any]] = [[:]]
        // Background Video
        var videoData: Data?
        do {
            try videoData = Data(contentsOf: bgVideoUrl)
        } catch {
            print("Cannot open \(bgVideoUrl)")
            return false
        }
        items[0].updateValue(videoData as Any, forKey: OptionsKey.bgVideo.rawValue)
        // Sticker Image
        if stickerImage != nil {
            let stickerData = stickerImage!.pngData()!
            items[0].updateValue(stickerData, forKey: OptionsKey.stickerImage.rawValue)
        }
        // Content URL
        if contentURL != nil {
            items[0].updateValue(contentURL as Any, forKey: OptionsKey.contentUrl.rawValue)
        }
        let isPosted = post(items)
        return isPosted
    }

    /// ステッカー画像を投稿
    func post(stickerImage: UIImage, bgTop: String = "#000000", bgBottom: String = "#000000", contentURL: String? = nil) -> Bool {
        var items: [[String: Any]] = [[:]]
        // Sticker Image
        let stickerData = stickerImage.pngData()!
        items[0].updateValue(stickerData, forKey: OptionsKey.stickerImage.rawValue)
        // Background Color
        items[0].updateValue(bgTop, forKey: OptionsKey.bgTopColor.rawValue)
        items[0].updateValue(bgBottom, forKey: OptionsKey.bgBottomColor.rawValue)
        // Content URL
        if contentURL != nil {
            items[0].updateValue(contentURL as Any, forKey: OptionsKey.contentUrl.rawValue)
        }
        let isPosted = post(items)
        return isPosted
    }

    /// Instagram Storiesへ投稿
    private func post(_ items: [[String: Any]]) -> Bool {
        guard UIApplication.shared.canOpenURL(urlScheme) else {
            print("Cannot open \(urlScheme)")
            return false
        }
        let options: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
        UIPasteboard.general.setItems(items, options: options)
        UIApplication.shared.open(urlScheme)
        return true
    }

}

// Singleton
extension InstaStories {
    class var Shared: InstaStories {
        struct Static { static let instance: InstaStories = InstaStories() }
        return Static.instance
    }
}
