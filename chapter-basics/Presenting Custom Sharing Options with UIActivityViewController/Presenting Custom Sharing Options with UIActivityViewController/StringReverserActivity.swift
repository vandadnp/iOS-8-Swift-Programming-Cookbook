//
//  StringReverserActivity.swift
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

class StringReverserActivity: UIActivity {

  /*
  This will aggregate all the activity items that are acceptable by us.
  We will be passed an array of various class types and we will go through
  them all and only select the string items and put them in this array
  */
  var activityItems = [NSString]()
  
  func reverseOfString(string: NSString) -> NSString{
    
    var result = ""
    var characters = [Character]()
    
    for character in string as String{
      characters.append(character)
    }
    
    for character in characters.reverse(){
      result += "\(character)"
    }
    
    return result
  
  }
  
  override func performActivity() {
    
    var reversedStrings = ""
    
    for string in activityItems{
      reversedStrings += reverseOfString(string) + "\n"
    }
    
    /* Do whatever that you need to do, with all these
    reversed strings */
    println(reversedStrings)
    
  }
  
  override func activityType() -> String! {
    return NSBundle.mainBundle().bundleIdentifier! + ".StringReverserActivity"
  }
  
  override func activityTitle() -> String! {
    return "Reverse String"
  }
  
  override func activityImage() -> UIImage! {
    return UIImage(named: "Reverse")
  }
  
  override func canPerformWithActivityItems(
    activityItems: [AnyObject]!) -> Bool {
      
      for object:AnyObject in activityItems{
        if object is NSString{
          return true
        }
      }
    
      return false
      
  }
  
  override func prepareWithActivityItems(paramActivityItems: [AnyObject]!) {
    
    for object:AnyObject in paramActivityItems{
      if object is NSString{
        activityItems.append(object as NSString)
      }
    }
    
  }
   
}
