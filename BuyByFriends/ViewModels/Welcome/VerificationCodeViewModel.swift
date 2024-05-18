//
//  VerificationCodeViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/20.
//

import Foundation
import Combine

final class VerificationCodeViewModel: ViewModelObject {
    final class Input: InputObject {
        let signinTapped = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var verificationCode = ""
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isEnabledSignInButton = false
        @Published fileprivate(set) var isMovedUsernameView = false
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let authProvider: AuthProviderObject

    init(authProvider: AuthProviderObject = AuthProvider()) {
        self.authProvider = authProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// 認証コードのバリデーション（6文字）
        let isValid = binding.$verificationCode
            .map {$0.count == 6}

        /// サインインボタン有効フラグ
        let isSigninEnabled = isValid.map {$0}

        /// サインイン処理
        input.signinTapped
            .flatMap {
                authProvider.signInByPhoneNumber(verificationCode: binding.verificationCode)
                    .catch { error -> Just<String> in
                        print("Error:", error.localizedDescription)
                        return .init("")
                    }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { result in
                if result != "" {
                    output.isMovedUsernameView = true
                }
            }
            .store(in: &cancellables)

        // 組み立てたストリームをbinding, outputに反映
        cancellables.formUnion([
            isSigninEnabled.assign(to: \.isEnabledSignInButton, on: output)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
