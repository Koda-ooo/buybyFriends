//
//  PaymentConfig.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/16.
//

import Foundation

class PaymentConfig {
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfig = PaymentConfig()
    private init() { }
}
