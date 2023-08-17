//
//  UsernameViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import Combine

final class UsernameViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToSignIn = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var username = ""
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var validationText: String = ""
        @Published fileprivate(set) var isEnabledNextButton = false
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        ///ユーザーネームバリデーション（2文字以上10文字以下）
        let isValidUsername = binding.$username
            .map {$0.count <= 10 && $0.count >= 2}
        
        ///ボタン有効フラグ
        let isUsernameButtonEnabled = isValidUsername.map {$0}
        
        // 組み立てたストリームをoutputに反映
        cancellables.formUnion([
            isUsernameButtonEnabled.assign(to: \.isEnabledNextButton, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}

