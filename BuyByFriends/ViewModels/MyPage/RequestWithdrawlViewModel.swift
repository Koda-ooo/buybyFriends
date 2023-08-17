//
//  RequestWithdrawViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/05.
//

import Foundation
import Combine

final class RequestWithdrawViewModel: ViewModelObject {
    final class Input: InputObject {
    }
    
    final class Binding: BindingObject {
        @Published var withdraw: Withdraw = Withdraw(dic: [:])
        @Published var requestMoney: String = ""
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var isEnabledRequestWithdrawButton: Bool = false
        @Published fileprivate(set) var requestMoney: Int?
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
        
        let convertStrToInt = binding.$requestMoney.map { Int($0) }
        let stream = convertStrToInt.map {$0}
        
        let isValidWithdraw = output.$requestMoney.map {$0 ?? 0 > 200 }
        
        ///ボタン有効フラグ
        let isEnabledRequestWithdrawButton = isValidWithdraw.map {$0}
        
        // 組み立てたストリームをoutputに反映
        cancellables.formUnion([
            isEnabledRequestWithdrawButton.assign(to: \.isEnabledRequestWithdrawButton, on: output),
            stream.assign(to: \.requestMoney, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}

