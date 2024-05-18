//
//  LogIn_VerificationCodeViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/06/17.
//

import SwiftUI

import Foundation
import Combine

final class LogIn_VerificationCodeViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToStartBuyByFriend = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var verificationCode: String = ""
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isEnabledStartBuyByFriendButton = false
        @Published fileprivate(set) var isStartedBuyByFriend = false
        @Published fileprivate(set) var userInfo = UserInfo(dic: [:])
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    private let authProvider: AuthProviderObject
    private let userInfoProvider: UserInfoProviderObject

    init(authProvider: AuthProviderObject = AuthProvider(), userInfoProvider: UserInfoProviderObject = UserInfoProvider()) {
        self.authProvider = authProvider
        self.userInfoProvider = userInfoProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// 認証コードのバリデーション（6文字）
        let isValid = binding.$verificationCode
            .map {$0.count == 6}

        /// 「StartBuyByFriend」ボタン有効フラグ
        let isEnabledStartBuyByFriendButton = isValid.map {$0}

        /// ログイン
        input.startToStartBuyByFriend
            .flatMap {
                authProvider.signInByPhoneNumber(verificationCode: binding.verificationCode)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }) { _ in
                output.isStartedBuyByFriend = true
            }
            .store(in: &cancellables)

        // 組み立てたストリームを反映
        cancellables.formUnion([
            isEnabledStartBuyByFriendButton.assign(to: \.isEnabledStartBuyByFriendButton, on: output)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
