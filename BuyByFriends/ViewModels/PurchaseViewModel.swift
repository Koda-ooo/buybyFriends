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
        let startToCreatePaymentIntent = PassthroughSubject<Void, Never>()
        let startToUpdatePost = PassthroughSubject<Void, Never>()
        let startToCreateDelivery = PassthroughSubject<Void, Never>()
        let startToGetAdress = PassthroughSubject<Void, Never>()
        let startToSaveAdress = PassthroughSubject<Void, Never>()
        let showPaymentSheet = PassthroughSubject<Void, Never>()
    }

    final class Binding: BindingObject {
        @Published var post: Post = Post(dic: [:])
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
        @Published fileprivate(set) var isEnableNextButton: Bool = false
        @Published fileprivate(set) var isEnableRegisterButton: Bool = false
        @Published fileprivate(set) var isEnablePurchaseButton: Bool = false
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false

    private let purchaseProvider: PurchaseProviderProtocol
    private let deliveryProvider: DeliveryProviderObject
    private let userdefaultProvider: UserDefaultProviderObject

    init(
        purchaseProvider: PurchaseProviderProtocol = PurchaseProvider(),
        deliveryProvider: DeliveryProviderObject = DeliveryProvider(),
        userdefaultProvider: UserDefaultProviderObject = UserDefaultProvider()
    ) {
        self.purchaseProvider = purchaseProvider
        self.deliveryProvider = deliveryProvider
        self.userdefaultProvider = userdefaultProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        /// お届け先情報のバリデーション
        let isValidAdress = binding.$adress
            .map {
                $0.postNumber.count == 7 &&
                $0.prefecture.count >= 3 &&
                $0.city.count >= 1 &&
                $0.number.count >= 1
            }

        // 個人情報のバリデーション
        let isValidPersonalInfo = binding.$adress
            .map {
                $0.kanjiName.count >= 1 &&
                $0.kanaName.count >= 1 &&
                $0.phoneNumber.count >= 10 &&
                $0.email.count >= 5
            }

        // 決済のバリデーション
        let isValidPurchase = binding.$adress
            .map {
                $0.postNumber.count == 7 &&
                $0.prefecture.count >= 3 &&
                $0.city.count >= 1 &&
                $0.number.count >= 1 &&
                $0.kanjiName.count >= 1 &&
                $0.kanaName.count >= 1 &&
                $0.phoneNumber.count >= 10 &&
                $0.email.count >= 5
            }

        /// ボタン有効フラグ
        let enableNextButton = isValidAdress.map {$0}
        let enableRegisterButton = isValidPersonalInfo.map {$0}
        let enablePurchaseButton = isValidPurchase.map {$0}

        /// PaymentIntent作成
        input.startToCreatePaymentIntent
            .flatMap { _ in
                purchaseProvider.createPaymentIntent(post: binding.post)
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

        /// 購入済みに更新
        input.startToUpdatePost
            .flatMap {
                purchaseProvider.updatePost(postID: binding.post.id)
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

        /// 配送タスクの作成
        input.startToCreateDelivery
            .flatMap { _ in
                deliveryProvider.createDelivery(post: binding.post, adress: binding.adress)
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

        /// 配送先をUserDefaultから取得
        input.startToGetAdress
            .flatMap {
                userdefaultProvider.getAdress()
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { adress in
                binding.adress = adress
            }
            .store(in: &cancellables)

        /// 配送先をUserDefaultに保存
        input.startToSaveAdress
            .flatMap {
                userdefaultProvider.saveAdress(adress: binding.adress)
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

        // 組み立てたストリームをoutputに反映
        cancellables.formUnion([
            enableNextButton.assign(to: \.isEnableNextButton, on: output),
            enableRegisterButton.assign(to: \.isEnableRegisterButton, on: output),
            enablePurchaseButton.assign(to: \.isEnablePurchaseButton, on: output)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }
}
