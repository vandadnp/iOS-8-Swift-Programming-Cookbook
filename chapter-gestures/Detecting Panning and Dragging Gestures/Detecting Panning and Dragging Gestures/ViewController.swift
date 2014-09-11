//
//  ViewController.swift
//  Detecting Panning and Dragging Gestures
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
  var panGestureRecognizer: UIPanGestureRecognizer!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let labelFrame = CGRect(x: 0, y: 0, width: 150, height: 100)
    helloWorldLabel = UILabel(frame: labelFrame)
    /* Make sure to enable user interaction; otherwise, tap events
    won't be caught on this label */
    helloWorldLabel.userInteractionEnabled = true
    helloWorldLabel.text = "Hello World"
    helloWorldLabel.frame = labelFrame
    helloWorldLabel.backgroundColor = UIColor.blackColor()
    helloWorldLabel.textColor = UIColor.whiteColor()
    helloWorldLabel.textAlignment = .Center
    panGestureRecognizer = UIPanGestureRecognizer(target: self,
      action: "handlePanGestures:")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Now make sure this label gets displayed on our view */
    view.addSubview(helloWorldLabel)
    
    /* At least and at most we need only one finger to activate
    the pan gesture recognizer */
    panGestureRecognizer.minimumNumberOfTouches = 1
    panGestureRecognizer.maximumNumberOfTouches = 1
    
    /* Add it to our view */
    helloWorldLabel.addGestureRecognizer(panGestureRecognizer)
    
  }
  
  func handlePanGestures(sender: UIPanGestureRecognizer){
    
    if sender.state != .Ended && sender.state != .Failed{
      let location = sender.locationInView(sender.view.superview)
      sender.view.center = location
    }
    
  }
  
  
}

