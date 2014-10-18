//
//  AppDelegate.swift
//  Detecting the Availability of a Gyroscope
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      let motionManager = CMMotionManager()
      
      if motionManager.gyroAvailable{
        println("Gryro is available")
      } else {
        println("Gyro is not available")
      }
      
      if motionManager.gyroActive{
        println("Gryo is active")
      } else {
        println("Gryo is not active")
      }
      
      return true
  }
  
}

