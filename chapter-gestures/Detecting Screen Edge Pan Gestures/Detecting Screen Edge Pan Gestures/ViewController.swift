//
//  ViewController.swift
//  Detecting Screen Edge Pan Gestures
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
import Twitter

class ViewController: UIViewController {
  
  var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }

  func handleScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer){
    
    if sender.state == .Ended{
      displayAlertWithTitle("Detected",
        message: "Edge swipe was detected")
    }
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    /* Create the Pinch Gesture Recognizer */
    screenEdgeRecognizer =  UIScreenEdgePanGestureRecognizer(target: self,
      action: "handleScreenEdgePan:")
    
    /* Detect pans from left edge to the inside of the view */
    screenEdgeRecognizer.edges = .Left
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGestureRecognizer(screenEdgeRecognizer)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    displayAlertWithTitle("Instructions",
      message: "Start swiping from the left edge of the screen " +
      "to the right, please!")
  }
  
}

