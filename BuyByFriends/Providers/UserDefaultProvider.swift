//
//  UserDefaultProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/26.
//

import Foundation
import Combine

struct UserDefaultProvider: UserDefaultProviderObject {
    private let userdefault = UserDefaults()

    func saveAdress(adress: Adress) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let adressArray = [
                    "postNumber": adress.postNumber,
                    "prefecture": adress.prefecture,
                    "city": adress.city,
                    "number": adress.number,
                    "buildingName": adress.buildingName,
                    "kanjiName": adress.kanjiName,
                    "kanaName": adress.kanaName,
                    "phoneNumber": adress.phoneNumber,
                    "email": adress.email
            ]
            UserDefaults.standard.adress = adressArray
            promise(.success(()))
        }.eraseToAnyPublisher()
    }

    func getAdress() -> AnyPublisher<Adress, Error> {
        return Future<Adress, Error> { promise in
            let adressArray = UserDefaults.standard.adress
            let adress = Adress(dic: adressArray)
            if adress.postNumber != "" {
                promise(.success(adress))
            } else {
                print("check: adress = null")
            }
        }.eraseToAnyPublisher()
    }
}

extension UserDefaults {
    var adress: [String: Any] {
        get {
            guard let areas = object(forKey: "Adress") as? [String: Any] else { return [:] }
            return areas
        }
        set {
            set(newValue, forKey: "Adress")
        }
    }
}
