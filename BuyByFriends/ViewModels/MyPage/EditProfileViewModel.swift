//
//  EditProfileViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

final class EditProfileViewModel: ViewModelObject {
    final class Input: InputObject {
        let updateName = PassthroughSubject<String, Never>()
        let updateUsername = PassthroughSubject<String, Never>()
        let updateInstagramID = PassthroughSubject<String, Never>()
        let updateSelfIntroduction = PassthroughSubject<String, Never>()
    }

    final class Binding: BindingObject {
        @Published var profileImageURL: String = ""
        @Published var name: String = ""
        @Published var username: String = ""
        @Published var selfIntroduction: String = ""
        @Published var instagramID: String = ""
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isProfileUpdated: Bool = false
    }

    let input: Input
    @BindableObject var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    private let userInfoProvider: UserInfoProviderObject
    private var currentUserInfo: UserInfo?

    init(userInfoProvider: UserInfoProviderObject = UserInfoProvider()) {
        self.userInfoProvider = userInfoProvider
        self.input = Input()
        self.binding = Binding()
        self.output = Output()

        setupBindings()
        fetchCurrentUserInfo()
    }

    private func setupBindings() {
        input.updateName
            .assign(to: \.name, on: binding)
            .store(in: &cancellables)

        input.updateUsername
            .assign(to: \.username, on: binding)
            .store(in: &cancellables)

        input.updateInstagramID
            .assign(to: \.instagramID, on: binding)
            .store(in: &cancellables)

        input.updateSelfIntroduction
            .assign(to: \.selfIntroduction, on: binding)
            .store(in: &cancellables)

        // プロパティの変更を監視し、プロフィールを更新
        binding.$name.dropFirst().sink { [weak self] _ in self?.updateProfile() }.store(in: &cancellables)
        binding.$username.dropFirst().sink { [weak self] _ in self?.updateProfile() }.store(in: &cancellables)
        binding.$instagramID.dropFirst().sink { [weak self] _ in self?.updateProfile() }.store(in: &cancellables)
        binding.$selfIntroduction.dropFirst().sink { [weak self] _ in self?.updateProfile() }.store(in: &cancellables)
    }

    private func fetchCurrentUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userInfoProvider.fetchUserInfo(id: uid)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("ユーザー情報の取得に失敗しました: \(error)")
                }
            }, receiveValue: { [weak self] userInfo in
                self?.currentUserInfo = userInfo
                self?.binding.name = userInfo.name
                self?.binding.username = userInfo.userID
                self?.binding.selfIntroduction = userInfo.selfIntroduction
                self?.binding.instagramID = userInfo.instagramID
                self?.binding.profileImageURL = userInfo.profileImage ?? ""
            })
            .store(in: &cancellables)
    }

    private func updateProfile() {
        guard var updatedUserInfo = currentUserInfo else { return }

        updatedUserInfo.name = binding.name
        updatedUserInfo.userID = binding.username
        updatedUserInfo.selfIntroduction = binding.selfIntroduction
        updatedUserInfo.instagramID = binding.instagramID

        userInfoProvider.updateUserInfo(userInfo: updatedUserInfo)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.output.isProfileUpdated = true
                case .failure(let error):
                    print("プロフィールの更新に失敗しました: \(error)")
                }
            }, receiveValue: { _ in
                print("プロフィールが正常に更新されました")
            })
            .store(in: &cancellables)
    }
}
