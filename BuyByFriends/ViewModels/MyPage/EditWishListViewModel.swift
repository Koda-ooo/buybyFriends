//
//  EditWishListViewModel.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import Foundation
import Combine
import FirebaseFirestore

final class EditWishListViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToSaveWishList = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var genre: InventoryGenre = .outer
        @Published var text: String = ""
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var isSuccess: Bool = false
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
        
        input.startToSaveWishList
            .flatMap { _ in
                userInfoProvider.saveWishList(genre: binding.genre, text: binding.text)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.isSuccess = result
            }
            .store(in: &cancellables)
        
        /// 組み立てたストリームを反映
        cancellables.formUnion([
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
