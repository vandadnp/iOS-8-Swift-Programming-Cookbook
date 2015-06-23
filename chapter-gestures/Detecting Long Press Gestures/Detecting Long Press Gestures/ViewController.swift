//
//  ViewController.swift
//  Detecting Long Press Gestures
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
  
  var longPressGestureRecognizer: UILongPressGestureRecognizer!
  var dummyButton: UIButton!
  
  func handleLongPressGestures(sender: UILongPressGestureRecognizer){
    
    /* Here we want to find the mid point of the two fingers
    that caused the long press gesture to be recognized. We configured
    this number using the numberOfTouchesRequired property of the
    UILongPressGestureRecognizer that we instantiated before. If we
    find that another long press gesture recognizer is using this
    method as its target, we will ignore it */
    
    if sender.numberOfTouches() == 2{
      
      let touchPoint1 = sender.locationOfTouch(0, inView: sender.view)
      let touchPoint2 = sender.locationOfTouch(1, inView: sender.view)
      
      let midPointX = (touchPoint1.x + touchPoint2.x) / 2.0
      let midPointY = (touchPoint1.y + touchPoint2.y) / 2.0
      
      let midPoint = CGPoint(x: midPointX, y: midPointY)
      
      dummyButton.center = midPoint
      
    } else {
      /* This is a long press gesture recognizer with more
      or less than 2 fingers */
      let controller = UIAlertController(title: "Two fingers",
        message: "Please use two fingers",
        preferredStyle: .Alert)
      controller.addAction(UIAlertAction(title: "OK",
        style: .Default,
        handler: nil))
      presentViewController(controller, animated: true, completion: nil)
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    dummyButton = UIButton(type:.System)
    dummyButton.frame = CGRect(x: 0, y: 0, width: 72, height: 37)
    dummyButton.setTitle("My Button", forState: .Normal)
    
    /* First create the gesture recognizer */
    longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
      action: "handleLongPressGestures:")
    
    /* The number of fingers that must be present on the screen */
    longPressGestureRecognizer.numberOfTouchesRequired = 2
    
    /* Maximum 100 points of movement allowed before the gesture
    is recognized */
    longPressGestureRecognizer.allowableMovement = 100
    
    /* The user must press 2 fingers (numberOfTouchesRequired) for
    at least 1 second for the gesture to be recognized */
    longPressGestureRecognizer.minimumPressDuration = 1
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dummyButton.center = view.center
    view.addSubview(dummyButton)
    
    /* Add this gesture recognizer to our view */
    view.addGestureRecognizer(longPressGestureRecognizer)
    
  }
  
}

