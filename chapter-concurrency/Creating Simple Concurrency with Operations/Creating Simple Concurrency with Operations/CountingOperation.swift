//
//  CountingOperation.swift
//  Creating Simple Concurrency with Operations
//
//  Created by Vandad Nahavandipoor on 7/3/14.
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

class CountingOperation: NSOperation {
  
  var startingCount: Int = 0
  var endingCount: Int = 0
  
  init(startCount: Int, endCount: Int){
    startingCount = startCount
    endingCount = endCount
  }
  
  convenience override init(){
    self.init(startCount: 0, endCount: 3)
  }
  
  override func main() {
    
    var isTaskFinished = false
    
    while isTaskFinished == false &&
      self.finished == false{
        for counter in startingCount..<endingCount{
          print("Count = \(counter)", appendNewline: false)
          print("Current thread = \(NSThread.currentThread())", appendNewline: false)
          print("Main thread = \(NSThread.mainThread())", appendNewline: false)
          print("---------------------------------", appendNewline: false)
        }
        
        isTaskFinished = true
    }
    
  }
   
}
