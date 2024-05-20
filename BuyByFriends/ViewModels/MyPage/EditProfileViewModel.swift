//
//  EditProfileViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import Foundation
import Combine
import FirebaseFirestore

final class EditProfileViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToSaveProfile = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var profileImageURL: String = ""
        @Published var name: String = ""
        @Published var username: String = ""
        @Published var selfIntroduction: String = ""
        @Published var instagramID: String = ""
        @Published var isInitial = true
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var profileImageData: Data = Data()
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let userInfoProvider: UserInfoProviderObject

    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider()
    ) {
        self.userInfoProvider = userInfoProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// 組み立てたストリームを反映
        cancellables.formUnion([
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
