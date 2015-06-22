//
//  AppDelegate.swift
//  Storing and Synchronizing Dictionaries in iCloud
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  /* Checks if the user has logged into her iCloud account or not */
  func isIcloudAvailable() -> Bool{
    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      if isIcloudAvailable() == false{
        print("iCloud is not available", appendNewline: false)
        return true
      }
      
      let kvoStore = NSUbiquitousKeyValueStore.defaultStore()
      
      var stringValue = "My String"
      let stringValueKey = "MyStringKey"
      
      var boolValue = true
      let boolValueKey = "MyBoolKey"
      
      var mustSynchronize = false
      
      if kvoStore.stringForKey(stringValueKey) == nil{
        print("Could not find the string value in iCloud. Setting...", appendNewline: false)
        kvoStore.setString(stringValue, forKey: stringValueKey)
        mustSynchronize = true
      } else {
        stringValue = kvoStore.stringForKey(stringValueKey)!
        print("Found the string in iCloud = \(stringValue)", appendNewline: false)
      }
      
      if kvoStore.boolForKey(boolValueKey) == false{
        print("Could not find the boolean value in iCloud. Setting...", appendNewline: false)
        kvoStore.setBool(boolValue, forKey: boolValueKey)
        mustSynchronize = true
      } else {
        print("Found the boolean in iCloud, getting...", appendNewline: false)
        boolValue = kvoStore.boolForKey(boolValueKey)
      }
      
      if mustSynchronize{
        if kvoStore.synchronize(){
          print("Successfully synchronized with iCloud.", appendNewline: false)
        } else {
          print("Failed to synchronize with iCloud.", appendNewline: false)
        }
      }
      
      return true
  }
  
}

