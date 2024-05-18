//
//  PushNotificationSender.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import Foundation

class PushNotificationSender {
    private let FCM_ServerKey = "AAAAEDCXWB8:APA91bEAQ_0ELYy0YBgAGMZ2qXBeva9OcMdJKgQApWXkRkTBgeenZrR8YjOod8eWtJQg78_ZBnoLwY7w40JIN9qd0QQ1Qk234mZHTpLhbOtx8yryzrGDjiuZpO9eLxY8FwojUJmmlK5V"
    private let endpoint = "https://fcm.googleapis.com/fcm/send"

    func sendPushNotification(to token: String, userId: String, title: String, body: String, completion: @escaping () -> Void) {
        let serverKey = FCM_ServerKey
        guard let url = URL(string: endpoint) else { return }
        let paramString: [String: Any] = ["to": token,
                                          "notification": ["title": title, "body": body],
                                          "data": ["userId": userId]]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                if let jsonData = data {
                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        print("Received data: \(jsonDataDict)")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
        completion()
    }
}
