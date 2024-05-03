//
//  ViewController.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 22/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import UIKit
import UserNotifications
import BDPointSDK
import BrazeKit

let projectId = "BLUEDOT-PROJECT-ID" // Should be taken from Bluedot Project Canvas

class ViewController: UIViewController {
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BDLocationManager.instance()?.requestWhenInUseAuthorization()
    }
    
    
    @IBAction func initializePointSDK(_ sender: UIButton) {
       
        if BDLocationManager.instance()?.isInitialized() == false {
            BDLocationManager.instance()?.initialize(withProjectId: projectId) {
                error in
                guard error == nil else {
                    self.showAlert(title: "SDK Initialization error",  message: error!.localizedDescription)
                    return
                }
                 
                print("SDK Initialized")
                BDLocationManager.instance()?.requestAlwaysAuthorization()
            }
        }
    }
    
    @IBAction func startGeoTriggering(_ sender: UIButton) {
        BDLocationManager.instance()?.startGeoTriggering() { error in
            guard error == nil else {
                self.showAlert(title: "Start Geotriggering error", message: error!.localizedDescription)
                return
            }
            
            print("Geotriggering Started")
        }
    }
    
    @IBAction func stopGeoTriggering(_ sender: UIButton) {
        BDLocationManager.instance()?.stopGeoTriggering() { error in
            guard error == nil else {
                self.showAlert(title: "Stop Geotriggering error", message: error!.localizedDescription)
                return
            }
            
            print("Geotriggering Stopped")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
