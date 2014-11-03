//
//  View.swift
//  Drawing Images
//
//  Created by Vandad Nahavandipoor on 6/24/14.
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

class View: UIView {
  
  /* 1 */
//  override func drawRect(rect: CGRect)
//  {
//    let image = UIImage(named: "Safari")
//  }
  
  override func drawRect(rect: CGRect)
  {
    let image = UIImage(named: "Safari")
    image!.drawAtPoint(CGPoint(x: 0, y: 20))
    image!.drawInRect(CGRect(x: 50.0, y: 10.0, width: 40.0, height: 35.0))
  }
  
}
