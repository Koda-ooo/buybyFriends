//
//  UserDefaultProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/26.
//

import Foundation
import Combine

protocol UserDefaultProviderObject {
    func saveAdress(adress: Adress) -> AnyPublisher<Void, Error>
    func getAdress() -> AnyPublisher<Adress, Error>
}
