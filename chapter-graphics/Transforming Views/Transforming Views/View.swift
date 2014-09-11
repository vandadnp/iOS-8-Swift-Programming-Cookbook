//
//  View.swift
//  Transforming Views
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
//  override func drawRect(rect: CGRect) {
//    
//    /* Create the path first. Just the path handle. */
//    let path = CGPathCreateMutable()
//    
//    /* Here are our rectangle boundaries */
//    let rectangle = CGRect(x: 10, y: 30, width: 200, height: 300)
//    
//    /* We want to displace the rectangle to the right by
//    100 points but want to keep the y position
//    untouched */
//    var transform = CGAffineTransformMakeTranslation(100, 0)
//    
//    /* Add the rectangle to the path */
//    CGPathAddRect(path, &transform, rectangle)
//    
//    /* Get the handle to the current context */
//    let currentContext = UIGraphicsGetCurrentContext()
//    
//    /* Add the path to the context */
//    CGContextAddPath(currentContext, path)
//    
//    /* Set the fill color to cornflower blue */
//    UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
//    
//    /* Set the stroke color to brown */
//    UIColor.brownColor().setStroke()
//    
//    /* Set the line width (for the stroke) to 5 */
//    CGContextSetLineWidth(currentContext, 5)
//    
//    /* Stroke and fill the path on the context */
//    CGContextDrawPath(currentContext, kCGPathFillStroke)
//    
//  }
  
  /* 2 */
//  override func drawRect(rect: CGRect) {
//    
//    /* Create the path first. Just the path handle. */
//    let path = CGPathCreateMutable()
//    
//    /* Here are our rectangle boundaries */
//    let rectangle = CGRect(x: 10, y: 30, width: 200, height: 300)
//    
//    /* Add the rectangle to the path */
//    CGPathAddRect(path, nil, rectangle)
//    
//    /* Get the handle to the current context */
//    let currentContext = UIGraphicsGetCurrentContext()
//    
//    /* Save the state of the context to revert
//    back to how it was at this state, later */
//    CGContextSaveGState(currentContext);
//    
//    /* Translate the current transformation matrix
//    to the right by 100 points */
//    CGContextTranslateCTM(currentContext, 100, 0)
//    
//    /* Add the path to the context */
//    CGContextAddPath(currentContext, path)
//    
//    /* Set the fill color to cornflower blue */
//    UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
//    
//    /* Set the stroke color to brown */
//    UIColor.brownColor().setStroke()
//    
//    /* Set the line width (for the stroke) to 5 */
//    CGContextSetLineWidth(currentContext, 5)
//    
//    /* Stroke and fill the path on the context */
//    CGContextDrawPath(currentContext, kCGPathFillStroke)
//    
//    /* Restore the state of the context */
//    CGContextRestoreGState(currentContext)
//    
//  }
  
  override func drawRect(rect: CGRect) {
    
    /* Create the path first. Just the path handle. */
    let path = CGPathCreateMutable()
    
    /* Here are our rectangle boundaries */
    let rectangle = CGRect(x: 10, y: 30, width: 200, height: 300)
    
    /* Add the rectangle to the path */
    CGPathAddRect(path, nil, rectangle)
    
    /* Get the handle to the current context */
    let currentContext = UIGraphicsGetCurrentContext()
    
    /* Scale everything drawn on the current
    graphics context to half its size */
    CGContextScaleCTM(currentContext, 0.5, 0.5)
    
    /* Add the path to the context */
    CGContextAddPath(currentContext, path)
    
    /* Set the fill color to cornflower blue */
    UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
    
    /* Set the stroke color to brown */
    UIColor.brownColor().setStroke()
    
    /* Set the line width (for the stroke) to 5 */
    CGContextSetLineWidth(currentContext, 5)
    
    /* Stroke and fill the path on the context */
    CGContextDrawPath(currentContext, kCGPathFillStroke)
    
  }

}
