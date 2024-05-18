//
//  ListError.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import Foundation

enum ListError: LocalizedError {
    case list(description: String)
    case `default`(description: String? = nil)

    var errorDescription: String? {
        switch self {
        case let .list(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
}
