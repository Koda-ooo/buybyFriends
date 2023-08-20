//
//  PurchaseViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/15.
//

import Foundation
import Combine
import Stripe
import StripePaymentSheet

final class PurchaseViewModel: ViewModelObject {
    final class Input: InputObject {
        let startToCreatePaymentIntent = PassthroughSubject<Post, Never>()
        let startToUpdatePost = PassthroughSubject<(postID:String, buyerID: String), Never>()
        let startToCreateDelivery = PassthroughSubject<Post, Never>()
        let showPaymentSheet = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var adress: Adress = Adress(dic: [:])
        @Published var paymentMethodParams: STPPaymentMethodParams?
        @Published var paymentSheet = PaymentSheet(paymentIntentClientSecret: "", configuration: PaymentSheet.Configuration())
        
        // 遷移系
        @Published var isMovedInsertAdressView = false
        @Published var isMovedInsertPersonalInfo = false
        @Published var isMovedFinishPurchaseView = false
        @Published var isPresentedPaymentSheet = false
    }
    
    final class Output: OutputObject {
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let purchaseProvider: PurchaseProviderProtocol
    private let deliveryProvider: DeliveryProviderObject
    
    
    init(
        purchaseProvider: PurchaseProviderProtocol = PurchaseProvider(),
        deliveryProvider: DeliveryProviderObject = DeliveryProvider()
    ) {
        self.purchaseProvider = purchaseProvider
        self.deliveryProvider = deliveryProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        /// PaymentIntent作成
        input.startToCreatePaymentIntent
            .flatMap { post in
                purchaseProvider.createPaymentIntent(post: post)
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                var config = PaymentSheet.Configuration()
                config.defaultBillingDetails.address.country = "JP"
                binding.paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: result,
                    configuration: config
                )
                binding.isPresentedPaymentSheet = true
            }
            .store(in: &cancellables)
        
        ///購入済みに更新
        input.startToUpdatePost
            .flatMap { (postID, buyerID) in
                purchaseProvider.updatePost(postID: postID, buyerID: buyerID)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                binding.isMovedFinishPurchaseView = result
            }
            .store(in: &cancellables)
        
        ///配送タスクの作成
        input.startToCreateDelivery
            .flatMap { post in
                deliveryProvider.createDelivery(post: post, adress: binding.adress)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { _ in
                print("FINISH")
            }
            .store(in: &cancellables)
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}
