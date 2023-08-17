//
//  UITabBar+changeTabBarState.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/06/03.
//

import Foundation
import SwiftUI

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}

extension UITabBar {
    private static var originalY: Double?
    
    static public func changeTabBarState(shouldHide: Bool) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ view in
            if let tabBar = view as? UITabBar {
                if !tabBar.isHidden && shouldHide {
                    originalY = (tabBar.superview?.frame.origin.y)!
                    tabBar.superview?.frame.origin.y = (tabBar.superview?.frame.origin.y)! + 4.5
                } else if tabBar.isHidden && !shouldHide {
                    guard let originalY else {
                        return
                    }
                    tabBar.superview?.frame.origin.y = originalY
                }
                tabBar.isHidden = shouldHide
                tabBar.superview?.setNeedsLayout()
                tabBar.superview?.layoutIfNeeded()
            }
        })
    }
}

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.showTabBar()
        }
    }
}
struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }
    }
}

extension View {
    
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}
