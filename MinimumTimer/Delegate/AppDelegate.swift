//
//  AppDelegate.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // MARK: 通知の許可をリクエストする
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
            print("許可されたか: \(granted)")
        }
        // MARK: UNUserNotificationCenterDelegateを指定する
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: UNUserNotificationDelegateを実装する
    // フォアグラウンドで通知を受け取った際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(
            [
                UNNotificationPresentationOptions.banner,
                UNNotificationPresentationOptions.list,
                UNNotificationPresentationOptions.sound,
                UNNotificationPresentationOptions.badge
            ]
        )
    }
    
    // バックグランドで通知を受け取った際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

