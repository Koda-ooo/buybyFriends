//
//  UIApplication+CloseKeyboard.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
