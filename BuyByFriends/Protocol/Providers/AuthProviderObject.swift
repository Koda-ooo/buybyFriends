//
//  AuthProviderObject.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthProviderObject {
    func observeAuthChange() -> AnyPublisher<User?, Never>
    func signUpByPhoneNumber(phoneNumber: String) -> AnyPublisher<Bool, Error>
    func signInByPhoneNumber(verificationCode: String) -> AnyPublisher<String,Error>
    func signOut() -> AnyPublisher<Bool, Error>
}
