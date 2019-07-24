//
//  AppDelegate.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 22/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import UIKit
import BDPointSDK
import Appboy_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let brazeApiKey = "d85d9a4d-2434-44ca-aa0d-259a6b8f7d72"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BDLocationManager.instance()?.locationDelegate = self
        
        Appboy.start(withApiKey: brazeApiKey, in: application, withLaunchOptions: launchOptions)
   
        return true
    }

}

