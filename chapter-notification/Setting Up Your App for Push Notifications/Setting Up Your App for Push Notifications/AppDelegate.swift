//
//  AppDelegate.swift
//  Setting Up Your App for Push Notifications
//
//  Created by vandad on 157//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
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
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      application.registerForRemoteNotifications()
      
      return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

