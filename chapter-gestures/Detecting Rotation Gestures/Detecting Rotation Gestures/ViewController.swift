//
//  ViewController.swift
//  Detecting Rotation Gestures
//
//  Created by Vandad Nahavandipoor on 7/8/14.
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

class ViewController: UIViewController {
  
  var helloWorldLabel: UILabel!
  var rotationRecognizer: UIRotationGestureRecognizer!
  var rotationAngleInRadians = 0.0 as CGFloat
  
  func handleRotations(sender: UIRotationGestureRecognizer){
    
    /* Take the previous rotation and add the current rotation to it */
    helloWorldLabel.transform =
      CGAffineTransformMakeRotation(rotationAngleInRadians +
        sender.rotation)
    
    /* At the end of the rotation, keep the angle for later use */
    if sender.state == .Ended{
      rotationAngleInRadians += sender.rotation;
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    helloWorldLabel = UILabel(frame: CGRectZero)
    rotationRecognizer = UIRotationGestureRecognizer(target: self,
      action: "handleRotations:")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    helloWorldLabel.text = "Hello, World!"
    helloWorldLabel.font = UIFont.systemFontOfSize(16)
    helloWorldLabel.sizeToFit()
    helloWorldLabel.center = view.center
    view.addSubview(helloWorldLabel)
    
    view.addGestureRecognizer(rotationRecognizer)
    
  }
  
}

