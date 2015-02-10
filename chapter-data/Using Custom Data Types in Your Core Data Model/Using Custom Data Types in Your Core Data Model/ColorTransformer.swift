//
//  ColorTransformer.swift
//  Using Custom Data Types in Your Core Data Model
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

class ColorTransformer: NSValueTransformer {
  
  override class func allowsReverseTransformation() -> Bool{
    return true
  }
  
  override class func transformedValueClass() -> AnyClass{
    return NSData.classForCoder()
  }
  
  override func transformedValue(value: AnyObject!) -> AnyObject {
    
    /* Transform color to data */
    
    let color = value as! UIColor
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    var components = [red, green, blue, alpha]
    let dataFromColors = NSData(bytes: components,
      length: sizeofValue(components))
    
    return dataFromColors
    
  }
  
  override func reverseTransformedValue(value: AnyObject!) -> AnyObject {
    
    /* Transform data to color */
    let data = value as! NSData
    var components = [CGFloat](count: 4, repeatedValue: 0.0)
    data.getBytes(&components, length: sizeofValue(components))
    
    let color = UIColor(red: components[0],
      green: components[1],
      blue: components[2],
      alpha: components[3])
    
    return color
    
  }
  
}
