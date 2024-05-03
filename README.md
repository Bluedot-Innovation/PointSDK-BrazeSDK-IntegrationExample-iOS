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

    func didEnterZone(_ triggerEvent: GeoTriggerEvent) {
        // Your logic when the device enters a Bluedot Zone
    }

     func didExitZone(_ triggerEvent: GeoTriggerEvent) {
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
BDLocationManager.instance()?.initialize(withProjectId: projectId) { error in
     guard error == nil else {
        print("There was an error initializing the Bluedot SDK: \(error.localizedDescription)")
        return
     }
}
```

### Implement `Braze SDK`

1.  Install the Braze SDK and then import to your class: `import BrazeKit`

2.	Add a static property to your AppDelegate class

	```swift
	class AppDelegate: UIResponder, UIApplicationDelegate {
  		static var braze: Braze? = nil
	}
	```

3.  Configure Braze SDK within the `application:didFinishLaunchingWithOptions` method.  
For further information refer to [Braze Developer Documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/swift/initial_sdk_setup/overview)

	```swift
	let configuration = Braze.Configuration(
		apiKey: "YOUR-APP-IDENTIFIER-API-KEY", // Should be taken from Braze Portal -> Manage Settings -> Settings Tab -> Your App -> API Key
		endpoint: "YOUR-BRAZE-ENDPOINT" // Should be taken from Braze Portal -> Manage Settings -> Settings Tab -> Your App -> SDK Endpoint
	)

	let braze = Braze(configuration: configuration)
	AppDelegate.braze = braze
	```

4.  Track Braze custom events in your Bluedot Entry / Exit events.

	```swift
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
	
		// Log the Custom Event in Braze
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
	
		// Log the Custom Event in Braze
		AppDelegate.braze?.logCustomEvent(name: customEventName, properties: properties)
	}
	```
	
## Next steps
Full documentation can be found at https://docs.bluedot.io/ios-sdk/ and https://www.braze.com/docs/developer_guide/platform_integration_guides/swift/initial_sdk_setup/overview respectively.
