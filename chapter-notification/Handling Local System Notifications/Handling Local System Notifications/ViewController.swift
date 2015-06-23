//
//  ViewController.swift
//  Handling Local System Notifications
//
//  Created by vandad on 157//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  func orientationChanged(notification: NSNotification){
    print("Orientation Changed")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Listen for the notification */
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "orientationChanged:",
      name: UIDeviceOrientationDidChangeNotification,
      object: nil)
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    /* Stop listening for the notification */
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: UIDeviceOrientationDidChangeNotification,
      object: nil)
    
  }
  
}

