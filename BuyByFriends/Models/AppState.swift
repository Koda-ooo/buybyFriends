//
//  AppState.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/21.
//

import Foundation
import SwiftUI

final class AppState: ObservableObject{
    struct Session {
        var isLoggedIn = false
        var userInfo: UserInfo = UserInfo(dic: [:])
        var notification: Notification = Notification(dic: [:])
        var friend: Friend = Friend(dic: [:])
        
        var userImage = UIImage()
    }
    
    @Published public var session = Session()
}
