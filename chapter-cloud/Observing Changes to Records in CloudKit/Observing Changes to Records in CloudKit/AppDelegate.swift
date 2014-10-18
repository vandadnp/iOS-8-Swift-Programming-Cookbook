//
//  AppDelegate.swift
//  Observing Changes to Records in CloudKit
//
//  Created by vandad on 197//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication!,
    didReceiveRemoteNotification userInfo: [NSObject : AnyObject]!) {
      
      println("A new record is generated and we received a push")
      
      let notification = CKNotification(
        fromRemoteNotificationDictionary: userInfo)
      
      if let query = notification as? CKQueryNotification{
        let model = query.recordFields["model"] as? NSString as? String
        if let theModel = model{
          println("The model of the newly inserted car is \(theModel)")
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
  
  func application(application: UIApplication!,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
      
      println("Successfully registered for remote notifications")
      goAheadWithSubscriptionCreation()
    
  }
  
  func application(application: UIApplication!,
    didFailToRegisterForRemoteNotificationsWithError error: NSError!){
      println("Failed to receive remote notifications")
  }
  
  func application(application: UIApplication!,
    didRegisterUserNotificationSettings
    notificationSettings: UIUserNotificationSettings!) {
      
      if notificationSettings.types == nil{
        /* The user did not allow us to send notifications */
        return
      }
      
      if application.isRegisteredForRemoteNotifications() == false{
        println("Not registered for push notifications. Registering now...")
        application.registerForRemoteNotifications()
      } else {
        println("We are already registered for push notifications")
        goAheadWithSubscriptionCreation()
      }
  }

  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      var needToRequestSettingChanges = true
      if let settings = application.currentUserNotificationSettings(){
        if settings.types != nil{
          needToRequestSettingChanges = false
        }
      }
      
      if needToRequestSettingChanges{
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Badge,
          categories: nil)
        
        println("Requesting for change to user notification settings...")
        application.registerUserNotificationSettings(settings)
      } else {
        
        println("We've already set the notification settings.")
        
        if application.isRegisteredForRemoteNotifications() == false{
          println("Not registered for push notifications. Registering now...")
          application.registerForRemoteNotifications()
        } else {
          println("We are already registered for push notifications")
          goAheadWithSubscriptionCreation()
        }
        
      }
      
    return true
  }

}

