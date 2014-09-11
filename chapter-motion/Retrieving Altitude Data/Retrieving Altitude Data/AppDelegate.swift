//
//  AppDelegate.swift
//  Retrieving Altitude Data
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  /* The altimeter instance that will deliver our altitude updates if they
  are available on the host device */
  lazy var altimeter = CMAltimeter()
  /* A private queue on which altitude updates will be delivered to us */
  lazy var queue = NSOperationQueue()

  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
    return true
  }
  
  /* Start altitude updates if possible */
  func applicationDidBecomeActive(application: UIApplication!) {
    if CMAltimeter.isRelativeAltitudeAvailable(){
      altimeter.startRelativeAltitudeUpdatesToQueue(queue,
        withHandler: {(data: CMAltitudeData!, error: NSError!) in
          
          println("Relative altitude is \(data.relativeAltitude) meters")
          
        })
    }
  }
  
  /* Stop altitude updates */
  func applicationWillResignActive(application: UIApplication!) {
    altimeter.stopRelativeAltitudeUpdates()
  }

}

