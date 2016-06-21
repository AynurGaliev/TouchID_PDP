//
//  AuthenticationViewController.swift
//  TouchID_PDP
//
//  Created by Galiev Aynur on 22.06.16.
//  Copyright © 2016 FlatStack. All rights reserved.
//
import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    @IBAction func loginButtonClicked(sender: UIButton) {
        
        let authenticationContext: LAContext = LAContext()
        var error                : NSError?
        
        var policy: LAPolicy = .DeviceOwnerAuthenticationWithBiometrics
        if #available(iOS 9.0, *) {
            policy = .DeviceOwnerAuthentication
        }
        
        guard authenticationContext.canEvaluatePolicy(policy, error: &error) else {
            showAlertWithTitle("Error", message: "This device does not have a TouchID sensor")
            return
        }
        

        authenticationContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
            localizedReason : "Application requires authentification",
            reply           : { [weak self] (success, error) -> Void in
                
            guard let sself = self else { return }
                
            if success {
                sself.showAlertWithTitle("Success", message: "Authentification succeeded!")
            } else {
                if let lError = error {
                    let message = sself.getErrorMessage(forErrorCode: lError.code)
                    sself.showAlertWithTitle("Error", message: message)
                }
            }
            
        })
        
    }


    func showAlertWithTitle(title: String, message: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            alertVC.addAction(okAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    func getErrorMessage(forErrorCode code: Int) -> String {
        
        var message = ""
        
        switch code {
            case LAError.AuthenticationFailed.rawValue  : message = "Authentication failed"
            case LAError.PasscodeNotSet.rawValue        : message = "Passcode is not set on the device"
            case LAError.SystemCancel.rawValue          : message = "Authentication was cancelled by the system"
            case LAError.TouchIDNotAvailable.rawValue   : message = "TouchID is not available on the device"
            case LAError.UserCancel.rawValue            : message = "The user did cancel"
            case LAError.UserFallback.rawValue          : message = "The user chose to use the fallback"
            default                                     : message = "Unknown error"
        }
        
        if #available(iOS 9.0, *) {
            switch code {
            case LAError.AppCancel.rawValue             : message = "Authentication was cancelled"
            case LAError.InvalidContext.rawValue        : message = "The context is invalid"
            case LAError.TouchIDLockout.rawValue        : message = "Too many attempts"
            default                                     : return message
            }
        }
        
        return message
        
    }

}

