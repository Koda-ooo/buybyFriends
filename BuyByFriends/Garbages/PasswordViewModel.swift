//
//  PasswordViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import Combine

final class PasswordViewModel: ViewModelObject {
    final class Input: InputObject {
    }
    
    final class Binding: BindingObject {
        @Published var password = ""
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var isPasswordButtonEnabled = false
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        ///　パスワードバリデーション（2文字以上10文字以下）
        let isValidPassword = binding.$password
            .map {$0.count <= 10 && $0.count >= 2}
        
        ///　ボタン有効フラグ
        let isPasswordButtonEnabled = isValidPassword.map {$0}
        
        // 組み立てたストリームをbinding, outputに反映
        cancellables.formUnion([
            isPasswordButtonEnabled.assign(to: \.isPasswordButtonEnabled, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
