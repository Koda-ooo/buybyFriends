//
//  Withdraw.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/03.
//

import Foundation

struct Withdraw: Identifiable, Hashable {
    var id: Int
    var bankName: String
    var bankAccountType: String
    var branchCode: String
    var bankAccountNumber: String
    var firstName: String
    var lastName: String
    var amountOfMoney: Int

    init(dic: [String: Any]) {
        self.id = dic["id"] as? Int ?? 0
        self.bankName = dic["bankName"] as? String ?? ""
        self.bankAccountType = dic["bankAccountType"] as? String ?? ""
        self.branchCode = dic["branchCode"] as? String ?? ""
        self.bankAccountNumber = dic["bankAccountNumber"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.amountOfMoney = dic["amountOfMoney"] as? Int ?? 0
    }
}
