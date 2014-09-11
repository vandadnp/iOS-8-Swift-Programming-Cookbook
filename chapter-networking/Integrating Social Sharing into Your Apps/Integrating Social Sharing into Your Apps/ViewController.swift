//
//  ViewController.swift
//  Integrating Social Sharing into Your Apps
//
//  Created by Vandad Nahavandipoor on 7/9/14.
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
import Social

class ViewController: UIViewController {
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let serviceType = SLServiceTypeTwitter
    
    if SLComposeViewController.isAvailableForServiceType(serviceType){
      let controller = SLComposeViewController(forServiceType: serviceType)
      controller.setInitialText("Safari is a great browser!")
      controller.addImage(UIImage(named: "Safari"))
      controller.addURL(NSURL(string: "http://www.apple.com/safari/"))
      controller.completionHandler = {(result: SLComposeViewControllerResult) in
        println("Completed")
      }
      presentViewController(controller, animated: true, completion: nil)
    } else {
      println("The twitter service is not available")
    }
    
  }
  
}

