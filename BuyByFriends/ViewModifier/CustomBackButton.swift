//
//  CustomBackButton.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import SwiftUI

struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                        }
                    )
                    .tint(.black)
                }
            }
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}
