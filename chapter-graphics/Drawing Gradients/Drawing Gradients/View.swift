//
//  View.swift
//  Drawing Gradients
//
//  Created by Vandad Nahavandipoor on 6/25/14.
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
  
  override func drawRect(rect: CGRect) {
    
    let currentContext = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    let startColor = UIColor.blueColor()
    let startColorComponents = CGColorGetComponents(startColor.CGColor)
    
    let endColor = UIColor.greenColor()
    let endColorComponents = CGColorGetComponents(endColor.CGColor)
    
    let colorComponents = [
      
      /* Four components of the orange color (RGBA) */
      startColorComponents[0],
      startColorComponents[1],
      startColorComponents[2],
      startColorComponents[3], /* First color = orange */
      
      
      /* Four components of the blue color (RGBA) */
      endColorComponents[0],
      endColorComponents[1],
      endColorComponents[2],
      endColorComponents[3], /* Second color = blue */
      
    ]
    
    let colorIndices = [
      0.0, /* Color 0 in the colorComponents array */
      1.0, /* Color 1 in the colorComponents array */
    ] as [CGFloat]
    
    let gradient = CGGradientCreateWithColorComponents(colorSpace,
      colorComponents,
      colorIndices,
      2)
    
    let screenBounds = UIScreen.mainScreen().bounds
    
    let startPoint = CGPoint(x: 0, y: screenBounds.size.height / 2)
    
    let endPoint = CGPoint(x: screenBounds.size.width, y: startPoint.y)
    
    CGContextDrawLinearGradient (currentContext,
    gradient,
    startPoint,
    endPoint,
    0)
    
  }

}
