//
//  LogInViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/06/17.
//

import Foundation
import Combine

final class LogInViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToLogIn = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var phoneNumber: String = ""
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var validationText: String = ""
        @Published fileprivate(set) var isEnabledLogInButton = false
        @Published fileprivate(set) var isMovedVerificationCodeView = false
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    private let authProvider: AuthProviderObject

    init(authProvider: AuthProviderObject = AuthProvider()) {
        self.authProvider = authProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// 電話番号のバリデーション
        let isValid = binding.$phoneNumber
            .map {$0.count == 11}

        /// ログインボタン有効フラグ
        let canLogIn = isValid.map {$0}

        /// ログイン
        input.startToLogIn
            .flatMap {
                authProvider.signUpByPhoneNumber(phoneNumber: binding.phoneNumber)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { _ in
                output.isMovedVerificationCodeView.toggle()
            }
            .store(in: &cancellables)

        // 組み立てたストリームをbinding, outputに反映
        cancellables.formUnion([
            canLogIn.assign(to: \.isEnabledLogInButton, on: output)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
