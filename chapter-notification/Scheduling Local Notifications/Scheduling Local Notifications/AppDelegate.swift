//
//  AppDelegate.swift
//  Scheduling Local Notifications
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
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
      
      /* First ask the user if we are
      allowed to perform local notifications */
      let settings = UIUserNotificationSettings(forTypes: .Alert,
        categories: nil)
      
      application.registerUserNotificationSettings(settings)
      
      return true
  }
  
  func application(application: UIApplication!,
    didRegisterUserNotificationSettings
    notificationSettings: UIUserNotificationSettings!){
      
      if notificationSettings.types == nil{
        /* The user did not allow us to send notifications */
        return
      }
      
      let notification = UILocalNotification()
      
      /* Time and timezone settings */
      
      notification.fireDate = NSDate(timeIntervalSinceNow: 8)
      notification.timeZone = NSCalendar.currentCalendar().timeZone
      
      notification.alertBody = "A new item is downloaded"
      
      /* Action settings */
      notification.hasAction = true
      notification.alertAction = "View"
      
      /* Badge settings */
      notification.applicationIconBadgeNumber++
      
      /* Additional information, user info */
      notification.userInfo = [
        "Key 1" : "Value 1",
        "Key 2" : "Value 2"
      ]
      
      /* Schedule the notification */
      application.scheduleLocalNotification(notification)
      
  }
  
}

