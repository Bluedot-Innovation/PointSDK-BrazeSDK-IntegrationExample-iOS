//
//  AppDelegate+LocationDelegate.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 23/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK
import BrazeKit

extension AppDelegate: BDPGeoTriggeringEventDelegate {
        
    func didUpdateZoneInfo() {
        print("Zone information has been received")
    }
    
    func didEnterZone(_ triggerEvent: GeoTriggerEvent) {
        
        print("Entered Zone: \(String(describing: triggerEvent.zoneInfo.name))")
        
        // Name the custom event
        let customEventName = "bluedot_entry"
                
        // Map the Location and Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(triggerEvent.zoneInfo.id)",
            "zone_name": "\(triggerEvent.zoneInfo.name)",
            "latitude": "\(triggerEvent.entryEvent?.locations[0].coordinate.latitude ?? 0.0)",
            "longitude": "\(triggerEvent.entryEvent?.locations[0].coordinate.longitude ?? 0.0)",
            "speed": "\(triggerEvent.entryEvent?.locations[0].speed ?? 0.0)",
            "bearing": "\(triggerEvent.entryEvent?.locations[0].course ?? 0.0)",
            "timestamp": "\(triggerEvent.entryEvent?.eventTime.timeIntervalSince1970 ?? 0.0)",
        ]
        
        // Map the Custom Data attributes into properties
        let customData = triggerEvent.zoneInfo.customData
        if !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        // Log the Custom Event in Appboy
        AppDelegate.braze?.logCustomEvent(name: customEventName, properties: properties)
    }
    
    func didExitZone(_ triggerEvent: GeoTriggerEvent) {

        print("Exited Zone: \(String(describing: triggerEvent.zoneInfo.name))")
        
        // Name the custom event
        let customEventName = "bluedot_exit"
        
        // Map the Zone attributes into a properties dictionary
        var properties = [
            "zone_id": "\(triggerEvent.zoneInfo.id)",
            "zone_name": "\(triggerEvent.zoneInfo.name)",
            "timestamp": "\(triggerEvent.exitEvent?.eventTime.timeIntervalSince1970 ?? 0.0)",
            "checkedInDuration": "\(triggerEvent.exitEvent?.dwellTime ?? 0.0)"
        ]
        
        // Map the Custom Data attributes into properties
        let customData = triggerEvent.zoneInfo.customData
        if !customData.isEmpty {
            customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
        }
        
        AppDelegate.braze?.logCustomEvent(name: customEventName, properties: properties)
    }
}
