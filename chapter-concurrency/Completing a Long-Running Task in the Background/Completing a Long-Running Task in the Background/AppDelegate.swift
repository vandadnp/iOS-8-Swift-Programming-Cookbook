//
//  AppDelegate.swift
//  Completing a Long-Running Task in the Background
//
//  Created by Vandad Nahavandipoor on 7/6/14.
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
  
  var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
  UIBackgroundTaskInvalid
  
  var myTimer: NSTimer?
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
      return true
  }
  
  func isMultitaskingSupported() -> Bool{
    return UIDevice.currentDevice().multitaskingSupported
  }
  
  func timerMethod(sender: NSTimer){
  
    let backgroundTimeRemaining =
    UIApplication.sharedApplication().backgroundTimeRemaining
    
    if backgroundTimeRemaining == DBL_MAX{
      println("Background Time Remaining = Undetermined")
    } else {
      println("Background Time Remaining = " +
        "\(backgroundTimeRemaining) Seconds")
    }
  
  }

  func applicationDidEnterBackground(application: UIApplication) {
    
    if isMultitaskingSupported() == false{
      return
    }
    
    myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0,
      target: self,
      selector: "timerMethod:",
      userInfo: nil,
      repeats: true)
    
    backgroundTaskIdentifier =
      application.beginBackgroundTaskWithName("task1",
        expirationHandler: {[weak self] in
        self!.endBackgroundTask()
        })
    
  }
  
  func endBackgroundTask(){
    
    let mainQueue = dispatch_get_main_queue()
    
    dispatch_async(mainQueue, {[weak self] in
      if let timer = self!.myTimer{
        timer.invalidate()
        self!.myTimer = nil
        UIApplication.sharedApplication().endBackgroundTask(
          self!.backgroundTaskIdentifier)
        self!.backgroundTaskIdentifier = UIBackgroundTaskInvalid
      }
      })
  }

  func applicationWillEnterForeground(application: UIApplication) {
    if backgroundTaskIdentifier != UIBackgroundTaskInvalid{
      endBackgroundTask()
    }
  }
  
}

