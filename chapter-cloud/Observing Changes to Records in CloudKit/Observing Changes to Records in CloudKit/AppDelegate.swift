//
//  AppDelegate.swift
//  Observing Changes to Records in CloudKit
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication,
    didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
      
      print("A new record is generated and we received a push")
      
      var dict = [String : NSObject]()
      
      for (key, value) in userInfo.filter({return $0 is String && $1 is NSObject}){
        dict[key as! String] = value as? NSObject
      }
      
      let notification = CKNotification(fromRemoteNotificationDictionary: dict)
      
      if let query = notification as? CKQueryNotification{
        let model = query.recordFields?["model"] as? String
        if let theModel = model{
          print("The model of the newly inserted car is \(theModel)")
        }
        
      }
    
  }
  
  class func goAheadWithSubscriptionCreationNotificationName() -> String{
    return "\(__FUNCTION__)"
  }
  
  func goAheadWithSubscriptionCreation(){
    NSNotificationCenter.defaultCenter().postNotificationName(
      AppDelegate.goAheadWithSubscriptionCreationNotificationName(),
      object: nil)
  }
  
  func application(application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
      
      print("Successfully registered for remote notifications")
      goAheadWithSubscriptionCreation()
    
  }
  
  func application(application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: NSError){
      print("Failed to receive remote notifications")
  }
  
  func application(application: UIApplication,
    didRegisterUserNotificationSettings
    notificationSettings: UIUserNotificationSettings) {
      
      if application.isRegisteredForRemoteNotifications() == false{
        print("Not registered for push notifications. Registering now...")
        application.registerForRemoteNotifications()
      } else {
        print("We are already registered for push notifications")
        goAheadWithSubscriptionCreation()
      }
  }

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      var needToRequestSettingChanges = true
      if let _ = application.currentUserNotificationSettings(){
          needToRequestSettingChanges = false
      }
      
      if needToRequestSettingChanges{
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge],
          categories: nil)
        
        print("Requesting for change to user notification settings...")
        application.registerUserNotificationSettings(settings)
      } else {
        
        print("We've already set the notification settings.")
        
        if application.isRegisteredForRemoteNotifications() == false{
          print("Not registered for push notifications. Registering now...")
          application.registerForRemoteNotifications()
        } else {
          print("We are already registered for push notifications")
          goAheadWithSubscriptionCreation()
        }
        
      }
      
    return true
  }

}

