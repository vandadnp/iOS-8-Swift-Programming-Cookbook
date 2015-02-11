//
//  MyAnnotation.swift
//  Displaying Custom Pins on a Map View
//
//  Created by Vandad Nahavandipoor on 7/8/14.
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
import MapKit

/* This will allow us to check for equality between two items
of type PinColor */
func == (left: PinColor, right: PinColor) -> Bool{
  return left.rawValue == right.rawValue
}

/* The various pin colors that our annotation can have */
enum PinColor : String{
  case Blue = "Blue"
  case Red = "Red"
  case Green = "Green"
  case Purple = "Purple"
  
  /* We will convert our pin color to the system pin color */
  func toPinColor() -> MKPinAnnotationColor{
    switch self{
    case .Red:
      return .Red
    case .Green:
      return .Green
    case .Purple:
      return .Purple
    default:
      /* For the blue pin, this will return .Red but we need
      to return *a* value in this function. For this case, we will
      ignore the return value */
      return .Red
    }
  }
}

class MyAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  var title: String!
  var subtitle: String!
  var pinColor: PinColor!
  
  init(coordinate: CLLocationCoordinate2D,
    title: String,
    subtitle: String,
    pinColor: PinColor){
      self.coordinate = coordinate
      self.title = title
      self.subtitle = subtitle
      self.pinColor = pinColor
      super.init()
  }
  
  convenience init(coordinate: CLLocationCoordinate2D,
    title: String,
    subtitle: String){
      self.init(coordinate: coordinate,
        title: title,
        subtitle: subtitle,
        pinColor: .Blue)
  }
  
}
