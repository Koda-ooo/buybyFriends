//
//  AuthError.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/19.
//

import Foundation

enum AuthError: Error {
    case invalidIdOrPassword
    case invalidCredential
    case notCompletedSignIn
    case notCompletedRegisterProfile
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "認証コードが異なります"
        case .invalidIdOrPassword:
            return ""
        case .notCompletedSignIn:
            return "サインイン・サインアップが完了していません"
        case .notCompletedRegisterProfile:
            return "プロフィール登録が完了していません"
        }
    }
}
