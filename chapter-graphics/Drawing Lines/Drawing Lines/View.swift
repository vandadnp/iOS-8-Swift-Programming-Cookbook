//
//  View.swift
//  Drawing Lines
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

////   1 
//  override func drawRect(rect: CGRect)
//  {
//    
//    /* Set the color that we want to use to draw the line */
//    UIColor.brownColor().set()
//    
//    /* Get the current graphics context */
//    let context = UIGraphicsGetCurrentContext()
//    
//    /* Set the width for the line */
//    CGContextSetLineWidth(context, 5)
//    
//    /* Start the line at this point */
//    CGContextMoveToPoint(context, 50, 10)
//    
//    /* And end it at this point */
//    CGContextAddLineToPoint(context, 100, 200)
//    
//    /* Use the context's current color to draw the line */
//    CGContextStrokePath(context)
//    
//  }
//  
////   2
//  override func drawRect(rect: CGRect) {
//    /* Set the color that we want to use to draw the line */
//    UIColor.brownColor().set()
//    
//    /* Get the current graphics context */
//    let context = UIGraphicsGetCurrentContext()
//    
//    /* Set the width for the line */
//    CGContextSetLineWidth(context, 5)
//    
//    /* Start the line at this point */
//    CGContextMoveToPoint(context, 50, 10)
//    
//    /* And end it at this point */
//    CGContextAddLineToPoint(context, 100, 100)
//    
//    /* Extend the line to another point */
//    CGContextAddLineToPoint(context, 300, 100);
//    
//    /* Use the context's current color to draw the line */
//    CGContextStrokePath(context)
//  }
  
  func drawRooftopAtTopPointOf(point: CGPoint,
    textToDisplay: NSString,
    lineJoin: CGLineJoin){
      
      /* Set the color that we want to use to draw the line */
      UIColor.brownColor().set()
      
      /* Set the color that we want to use to draw the line */
      let context = UIGraphicsGetCurrentContext()
      
      /* Set the line join */
      CGContextSetLineJoin(context, lineJoin)
      
      /* Set the width for the lines */
      CGContextSetLineWidth(context, 20)
      
      /* Start the line at this point */
      CGContextMoveToPoint(context, point.x - 140, point.y + 100)
      
      /* And end it at this point */
      CGContextAddLineToPoint(context, point.x, point.y)
      
      /* Extend the line to another point to make the rooftop */
      CGContextAddLineToPoint(context, point.x + 140, point.y + 100)
      
      /* Use the context's current color to draw the lines */
      CGContextStrokePath(context)
      
      /* Draw the text in the rooftop using a black color */
      UIColor.blackColor().set()
      
      /* Now draw the text */
      let drawingPoint = CGPoint(x: point.x - 40, y: point.y + 60)
      let font = UIFont.boldSystemFontOfSize(30)
      textToDisplay.drawAtPoint(drawingPoint,
        withAttributes: [NSFontAttributeName : font])
  }
  
  
  override func drawRect(rect: CGRect){
    
    drawRooftopAtTopPointOf(CGPoint(x: 160, y: 40),
      textToDisplay: "Miter",
      lineJoin: kCGLineJoinMiter)
    
    drawRooftopAtTopPointOf(CGPoint(x: 160, y: 180),
      textToDisplay: "Bevel",
      lineJoin: kCGLineJoinBevel)
    
    drawRooftopAtTopPointOf(CGPoint(x: 160, y: 320),
      textToDisplay: "Round",
      lineJoin: kCGLineJoinRound)
    
  }
  
}
