//
//  AppDelegate.swift
//  Reacting to Push Notifications
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  
  func application(application: UIApplication!,
    didReceiveRemoteNotification userInfo: [NSObject : AnyObject]!) {
    
  }

  func application(application: UIApplication!,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
      
      /* Each byte in the data will be translated to its hex value like 0x01 or
      0xAB excluding the 0x part, so for 1 byte, we will need 2 characters to
      represent that byte, hence the * 2 */
      var tokenAsString = NSMutableString()
      
      /* Create a buffer of UInt8 values and then get the raw bytes
      of the device token into this buffer */
      var byteBuffer = [UInt8](count: deviceToken.length, repeatedValue: 0x00)
      deviceToken.getBytes(&byteBuffer)
      
      /* Now convert the bytes into their hex equivalent */
      for byte in byteBuffer{
        tokenAsString.appendFormat("%02hhX", byte)
      }
      
      println("Token = \(tokenAsString)")
      
  }
  
  func application(application: UIApplication!,
    didFailToRegisterForRemoteNotificationsWithError error: NSError!){
      
  }
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
      
      application.registerForRemoteNotifications()
      
      return true
  }
  
}

