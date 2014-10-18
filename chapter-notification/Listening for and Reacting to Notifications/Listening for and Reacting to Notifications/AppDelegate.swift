//
//  AppDelegate.swift
//  Listening for and Reacting to Notifications
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
  
  /* The name of the notification that we are going to send */
  class func notificationName() -> String{
    return "SetPersonInfoNotification"
  }
  /* The first-name key in the user-info dictionary of our notification */
  class func personInfoKeyFirstName () -> String{
    return "firstName"
  }
  /* The last-name key in the user-info dictionary of our notification */
  class func personInfoKeyLastName() -> String{
    return "lastName"
  }

  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
      let steveJobs = Person()
      
      let userInfo = [
        self.classForCoder.personInfoKeyFirstName() : "Steve",
        self.classForCoder.personInfoKeyLastName() : "Jobs",
        ]
      
      let notification = NSNotification(
        name: self.classForCoder.notificationName(),
        object: self,
        userInfo: userInfo)
      
      /* The person class is currently listening for this notification. That class
      will extract the first name and last name from it and set its own first
      name and last name based on the userInfo dictionary of the notification. */
      NSNotificationCenter.defaultCenter().postNotification(notification)
      
      /* Here is proof */
      if let firstName = steveJobs.firstName{
        println("Person's first name is: \(firstName)")
      }
      if let lastName = steveJobs.lastName{
        println("Person's last name is: \(lastName)")
      }
      
    return true
  }
  
}

