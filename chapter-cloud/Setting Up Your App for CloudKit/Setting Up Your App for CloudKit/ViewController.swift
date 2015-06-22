//
//  ViewController.swift
//  Setting Up Your App for CloudKit
//
//  Created by Vandad Nahavandipoor on 7/11/14.
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
import CloudKit

class ViewController: UIViewController {
  
  let container = CKContainer.defaultContainer()
  
  func handleIdentityChanged(notification: NSNotification){
    
    let fileManager = NSFileManager()
    
    if let token = fileManager.ubiquityIdentityToken{
      print("The new token is \(token)", appendNewline: false)
    } else {
      print("User has logged out of iCloud", appendNewline: false)
    }
    
  }
  
  /* Start listening for iCloud user change notifications */
  func applicationBecameActive(notification: NSNotification){
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleIdentityChanged:",
      name: NSUbiquityIdentityDidChangeNotification,
      object: nil)
  }
  
  /* Stop listening for those notifications when the app becomes inactive */
  func applicationBecameInactive(notification: NSNotification){
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: NSUbiquityIdentityDidChangeNotification,
      object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Find out when the app is becoming active and inactive
    so that we can find out when the user's iCloud logging status changes.*/
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "applicationBecameActive:",
      name: UIApplicationDidBecomeActiveNotification,
      object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "applicationBecameInactive:",
      name: UIApplicationWillResignActiveNotification,
      object: nil)
    
  }
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    container.accountStatusWithCompletionHandler{
      (status: CKAccountStatus, error: NSError?) in
      
      /* Be careful, we might be on a different thread now so make sure that
      your UI operations go on the main thread */
      dispatch_async(dispatch_get_main_queue(), {
        
        var title: String!
        var message: String!
        
        if error != nil{
          title = "Error"
          message = "An error occurred = \(error)"
        } else {
          
          title = "No errors occurred"
          
          switch status{
          case .Available:
            message = "The user is logged in to iCloud"
          case .CouldNotDetermine:
            message = "Could not determine if the user is logged" +
            " into iCloud or not"
          case .NoAccount:
            message = "User is not logged into iCloud"
          case .Restricted:
            message = "Could not access user's iCloud account information"
          }
          
          self.displayAlertWithTitle(title, message: message)
          
        }
        
      })
      
    }
    
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}

