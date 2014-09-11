//
//  View.swift
//  Constructing Paths
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
    
    /* Create the path */
    let path = CGPathCreateMutable()
    
    /* How big is our screen? We want the X to cover the whole screen */
    let screenBounds = UIScreen.mainScreen().bounds
    
    /* Start from top-left */
    CGPathMoveToPoint(path,
      nil,
      screenBounds.origin.x,
      screenBounds.origin.y)
    
    /* Draw a line from top-left to bottom-right of the screen */
    CGPathAddLineToPoint(path,
      nil,
      screenBounds.size.width,
      screenBounds.size.height)
    
    /* Start another line from top-right */
    CGPathMoveToPoint(path,
      nil,
      screenBounds.size.width,
      screenBounds.origin.y)
    
    /* Draw a line from top-right to bottom-left */
    CGPathAddLineToPoint(path,
      nil,
      screenBounds.origin.x,
      screenBounds.size.height)
    
    /* Get the context that the path has to be drawn on */
    let context = UIGraphicsGetCurrentContext()
    
    /* Add the path to the context so we can
    draw it later */
    CGContextAddPath(context, path)
    
    /* Set the blue color as the stroke color */
    UIColor.blueColor().setStroke()
    
    /* Draw the path with stroke color */
    CGContextDrawPath(context, kCGPathStroke)
        
  }
  
}
