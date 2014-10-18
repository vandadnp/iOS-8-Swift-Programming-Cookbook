//
//  AppDelegate.swift
//  Handling Local System Notifications
//
//  Created by vandad on 157//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func handleSettingsChanged(notification: NSNotification){
    
    println("Settings changed")
    
    if let object:AnyObject = notification.object{
      println("Notification Object = \(object)")
    }
    
  }
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "handleSettingsChanged:",
        name: NSUserDefaultsDidChangeNotification,
        object: nil)
      
      return true
  }
  
}

