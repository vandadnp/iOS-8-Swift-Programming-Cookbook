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
        {data, error in
          
          guard let data = data else{
            return
          }
          
          print("X = \(data.acceleration.x)")
          print("Y = \(data.acceleration.y)")
          print("Z = \(data.acceleration.z)")
          
        }
      )
    } else {
      print("Accelerometer is not available")
    }
    
  }
  
}

