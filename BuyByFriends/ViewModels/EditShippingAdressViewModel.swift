////
////  EditShippingAdressViewModel.swift
////  BuyByFriends
////
////  Created by 鈴木登也 on 2023/07/12.
////
//
// import Foundation
// import Combine
//
// final class EditShippingAdressViewModel: ViewModelObject {
//    final class Input: InputObject {
//    }
//    
//    final class Binding: BindingObject {
//        @Published var postNumber: String = ""
//        @Published var prefecture: String = ""
//        @Published var city: String = ""
//        @Published var number: String = ""
//        @Published var building: String = ""
//        
//        @Published var isEnableNextButton: Bool = false
//    }
//    
//    final class Output: OutputObject {
//    }
//    
//    let input: Input
//    @BindableObject private(set) var binding: Binding
//    let output: Output
//    private var cancellables = Set<AnyCancellable>()
//    @Published private var isBusy: Bool = false
//    private let purchaseProvider: PurchaseProviderProtocol
//    
//    
//    init() {
//        let input = Input()
//        let binding = Binding()
//        let output = Output()
//        
//        /// 住所入力画面へ遷移
////        let isValidNextButton =
////            .flatMap {
////                Just(true)
////            }
//        
//        /// 組み立てたストリームを反映
//        cancellables.formUnion([
////            isMovedInsertAdressView.assign(to: \.isMovedInsertAdressView, on: binding)
//        ])
////
//        self.input = input
//        self.binding = binding
//        self.output = output
//    }
// }
