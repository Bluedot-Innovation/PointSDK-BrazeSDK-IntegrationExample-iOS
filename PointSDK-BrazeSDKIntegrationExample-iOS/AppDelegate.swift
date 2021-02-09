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
import Appboy_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let brazeApiKey = "YourBrazeAPIKey"


    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initiates BDLocationManager
        BDLocationManager.instance()?.geoTriggeringEventDelegate = self
        
        
        // Initiates connection with Braze
        Appboy.start(withApiKey: brazeApiKey, in: application, withLaunchOptions: launchOptions)
        
        // Assign UserID to track the user in Braze platform
        Appboy.sharedInstance()?.changeUser("bluedot_sdk_and_brazer_sdk_integration_iOS")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification access denied. \(String(describing: error?.localizedDescription))")
            }
            
        }
        
        return true
    }
    
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        
        // Register Push Token with Braze
        Appboy.sharedInstance()?.registerDeviceToken(deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to regster: \(error)")
    }
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Enable Push Notifications Handling
        Appboy.sharedInstance()?.register(application,
                                          didReceiveRemoteNotification: userInfo,
                                          fetchCompletionHandler: completionHandler)
    }
    
    // Background notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
        ) {
        
        Appboy.sharedInstance()?.userNotificationCenter(center,
                                                        didReceive: response,
                                                        withCompletionHandler: completionHandler)
    }
    
    
    // Allow foreground notifications
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
        
        completionHandler([.alert, .badge, .sound])
    }
}

