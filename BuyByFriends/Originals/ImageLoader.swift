//
//  ImageLoader.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/12.
//

import Foundation
import UIKit

class ImageLoader {
    func loadImage(url: URL, completion: @escaping (_ succeeded: Bool, _ image: UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                completion(true, UIImage(data: data))
            }
        }.resume()
    }
}
