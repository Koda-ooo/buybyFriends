//
//  ProfileImage.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/26.
//

import Foundation

struct ProfileImage: Identifiable, Equatable {
    var id: String
    var profileImageURL: String
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.profileImageURL = dic["profileImageURL"] as? String ?? ""
    }
}
