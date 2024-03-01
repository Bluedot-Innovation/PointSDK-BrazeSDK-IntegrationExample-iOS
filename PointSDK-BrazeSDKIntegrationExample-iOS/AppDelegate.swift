//
//  AppDelegate.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 22/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import UIKit
import UserNotifications
import BDPointSDK
import BrazeKitCompat
import BrazeUICompat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var braze: Braze? = nil

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initiates BDLocationManager
        BDLocationManager.instance()?.geoTriggeringEventDelegate = self
        
        let configuration = Braze.Configuration(
            apiKey: "YOUR-APP-IDENTIFIER-API-KEY", // Braze Portal -> Manage Settings -> Settings Tab -> Your App -> API Key
            endpoint: "YOUR-BRAZE-ENDPOINT" // Braze Portal -> Manage Settings -> Settings Tab -> Your App -> SDK Endpoint
        )
        configuration.push.automation = true
        
        let braze = Braze(configuration: configuration)
        
        // Assign UserID to track the user in Braze platform
        braze.changeUser(userId: "bluedot_sdk_and_brazer_sdk_integration_iOS")
        AppDelegate.braze = braze
                
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories(Braze.Notifications.categories)
        center.delegate = self
        
        var options: UNAuthorizationOptions = [.alert, .sound]
        if #available(iOS 12.0, *) {
          options = UNAuthorizationOptions(rawValue: options.rawValue | UNAuthorizationOptions.provisional.rawValue)
        }
        center.requestAuthorization(options: options) { granted, error in
          print("Notification authorization, granted: \(granted), error: \(String(describing: error))")
        }

        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        
        // Register Push Token with Braze
        AppDelegate.braze?.notifications.register(deviceToken: deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Enable Push Notifications Handling
        if let braze = AppDelegate.braze, braze.notifications.handleBackgroundNotification(
          userInfo: userInfo,
          fetchCompletionHandler: completionHandler
        ) {
          return
        }
        completionHandler(.noData)
    }
    
// MARK: - UNUserNotificationCenterDelegate callbacks
    
    // Background notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
        ) {
        
            if let braze = AppDelegate.braze, braze.notifications.handleUserNotification(
                response: response, withCompletionHandler: completionHandler
            ) {
              return
            }
            completionHandler()
    }
    
    // Allow foreground notifications
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner])
          } else {
            completionHandler([.alert])
          }
    }
}
