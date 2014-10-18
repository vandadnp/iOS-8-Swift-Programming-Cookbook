//
//  AppDelegate.swift
//  Storing and Synchronizing Dictionaries in iCloud
//
//  Created by vandad on 207//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  /* Checks if the user has logged into her iCloud account or not */
  func isIcloudAvailable() -> Bool{
    if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      if isIcloudAvailable() == false{
        println("iCloud is not available")
        return true
      }
      
      let kvoStore = NSUbiquitousKeyValueStore.defaultStore()
      
      var stringValue = "My String"
      let stringValueKey = "MyStringKey"
      
      var boolValue = true
      let boolValueKey = "MyBoolKey"
      
      var mustSynchronize = false
      
      if kvoStore.stringForKey(stringValueKey) == nil{
        println("Could not find the string value in iCloud. Setting...")
        kvoStore.setString(stringValue, forKey: stringValueKey)
        mustSynchronize = true
      } else {
        stringValue = kvoStore.stringForKey(stringValueKey)!
        println("Found the string in iCloud = \(stringValue)")
      }
      
      if kvoStore.boolForKey(boolValueKey) == false{
        println("Could not find the boolean value in iCloud. Setting...")
        kvoStore.setBool(boolValue, forKey: boolValueKey)
        mustSynchronize = true
      } else {
        println("Found the boolean in iCloud, getting...")
        boolValue = kvoStore.boolForKey(boolValueKey)
      }
      
      if mustSynchronize{
        if kvoStore.synchronize(){
          println("Successfully synchronized with iCloud.")
        } else {
          println("Failed to synchronize with iCloud.")
        }
      }
      
      return true
  }
  
}

