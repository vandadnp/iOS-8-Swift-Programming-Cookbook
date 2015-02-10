//
//  AppDelegate.swift
//  Detecting the Availability of an Accelerometer
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
      
      let motionManager = CMMotionManager()
      
      if motionManager.accelerometerAvailable{
        println("Accelerometer is available")
      } else{
        println("Accelerometer is not available")
      }
      
      if motionManager.accelerometerActive{
        println("Accelerometer is active")
      } else {
        println("Accelerometer is not active")
      }
      
      return true
  }
  
}

