//
//  BirthDayViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import Combine

final class BirthDayViewModel: ViewModelObject {
    final class Input: InputObject {
    }
    
    final class Binding: BindingObject {
        @Published var birthDay = Date()
    }
    
    final class Output: OutputObject {
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        //年齢制限のValidationを記載予定
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
