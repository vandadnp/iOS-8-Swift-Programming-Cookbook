//
//  ViewController.swift
//  Performing UI-Related Tasks
//
//  Created by Vandad Nahavandipoor on 7/3/14.
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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    dispatch_async(dispatch_get_main_queue(), {[weak self] in
//      
//      let alertController = UIAlertController(title: "GCD",
//        message: "GCD is amazing!",
//        preferredStyle: .Alert)
//      
//      alertController.addAction(UIAlertAction(title: "OK",
//        style: .Default,
//        handler: nil))
//      
//      self!.presentViewController(alertController,
//        animated: true,
//        completion: nil)
//      
//      })
//    
//    }
//  
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dispatch_async(dispatch_get_main_queue(), {
      println("Current thread = \(NSThread.currentThread())")
      println("Main thread = \(NSThread.mainThread())")
      })
    
  }
  
}

