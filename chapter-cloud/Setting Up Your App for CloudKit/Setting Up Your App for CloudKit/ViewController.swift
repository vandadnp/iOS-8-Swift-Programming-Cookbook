//
//  ViewController.swift
//  Setting Up Your App for CloudKit
//
//  Created by vandad on 187//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
  
  let container = CKContainer.defaultContainer()
  
  func handleIdentityChanged(notification: NSNotification){
    
    let fileManager = NSFileManager()
    
    if let token = fileManager.ubiquityIdentityToken{
      println("The new token is \(token)")
    } else {
      println("User has logged out of iCloud")
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
      [weak self] (status: CKAccountStatus, error: NSError!) in
      
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
          
          self!.displayAlertWithTitle(title, message: message)
          
        }
        
        })
      
    }
    
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}

