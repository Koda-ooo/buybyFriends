//
//  ProfileImageViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/25.
//

import Foundation
import UIKit
import Combine

final class ProfileImageViewModel: ViewModelObject {
    final class Input: InputObject {
        let imagePickerTapped = PassthroughSubject<Void, Never>()
        let selfImagePickerTapped = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var profileImage = UIImage(named: "noimage")
        @Published var isShownImagePicker: Bool = false
        @Published var isShownSelfImagePickerShown: Bool = false
    }

    final class Output: OutputObject {
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

        /// ボタン押下後の処理
        let isImagePickerShown = input.imagePickerTapped
            .flatMap {
                Just(true)
            }
        let isSelfImagePickerShown = input.selfImagePickerTapped
            .flatMap {
                Just(true)
            }

        // 組み立てたストリームを反映
        cancellables.formUnion([
            isImagePickerShown.assign(to: \.isShownImagePicker, on: binding),
            isSelfImagePickerShown.assign(to: \.isShownSelfImagePickerShown, on: binding)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
