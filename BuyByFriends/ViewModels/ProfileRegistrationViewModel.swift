//
//  ProfileRegistrationViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/21.
//

import Foundation
import UIKit
import Combine

final class ProfileRegistrationViewModel: ViewModelObject {
    
    final class Input: InputObject {
        let usernameTapped = PassthroughSubject<Void, Never>()
        let userIDTapped = PassthroughSubject<Void, Never>()
        let passwordTapped = PassthroughSubject<Void, Never>()
        let birthDayTapped = PassthroughSubject<Void, Never>()
        let imagePickerTapped = PassthroughSubject<Void, Never>()
        let selfImagePickerTapped = PassthroughSubject<Void, Never>()
        let profileImageTapped = PassthroughSubject<Void, Never>()
        let inventoryListViewDidLoad = PassthroughSubject<Void, Never>()
        let inventoryListTapped = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var username = ""
        @Published var userID = ""
        @Published var password = ""
        @Published var birthDay = Date()
        @Published var profileImage: UIImage?
        @Published var inventoryList = [Inventory]()
        
        /// 各種ボタン押下完了後遷移フラグ
        @Published var isUsernameViewMoved = false
        @Published var isUserIDViewMoved = false
        @Published var isPasswordViewMoved = false
        @Published var isBirthDayViewMoved = false
        @Published var isImagePickerShown = false
        @Published var isSelfImagePickerShown = false
        @Published var isProfileImageViewMoved = false
        @Published var isInventoryListViewMoved = false
        @Published var isProfileRegistrationFinished = false
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var isUsernameButtonEnabled = false
        @Published fileprivate(set) var isUserIDButtonEnabled = false
        @Published fileprivate(set) var isPasswordButtonEnabled = false
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
        
        ///各種バリデーション（2文字以上10文字以下）
        let isValidUsername = binding.$username
            .map {$0.count <= 10 && $0.count >= 2}
        
        let isValidUserID = binding.$userID
            .map {$0.count <= 10 && $0.count >= 2}
        
        let isValidPassword = binding.$password
            .map {$0.count <= 10 && $0.count >= 2}
        
        ///各種ボタン有効フラグ
        let isUsernameButtonEnabled = isValidUsername.map {$0}
        let isUserIDButtonEnabled = isValidUserID.map {$0}
        let isPasswordButtonEnabled = isValidPassword.map {$0}
        
        ///各種ボタン押下後の処理
        let isUsernameViewMoved = input.usernameTapped
            .flatMap {
                Just(true)
            }
        let isUserIDViewMoved = input.userIDTapped
            .flatMap {
                Just(true)
            }
        let isPasswordViewMoved = input.passwordTapped
            .flatMap {
                Just(true)
            }
        let isBirthDayViewMoved = input.birthDayTapped
            .flatMap {
                Just(true)
            }
        let isImagePickerShown = input.imagePickerTapped
            .flatMap {
                Just(true)
            }
        let isSelfImagePickerShown = input.selfImagePickerTapped
            .flatMap {
                Just(true)
            }
        let isProfileImageViewMoved = input.profileImageTapped
            .flatMap {
                Just(true)
            }
        
        ///持ち物リスト取得の処理
        input.inventoryListViewDidLoad
            .flatMap {
                authProvider.fetchInventoryList()
                    .catch { error -> Just<[Inventory]> in
                        print("Error:", error.localizedDescription)
                        return .init([Inventory(dic: ["id": 0, "name": "", "selected": false, "sequence": 0])])
                    }
            }
            .sink { result in
                binding.inventoryList = result
                print(binding.inventoryList)
            }
            .store(in: &cancellables)
        
        // 組み立てたストリームをoutputに反映
        cancellables.formUnion([
            isUsernameViewMoved.assign(to: \.isUsernameViewMoved, on: binding),
            isUserIDViewMoved.assign(to: \.isUserIDViewMoved, on: binding),
            isPasswordViewMoved.assign(to: \.isPasswordViewMoved, on: binding),
            isBirthDayViewMoved.assign(to: \.isBirthDayViewMoved, on: binding),
            isImagePickerShown.assign(to: \.isImagePickerShown, on: binding),
            isSelfImagePickerShown.assign(to: \.isSelfImagePickerShown, on: binding),
            isProfileImageViewMoved.assign(to: \.isProfileImageViewMoved, on: binding),
            isUsernameButtonEnabled.assign(to: \.isUsernameButtonEnabled, on: output),
            isUserIDButtonEnabled.assign(to: \.isUserIDButtonEnabled, on: output),
            isPasswordButtonEnabled.assign(to: \.isPasswordButtonEnabled, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
