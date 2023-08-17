//
//  UIView+allSubViews.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/06/03.
//

import Foundation
import UIKit

extension UIView {
    func allSubviews() -> [UIView] {
        var allSubviews = subviews
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews())
        }
        return allSubviews
    }
}
