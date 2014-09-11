//
//  ViewController.swift
//  Presenting Custom Sharing Options with UIActivityViewController
//
//  Created by Vandad Nahavandipoor on 6/28/14.
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
                            
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let itemsToShare = [
      "Item 1" as NSString,
      "Item 2" as NSString,
      "Item 3" as NSString
    ]
    
    let activityController = UIActivityViewController(
      activityItems: itemsToShare,
      applicationActivities:[StringReverserActivity()])
    
    presentViewController(activityController, animated: true, completion: nil)
    
  }

}

