//
//  View.swift
//  Adding Shadows to Shapes
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
  
  /* 1 */
//  func drawRectAtTopOfScreen(){
//    /* Get the handle to the current context */
//    let currentContext = UIGraphicsGetCurrentContext()
//    
//    let offset = CGSizeMake(10, 10)
//    
//    CGContextSetShadowWithColor(currentContext,
//      offset,
//      20,
//      UIColor.grayColor().CGColor)
//    
//    /* Create the path first. Just the path handle. */
//    let path = CGPathCreateMutable()
//    
//    /* Here are our rectangle boundaries */
//    let firstRect = CGRect(x: 55, y: 60, width: 150, height: 150)
//    
//    /* Add the rectangle to the path */
//    CGPathAddRect(path, nil, firstRect)
//    
//    /* Add the path to the context */
//    CGContextAddPath(currentContext, path)
//    
//    /* Set the fill color to cornflower blue */
//    UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
//    
//    /* Fill the path on the context */
//    CGContextDrawPath(currentContext, kCGPathFill)
//  }
  
  /* 2 */
  func drawRectAtTopOfScreen(){
    /* Get the handle to the current context */
    let currentContext = UIGraphicsGetCurrentContext()
    
    CGContextSaveGState(currentContext)
    
    let offset = CGSizeMake(10, 10)
    
    CGContextSetShadowWithColor(currentContext,
      offset,
      20,
      UIColor.grayColor().CGColor)
    
    /* Create the path first. Just the path handle. */
    let path = CGPathCreateMutable()
    
    /* Here are our rectangle boundaries */
    let firstRect = CGRect(x: 55, y: 60, width: 150, height: 150)
    
    /* Add the rectangle to the path */
    CGPathAddRect(path, nil, firstRect)
    
    /* Add the path to the context */
    CGContextAddPath(currentContext, path)
    
    /* Set the fill color to cornflower blue */
    UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
    
    /* Fill the path on the context */
    CGContextDrawPath(currentContext, kCGPathFill)
    
    /* Restore the context to how it was when we started */
    CGContextRestoreGState(currentContext)
  }
  
  func drawRectAtBottomOfScreen(){
    /* Get the handle to the current context */
    let currentContext = UIGraphicsGetCurrentContext()
    
    let secondPath = CGPathCreateMutable()
    
    let secondRect = CGRect(x: 150, y: 250, width: 100, height: 100)
    
    CGPathAddRect(secondPath, nil, secondRect)
    
    CGContextAddPath(currentContext, secondPath)
    
    UIColor.purpleColor().setFill()
    
    CGContextDrawPath(currentContext, kCGPathFill)

  }
  
  override func drawRect(rect: CGRect) {
    drawRectAtTopOfScreen()
    drawRectAtBottomOfScreen()
  }
  
}
