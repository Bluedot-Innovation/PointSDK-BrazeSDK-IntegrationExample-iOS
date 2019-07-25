//
//  AppDelegate+LocationDelegate.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 23/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK
import Appboy_iOS_SDK

extension AppDelegate: BDPLocationDelegate {
    func didUpdateZoneInfo(_ zoneInfos: Set<AnyHashable>!) {
        print("Zone information has been recieved")
    }
    
    func didCheck(
        intoFence fence: BDFenceInfo!,
        inZone zoneInfo: BDZoneInfo!,
        atLocation location: BDLocationInfo!,
        willCheckOut: Bool,
        withCustomData customData: [AnyHashable : Any]!
    ) {
        
        // Name the custom event
        let customEventName = "bluedot_entry"
        
        // Map the Location and Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(zoneInfo.id!)",
            "zone_name": "\(zoneInfo.name!)",
            "latitude": "\(location.latitude)",
            "longitude": "\(location.longitude)",
            "speed": "\(location.speed)",
            "bearing": "\(location.bearing)",
            "timestamp": "\(location.timestamp!)",
        ]
        
        // Map the Custom Data attributes into properties
        if customData != nil && !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        // Log the Custom Event in Appboy
        Appboy.sharedInstance()?.logCustomEvent(customEventName, withProperties: properties );
        
        let message = "You have checked into fence \(fence.name!) in zone \(zoneInfo.name!)"
        let viewController = self.window?.rootViewController as! ViewController
        viewController.showAlert(title: "Check In", message: message)
    }
    
    func didCheckOut(
        fromFence fence: BDFenceInfo!,
        inZone zoneInfo: BDZoneInfo!,
        on date: Date!,
        withDuration checkedInDuration: UInt,
        withCustomData customData: [AnyHashable : Any]!
    ) {
        
        // Name the custom event
        let customEventName = "bluedot_exit"
        
        // Map the Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(zoneInfo.id!)",
            "zone_name": "\(zoneInfo.name!)",
            "timestamp": "\(date!)",
            "checkedInDuration": "\(checkedInDuration)"
        ]
        
        // Map the Custom Data attributes into properties
        if customData != nil && !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        Appboy.sharedInstance()?.logCustomEvent(customEventName, withProperties: properties);
      
        let message = "You have left fence \(fence.name!) in zone \(zoneInfo.name!)"
        let viewController = self.window?.rootViewController as! ViewController
        viewController.showAlert(title: "Check Out", message: message)
    }
}
