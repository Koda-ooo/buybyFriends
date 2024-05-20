//
//  WithdrawViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/03.
//

import Foundation
import Combine

final class WithdrawViewModel: ViewModelObject {
    final class Input: InputObject {
    }

    final class Binding: BindingObject {
        @Published var withdraw: Withdraw = Withdraw(dic: [:])
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isEnabledNextButton: Bool = false
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false

    init() {
        let input = Input()
        let binding = Binding()
        let output = Output()

        /// ユーザーネームバリデーション（2文字以上10文字以下）
        let isValidWithdraw = binding.$withdraw
            .map {
                $0.bankName != "" &&
                $0.bankAccountType != "" &&
                $0.branchCode != "" &&
                $0.bankAccountNumber != "" &&
                $0.firstName != "" &&
                $0.lastName != ""
            }

        /// ボタン有効フラグ
        let isEnabledNextButton = isValidWithdraw.map {$0}

        // 組み立てたストリームをoutputに反映
        cancellables.formUnion([
            isEnabledNextButton.assign(to: \.isEnabledNextButton, on: output)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
