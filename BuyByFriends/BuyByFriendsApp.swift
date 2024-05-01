//
//  BuyByFriendsApp.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import Stripe

@main
struct BuyByFriendsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        StripeAPI.defaultPublishableKey = "pk_test_51N7x3JDmfaCGD9zyiavHcj9v6qBHDkIESJUp2QlisswmzBpqPc3pFXtpgCpCPvdnWJCZyOg7g4puXpWhnC8OtGLg00SV0GlcHs"
    }
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(AppState())
                .environmentObject(Path())
                .environmentObject(HideTabBar())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Push通知許可のポップアップを表示
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // アプリ起動時にFCM Tokenを取得、その後UserInfosにTokenを保存
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken = fcmToken else { return }
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        
        if let uid = Auth.auth().currentUser?.uid {
            setFcmToken(uid: uid, fcmToken: fcmToken)
        }
    }
    
    func setFcmToken(uid: String, fcmToken: String) {
        let value = ["fcmToken": fcmToken]
        let doc = Firestore.firestore().collection("UserInfos").document(uid)
        doc.updateData(value)
    }
}


// MARK: - AppDelegate Push Notification
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // アプリがForeground時にPush通知を受信する処理
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .badge, .sound]])
    }
    
    //  Push通知がタップされた時の処理
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
}
