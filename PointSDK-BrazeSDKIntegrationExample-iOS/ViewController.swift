//
//  ViewController.swift
//  PointSDK-BrazeSDKIntegrationExample-iOS
//
//  Created by Daniel Toro on 22/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import UIKit
import BDPointSDK
import Appboy_iOS_SDK

let bluedotApiKey = "647bff30-c8c1-11e6-b298-b8ca3a6b879d"

class ViewController: UIViewController {
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        BDLocationManager.instance()?.sessionDelegate = self
    }
    
    
    @IBAction func authenticatePointSDK(_ sender: UIButton) {
       
        switch BDLocationManager.instance()!.authenticationState {
        case .authenticated:
            BDLocationManager.instance()?.logOut()
            
        case .notAuthenticated:
            BDLocationManager.instance()?.authenticate(withApiKey: bluedotApiKey, requestAuthorization: .authorizedAlways)
        
        default:
            return
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: BDPointDelegate {
    func willAuthenticate(withApiKey apiKey: String!) {
         print( "Authenticating with Point sdk" )
    }
    
    func authenticationWasSuccessful() {
        print( "Authenticated successfully with Point sdk" )
        authenticateButton.setTitle("Logout", for: .normal)
    }
    
    func authenticationWasDenied(withReason reason: String!) {
        print("Authentication with Point sdk denied, with reason: \(reason!)")
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func authenticationFailedWithError(_ error: Error!) {
        print( "Authentication with Point sdk failed, with reason: \(error.localizedDescription)" )
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSession() {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSessionWithError(_ error: Error!) {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
}
