//
//  ViewController.swift
//  Detecting Pinch Gestures
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
  
  var myBlackLabel: UILabel!
  var pinchGestureRecognizer: UIPinchGestureRecognizer!
  var currentScale = 0.0 as CGFloat
  
  func handlePinches(sender: UIPinchGestureRecognizer){
    
    if sender.state == .Ended{
      currentScale = sender.scale
    } else if sender.state == .Began && currentScale != 0.0{
      sender.scale = currentScale
    }
    
    if sender.scale != CGFloat.NaN && sender.scale != 0.0{
      sender.view.transform = CGAffineTransformMakeScale(sender.scale,
        sender.scale);
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let labelRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    myBlackLabel = UILabel(frame: labelRect)
    myBlackLabel.backgroundColor = UIColor.blackColor()
    /* Without this line, our pinch gesture recognizer
    will not work */
    myBlackLabel.userInteractionEnabled = true
    
    /* Create the Pinch Gesture Recognizer */
    pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
      action: "handlePinches:")
    
    /* Add this gesture recognizer to our view */
    myBlackLabel.addGestureRecognizer(pinchGestureRecognizer)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    myBlackLabel.center = view.center
    view.addSubview(myBlackLabel)
    
  }
  
}

