//
//  MyPageInventoryListViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/09/03.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class MyPageInventoryListViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToFetchInventory = PassthroughSubject<Void, Never>()
        let startToUpdateMyInventories = PassthroughSubject<Void, Never>()
        let startToRequestInventory = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var isMyPage: Bool = false
        @Published var userInfo: UserInfo = UserInfo(dic: [:])
        @Published var userInventories: [Inventory] = []
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var inventories: [Inventory] = []
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let userInfoProvider: UserInfoProviderObject
    private let inventoryListProvider: InventoryListProviderObject

    init(
        userInfoProvider: UserInfoProviderObject = UserInfoProvider(),
        inventoryListProvider: InventoryListProviderObject = InventoryListProvider()
    ) {
        self.userInfoProvider = userInfoProvider
        self.inventoryListProvider = inventoryListProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        input.startToFetchInventory
            .flatMap {
                inventoryListProvider.fetchInventoryList()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in

                var inventories = result

                for inventory in binding.userInfo.inventoryList {
                    for (index, var dict) in inventories.enumerated() {
                        if dict.name == inventory {
                            dict.selected = true
                            inventories[index] = dict
                        }
                    }
                }

                binding.userInventories = inventories
            }
            .store(in: &cancellables)

        input.startToUpdateMyInventories
            .flatMap {
                userInfoProvider.updateInventory(inventory: binding.userInventories)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) {}
            .store(in: &cancellables)

        self.input = input
        self.binding = binding
        self.output = output
    }
}
