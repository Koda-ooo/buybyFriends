//
//  RootPresentationModeKey.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/27.
//

import Foundation
import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self]}
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {

    public mutating func dismiss() {
        self.toggle()
    }
}
