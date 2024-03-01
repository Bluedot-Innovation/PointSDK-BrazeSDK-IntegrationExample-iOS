//
//  AppDelegate+LocationDelegate.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 23/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK
import BrazeKitCompat

extension AppDelegate: BDPGeoTriggeringEventDelegate {
    
    func onZoneInfoUpdate(_ zoneInfos: Set<BDZoneInfo>) {
        print("Zone information has been recieved")
    }
    
    func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
        
        print("Entered Zone: \(String(describing: enterEvent.zone().name))")
        
        // Name the custom event
        let customEventName = "bluedot_entry"
        
        // Map the Location and Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(enterEvent.zone().id!)",
            "zone_name": "\(enterEvent.zone().name!)",
            "latitude": "\(enterEvent.location.latitude)",
            "longitude": "\(enterEvent.location.longitude)",
            "speed": "\(enterEvent.location.speed)",
            "bearing": "\(enterEvent.location.bearing)",
            "timestamp": "\(enterEvent.location.timestamp!)",
        ]
        
        // Map the Custom Data attributes into properties
        if let customData = enterEvent.zone().customData, !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        // Log the Custom Event in Appboy
        AppDelegate.braze?.logCustomEvent(name:customEventName, properties: properties)
    }
    
    func didExitZone(_ exitEvent: BDZoneExitEvent) {

        print("Exited Zone: \(String(describing: exitEvent.zone().name))")
        
        // Name the custom event
        let customEventName = "bluedot_exit"
        
        // Map the Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(exitEvent.zone().id!)",
            "zone_name": "\(exitEvent.zone().name!)",
            "timestamp": "\(exitEvent.date)",
            "checkedInDuration": "\(exitEvent.duration)"
        ]
        
        // Map the Custom Data attributes into properties
        if let customData = exitEvent.zone().customData, !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        AppDelegate.braze?.logCustomEvent(name:customEventName, properties:properties)
    }
}
