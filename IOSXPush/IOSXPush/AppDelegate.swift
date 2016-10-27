//
//  AppDelegate.swift
//  IOSXPush
//
//  Created by zlqhjs on 16/10/13.
//  Copyright © 2016年 siyuan. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var _asd = "";
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.registerForRemoteNotifications()
        self.registeNotification(application: application)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func registeNotification(application: UIApplication) {
        let systemVersion = UIDevice.current.systemVersion
        print(systemVersion)
        let flag = systemVersion.localizedStandardCompare("10") == ComparisonResult.orderedAscending
        if flag {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        } else {
            let unCenter = UNUserNotificationCenter.current()
            unCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if granted {
                    print("注册成功")
                    unCenter.getNotificationSettings(completionHandler: { (settings) in
                        print(settings)
                    })
                } else {
                    print("注册失败")
                }
            })
            self.categarySetting(center: unCenter)
        }
    }
    
    
    func categarySetting(center: UNUserNotificationCenter) {
        let action1 = UNNotificationAction(identifier: "action1", title: "策略1行为1", options: .authenticationRequired)
        let action2 = UNTextInputNotificationAction(identifier: "action2", title: "策略1行为2", options: .destructive, textInputButtonTitle: "COMMNET", textInputPlaceholder: "reply")
        let action7 = UNTextInputNotificationAction(identifier: "action7", title: "enhance", options: .foreground, textInputButtonTitle: "展示界面", textInputPlaceholder: "🙄")
        let category1 = UNNotificationCategory(identifier: "category1", actions: [action2, action1, action7], intentIdentifiers: ["action2C", "action1C", "action7C"], options: .customDismissAction)
        let action3 = UNNotificationAction(identifier: "action3", title: "策略2行为1", options: .foreground)
        let action4 = UNNotificationAction(identifier: "action4", title: "策略2行为2", options: .foreground)
        let category2 = UNNotificationCategory(identifier: "category2", actions: [action3, action4], intentIdentifiers: ["action3C", "action4C"], options: .customDismissAction)
        center.setNotificationCategories([category1, category2])
        
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        UIApplication.shared.applicationIconBadgeNumber = 0

    }
    
    func presentBvc() {
        let bvc = BViewController()
        if UIApplication.shared.keyWindow?.rootViewController != nil {
            UIApplication.shared.keyWindow?.rootViewController?.present(bvc, animated: true, completion: nil)
        } else {
            print("meiyou")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("ap--foreground_________foreground")
        print(notification)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        print("ap--back_________back")
        print(response)
        if response.notification.request.content.categoryIdentifier == "category1" {
            let response2 = response as? UNTextInputNotificationResponse
            if (response2 != nil) {
                let userReply = response2?.userText
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TEST_NAME"), object: self, userInfo: ["reply": userReply, "atta": "hehe"])
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
    }
}

