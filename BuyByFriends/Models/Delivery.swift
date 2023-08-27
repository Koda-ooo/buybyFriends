//
//  Delivery.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/20.
//

import Foundation
import Firebase

struct Delivery: Identifiable, Hashable, Decodable {
    var id: String
    var adress: Adress
    var userIDs: [String]
    var buyerID: String
    var sellerID: String
    var postID: String
    var isSent: Bool
    var isReceived: Bool
    var isFinish: Bool
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.adress = Adress(dic: dic["adress"] as? [String : Any] ?? [:])
        self.postID = dic["postID"] as? String ?? ""
        self.buyerID = dic["buyerID"] as? String ?? ""
        self.sellerID = dic["sellerID"] as? String ?? ""
        self.userIDs = dic["userIDs"] as? [String] ?? []
        self.isSent = dic["isSent"] as? Bool ?? false
        self.isReceived = dic["isReceived"] as? Bool ?? false
        self.isFinish = dic["isFinish"] as? Bool ?? false
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}

struct Adress: Decodable, Hashable {
    var postNumber: String
    var prefecture: String
    var city: String
    var number: String
    var buildingName: String
    var kanjiName: String
    var kanaName: String
    var phoneNumber: String
    var email: String
    
    init(dic: [String: Any]) {
        self.postNumber = dic["postNumber"] as? String ?? ""
        self.prefecture = dic["prefecture"] as? String ?? ""
        self.city = dic["city"] as? String ?? ""
        self.number = dic["number"] as? String ?? ""
        self.buildingName = dic["buildingName"] as? String ?? ""
        self.kanjiName = dic["kanjiName"] as? String ?? ""
        self.kanaName = dic["kanaName"] as? String ?? ""
        self.phoneNumber = dic["phoneNumber"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
    }
}
