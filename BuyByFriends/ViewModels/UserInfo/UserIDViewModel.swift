//
//  UserIDViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import Combine

final class UserIDViewModel: ViewModelObject {
    final class Input: InputObject {
    }
    
    final class Binding: BindingObject {
        @Published var userID = ""
    }
    
    final class Output: OutputObject {
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
        
        ///ユーザーIDバリデーション（2文字以上10文字以下）
        let isValidUserID = binding.$userID
            .map {$0.count <= 10 && $0.count >= 2}
        
        ///ボタン有効フラグ
        let isUserIDButtonEnabled = isValidUserID.map {$0}
        
        // 組み立てたストリームをbinding, outputに反映
        cancellables.formUnion([
            isUserIDButtonEnabled.assign(to: \.isEnabledNextButton, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
