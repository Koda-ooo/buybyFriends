//
//  UnderlinedTextField.swift
//  BuyByFriends
//
//  Created by Masato Yasuda on 2024/05/13.
//

import SwiftUI

struct UnderlinedTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                TextField(placeholder, text: $text)
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color.gray)
                }
            }
            Divider()
                .padding(.horizontal, -20)
        }
    }
}
