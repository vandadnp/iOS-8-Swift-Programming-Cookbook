//
//  AppDelegate.swift
//  Retrieving Gyroscope Data
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var manager = CMMotionManager()
  lazy var queue = NSOperationQueue()
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
      
      
      if manager.gyroAvailable{
        
        if manager.gyroActive == false{
          
          manager.gyroUpdateInterval = 1.0 / 40.0
          
          manager.startGyroUpdatesToQueue(queue,
            withHandler: {data, error in
              
              guard let data = data else{
                return
              }
              
              print("Gyro Rotation x = \(data.rotationRate.x)")
              print("Gyro Rotation y = \(data.rotationRate.y)")
              print("Gyro Rotation z = \(data.rotationRate.z)")
              
            })
          
        } else {
          print("Gyro is already active")
        }
        
      } else {
        print("Gyro isn't available")
      }
      
      return true
  }
  
}

