//
//  UIImage+getImageByUrl.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/11.
//

import Foundation
import SwiftUI

//extension UIImage {
//    public convenience init(url: String, completionHandler: @escaping (UIImage?) -> Void) {
//        guard let url = URL(string: url) else {
//            completionHandler(nil)
//            self.init()
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completionHandler(nil)
//                return
//            }
//
//            if let image = UIImage(data: data) {
//                completionHandler(image)
//            } else {
//                completionHandler(nil)
//            }
//        }.resume()
//        self.init()
//    }
//}
