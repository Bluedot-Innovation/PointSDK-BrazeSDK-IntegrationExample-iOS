# Braze Custom Event Example

A sample project used to test the integration between Braze Appboy SDK and Bluedot Point SDK.
## Getting Started

This project depends on `BluedotPointSDK` and `Appboy-iOS-SDK`. Both dependencies ban be managed by [CocoaPods](https://cocoapods.org/). Please refer to the `Podfile` in the repository.

### Implement `BluedotPointSDK`

1. import `BDPointSDK` to your class:

```swift
import BDPointSDK
```

2. Implement Bluedot BDPGeoTriggeringEventDelegate:

```swift
extension YourClass: BDPGeoTriggeringEventDelegate {

    func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
        // Your logic when the device enters a Bluedot Zone
    }

     func didExitZone(_ exitEvent: BDZoneExitEvent) {
        // Your logic when the device leaves a Bluedot Zone
     }
}
```

3. Assign GeoTriggeringEvent delegate with your implementation

```swift
let instanceOfYourClass = YourClass()
BDLocationManager.instance()?.geoTriggeringEventDelegate = instanceOfYourClass
```

4. Authenticate with the Bluedot services

```swift
BDLocationManager.instance()?.initialize(withProjectId: projectId){ error in
     guard error == nil else {
        print("There was an error initializing the Bluedot SDK: \(error.localizedDescription)")
        return
     }
}
```

### Implement `Braze Appboy SDK`

1. Import `Appboy-iOS-SDK` to your class

```swift
import Appboy_iOS_SDK
```

2. Start `Appboy-iOS-SDK` within the `application:didFinishLaunchingWithOptions` method. 
For further information refer to [Braze Developer Documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/initial_sdk_setup/)

```swift
Appboy.start(withApiKey: "Your assigned Braze API Key", in: application, withLaunchOptions: launchOptions)
```

3. Track `Braze` custom events in your Bluedot Entry / Exit events.

```swift
func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
    // Name the custom event 
    let customEventName = "bluedot_entry"

    // Map the Location and Bluedot Zone attributes into a properties dictionary

    var properties = [
        "zone_id": "\(enterEvent.zone().id!)",
        "zone_name": "\(enterEvent.zone().name!)",
        "latitude": "\(enterEvent.location.latitude)",
        "longitude": "\(enterEvent.location.longitude)",
        "speed": "\(enterEvent.location.speed)",
        "bearing": "\(enterEvent.location.bearing)",
        "timestamp": "\(enterEvent.location.timestamp!)"
    ]

    // Map the Custom Data attributes into properties

    if let customData = enterEvent.zone().customData, !customData.isEmpty {
        customData.forEach { data in properties["\(data.key)"] = "\(data.value)"}
    }

    // Log the Custom Event in Appboy
    Appboy.sharedInstance()?.logCustomEvent(customEventName, withProperties: properties )
}

func didCheckOut(_ exitEvent: BDZoneExitEvent) {
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

    // Log the Custom Event in Appboy
    Appboy.sharedInstance()?.logCustomEvent(customEventName, withProperties: properties );
}
```

## Next steps
Full documentation can be found at https://docs.bluedot.io/ios-sdk/ and https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/initial_sdk_setup/ respectively.
