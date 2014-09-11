//
//  ViewController.swift
//  Detecting Shakes on an iOS Device
//
//  Created by vandad on 177//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  /* 1 */
  //  override func motionEnded(motion: UIEventSubtype,
  //    withEvent event: UIEvent!) {
  //
  //      /* Handle the motion here */
  //
  //  }
  
  /* 2 */
  override func motionEnded(motion: UIEventSubtype,
    withEvent event: UIEvent!) {
      
      if motion == .MotionShake{
        let controller = UIAlertController(title: "Shake",
          message: "The device is shaken",
          preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
          style: .Default,
          handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
      }
      
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

