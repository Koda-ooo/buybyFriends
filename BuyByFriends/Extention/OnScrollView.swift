//
//  OnScrollView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/09.
//

import SwiftUI

struct OnScrollView: Gesture {
    @FocusState var focus:Bool
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                if value.translation.height != 0 {
                    self.focus = false
                }
            }
    }
}
