# Braze Custom Event Example

A sample project used to test the integration between Braze Appboy SDK and Bluedot Point SDK.
## Getting Started

This project depends on `BluedotPointSDK` and `Appboy-iOS-SDK`. Both dependencies ban be managed by [CocoaPods](https://cocoapods.org/). Please refer to the `Podfile` in the repository.

###Pre-requisite
Install git-lfs and lfs using the below commands:

```
brew install git-lfs

git lfs install
```

### Implement `BluedotPointSDK`

1. import `BDPointSDK` to your class:

**Swift**

```swift
import BDPointSDK
```

2. Implement Bluedot location delegate:

**Swift**
```swift
class YourClass: BDPLocationDelegate {

    func didCheck(
        intoFence fence: BDFenceInfo!,
        inZone zoneInfo: BDZoneInfo!,
        willCheckOut: Bool,
        withCustomData customData: [AnyHashable : Any]!
    ) {
     
        // Your logic when the device enters a Bluedot Zone

    }

    func didCheckOut(
        fromFence fence: BDFenceInfo!,
        inZone zoneInfo: BDZoneInfo!,
        on date: Date!,
        withDuration checkedInDuration: UInt,
        withCustomData customData: [AnyHashable : Any]!
    ) {
        
        // Your logic when the device leaves a Bluedot Zone
        
    }

    // Beacons entry / exit. This is optional, unless beacons are used.
    func didCheck(
        intoBeacon beacon: BDBeaconInfo!,
        inZone zoneInfo: BDZoneInfo!,
        atLocation locationInfo: BDLocationInfo!,
        with proximity: CLProximity,
        willCheckOut: Bool,
        withCustomData customData: [AnyHashable : Any]!
    ) {

        // Your logic when the device enters in the range of beacon in a Bluedot Zone
    }


    func didCheckOut(
        fromBeacon beacon: BDBeaconInfo!,
        inZone zoneInfo: BDZoneInfo!,
        with proximity: CLProximity,
        on date: Date!,
        withDuration checkedInDuration: UInt,
        withCustomData customData: [AnyHashable : Any]! 
    ) {

        // your logic when a devices leaves the range of beacon of a Bluedot Zone

    }

}
```

3. Assign location delegate with your implementation

**Swift**
```swift
let instanceOfYourClass = YourClass()
BDLocationManager.instance()?.locationDelegate = instanceOfYourClass
```

4. Authenticate with the Bluedot services

**Swift**
```swift
BDLocationManager.instance()?.authenticate(withApiKey: "Your assigned Bluedot API Key", requestAuthorization: .authorizedAlways)
```

### Implement `Braze Appboy SDK`

1. Import `Appboy-iOS-SDK` to your class

**Swift**
```swift
import Appboy_iOS_SDK
```

2. Start `Appboy-iOS-SDK` within the `application:didFinishLaunchingWithOptions` method. 
For further information refer to [Braze Developer Documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/initial_sdk_setup/)

**Swift**
```swift
Appboy.start(withApiKey: "Your assigned Braze API Key", in: application, withLaunchOptions: launchOptions)
```

3. Track `Braze` custom events in your Bluedot Entry / Exit events.

```swift
func didCheck(
    intoFence fence: BDFenceInfo!,
    inZone zoneInfo: BDZoneInfo!,
    atLocation location: BDLocationInfo!,
    willCheckOut: Bool,
    withCustomData customData: [AnyHashable : Any]!
){
    // Name the custom event 
    let customEventName = "bluedot_entry"

    // Map the Location and Bluedot Zone attributes into a properties dictionary
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

    // Log the Custom Event in Appboy
    Appboy.sharedInstance()?.logCustomEvent(customEventName, withProperties: properties );
}
```

## Next steps
Full documentation can be found at https://docs.bluedot.io/ios-sdk/ and https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/initial_sdk_setup/ respectivelly.
