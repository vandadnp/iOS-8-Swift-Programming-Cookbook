//
//  AppDelegate.swift
//  Retrieving Pedometer Data
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

/* 1 */
//import UIKit
//import CoreMotion
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//  lazy var pedometer = CMPedometer()
//
//  func application(application: UIApplication!,
//    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
//      return true
//  }
//
//  func applicationDidBecomeActive(application: UIApplication!) {
//    if CMPedometer.isStepCountingAvailable(){
//
//      pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: {
//        (data: CMPedometerData!, error: NSError!) in
//
//        println("Number of steps = \(data.numberOfSteps)")
//
//        })
//
//    } else {
//      println("Step counting is not available")
//    }
//  }
//
//  func applicationWillResignActive(application: UIApplication!) {
//    pedometer.stopPedometerUpdates()
//  }
//
//}

/* 2 */
//import UIKit
//import CoreMotion
//
///* A really simple extension on NSDate that gives us convenience methods
//for "now" and "yesterday" */
//extension NSDate{
//  class func now() -> NSDate{
//    return NSDate()
//  }
//  class func yesterday() -> NSDate{
//    return NSDate(timeIntervalSinceNow: -(24 * 60 * 60))
//  }
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  lazy var pedometer = CMPedometer()
//  
//  func application(application: UIApplication!,
//    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
//      return true
//  }
//  
//  func applicationDidBecomeActive(application: UIApplication!) {
//    
//    /* Can we ask for distance updates? */
//    if CMPedometer.isDistanceAvailable(){
//      
//      pedometer.queryPedometerDataFromDate(NSDate.yesterday(),
//        toDate: NSDate.now(),
//        withHandler: {(data: CMPedometerData!, error: NSError!) in
//          
//        println("Distance travelled from yesterday to now " +
//          "= \(data.distance) meters")
//        
//        })
//      
//    } else {
//      println("Distance counting is not available")
//    }
//  }
//  
//  func applicationWillResignActive(application: UIApplication!) {
//    pedometer.stopPedometerUpdates()
//  }
//  
//}

/* 3 */
import UIKit
import CoreMotion

extension NSDate{
  class func now() -> NSDate{
    return NSDate()
  }
  class func tenMinutesAgo() -> NSDate{
    return NSDate(timeIntervalSinceNow: -(10 * 60))
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var pedometer = CMPedometer()
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
      return true
  }
  
  func applicationDidBecomeActive(application: UIApplication!) {
    
    /* Can we ask for floor climb/descending updates? */
    if CMPedometer.isFloorCountingAvailable(){
      
      pedometer.queryPedometerDataFromDate(NSDate.tenMinutesAgo(),
        toDate: NSDate.now(),
        withHandler: {(data: CMPedometerData!, error: NSError!) in

          println("Floors ascended = \(data.floorsAscended)")
          println("Floors descended = \(data.floorsAscended)")
          
        })
      
    } else {
      println("Floor counting is not available")
    }
  }
  
  func applicationWillResignActive(application: UIApplication!) {
    pedometer.stopPedometerUpdates()
  }
  
}
