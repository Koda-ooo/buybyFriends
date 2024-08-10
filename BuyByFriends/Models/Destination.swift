//
//  Onboarding.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/27.
//

import Foundation

enum Destination {
    enum Welcome {
        case phoneNumberVerification
        case verificationCode
        case finishSignUp
        case logIn
        case finishLogIn
    }

    enum UserInfo {
        case userID
        case birthDay
        case profileImage
        case inventoryList
    }

    enum List {
        case friend
        case notification
        case message
    }

    enum SearchFriends {
        case search
        case detail
    }

    enum MyPage {
        case editProfile
        case inventoryList
    }

    enum EditProfile: CaseIterable {
        case name
        case username
        case selfIntroduction
        case instagram
    }

    enum Purchase {
        case editAdress
        case editPersonalInfo
        case finishPurchase
    }

    enum PostDetail {
        case purchase
    }
}
