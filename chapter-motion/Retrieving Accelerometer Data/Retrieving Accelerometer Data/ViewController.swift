//
//  ViewController.swift
//  Retrieving Accelerometer Data
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

/* 1 */
//import UIKit
//import CoreMotion
//
//class ViewController: UIViewController {
//
//  lazy var motionManager = CMMotionManager()
//
//}

/* 2 */
import UIKit
import CoreMotion

class ViewController: UIViewController {
  
  lazy var motionManager = CMMotionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if motionManager.accelerometerAvailable{
      let queue = NSOperationQueue()
      motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
        {(data: CMAccelerometerData!, error: NSError!) in
          
          println("X = \(data.acceleration.x)")
          println("Y = \(data.acceleration.y)")
          println("Z = \(data.acceleration.z)")
          
        }
      )
    } else {
      println("Accelerometer is not available")
    }
    
  }
  
}

