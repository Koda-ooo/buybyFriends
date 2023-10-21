//
//  HalfWishListViewModel.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/14.
//

import Foundation
import Combine
import FirebaseFirestore

final class HalfWishListViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToSendMessage = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var userInfo: UserInfo = UserInfo(dic: [:])
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
    private let notificationProvider: NotificationProviderObject
    
    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        notificationProvider: NotificationProviderObject = NotificationProvider()
    ) {
        self.userInfoProvider = userInfoProvider
        self.notificationProvider = notificationProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
//        input.startToSaveWishList
//            .flatMap { _ in
//                userInfoProvider.saveWishList(genre: binding.genre, text: binding.text)
//            }
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let err):
//                    print(err.localizedDescription)
//                case .finished:
//                    print("finished")
//                }
//            }) { result in
//                output.isSuccess = result
//            }
//            .store(in: &cancellables)
        
        /// 組み立てたストリームを反映
        cancellables.formUnion([
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
