//
//  User.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/19.
//

import Foundation
import Firebase

struct UserInfo: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var name: String
    var userID: String
    var birthDay: Date
    var profileImage: String
    var inventoryList: [String]
    var selfIntroduction: String
    var instagramID: String
    var budget: Int
    var createdAt: Timestamp
    var fcmToken: String
    var favoritePosts: [String]
    var bookmarkPosts: [String]
    var wishList: [Int: String]

    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.userID = dic["userID"] as? String ?? ""
        self.birthDay = dic["birthDay"] as? Date ?? Date()
        self.profileImage = dic["profileImage"] as? String ?? ""
        self.inventoryList = dic["inventoryList"] as? [String] ?? []
        self.selfIntroduction = dic["selfIntroduction"] as? String ?? ""
        self.instagramID = dic["instagramID"] as? String ?? ""
        self.budget = dic["budget"] as? Int ?? 0
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.fcmToken = dic["fcmToken"] as? String ?? ""
        self.favoritePosts = dic["favoritePosts"] as? [String] ?? []
        self.bookmarkPosts = dic["bookmarkPosts"] as? [String] ?? []
        self.wishList = dic["wishList"] as? [Int: String] ?? [:]
    }
}
