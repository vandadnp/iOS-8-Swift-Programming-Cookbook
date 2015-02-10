//
//  AppDelegate.swift
//  Adding Widgets to the Notification Center
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

/* This is an extenstion on the String class that can convert a given
string with the format of %d-%d into an NSIndexPath */
extension String{
  func toIndexPath () -> NSIndexPath{
    let components = self.componentsSeparatedByString("-")
    if components.count == 2{
      let section = components[0]
      let row = components[1]
      if let sectionValue = section.toInt(){
        if let rowValue = row.toInt(){
          return NSIndexPath(forRow: rowValue, inSection: sectionValue)
        }
      }
    }
    return NSIndexPath()
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let widgetUrlScheme = "widget"
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [NSObject : AnyObject]?) -> Bool {
      return true
  }
  
  func application(application: UIApplication,
    handleOpenURL url: NSURL) -> Bool {
      
      if url.scheme == widgetUrlScheme{
        
        /* Goes through our extension to convert 
        String to NSIndexPath */
        let indexPath: NSIndexPath = url.host!.toIndexPath()
        
        /* Now do your work with the index path */
        println(indexPath)
        
      }
      
      return true
  }
}

