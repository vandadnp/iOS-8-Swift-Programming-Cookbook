//
//  ViewController.swift
//  Authenticating the User with Touch ID
//
//  Created by Vandad Nahavandipoor on 7/7/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
  
  @IBOutlet weak var buttonCheckTouchId: UIButton!
  @IBOutlet weak var buttonUseTouchId: UIButton!
  
  @IBAction func checkTouchIdAvailability(sender: AnyObject) {
    
    let context = LAContext()
    
    do {
      try context.canEvaluatePolicy(
            .DeviceOwnerAuthenticationWithBiometrics)
      
      buttonUseTouchId.enabled = true
      
      let alertController = UIAlertController(title: "Touch ID",
        message: "Touch ID is not available",
        preferredStyle: .Alert)
      
      alertController.addAction(UIAlertAction(title: "OK",
        style: .Default,
        handler: nil))
      
      presentViewController(alertController, animated: true, completion: nil)
      
    } catch {
      buttonUseTouchId.enabled = false
    }
    
  }
  
  @IBAction func useTouchId(sender: AnyObject) {
    /* We will code this soon */
    
    let context = LAContext()
    let reason = "Please authenticate with Touch ID " +
    "to access your private information"
    
    context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
      localizedReason: reason, reply: {success, error in
        
        if success{
          /* The user was successfully authenticated */
        } else {
          /* The user could not be authenticated */
        }
        
    })
    
  }

}

