//
//  ViewController.swift
//  Creating Dependency Between Operations
//
//  Created by Vandad Nahavandipoor on 7/6/14.
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

class ViewController: UIViewController {
  
  func performWorkForParameter(param: AnyObject?, operationName: String){
    if let theParam: AnyObject = param{
      print("First operation - Object = \(theParam)")
    }
    
    print("\(operationName) Operation - " +
      "Main Thread = \(NSThread.mainThread())")
    
    print("\(operationName) Operation - " +
      "Current Thread = \(NSThread.currentThread())")
  }
  
  func firstOperationEntry(param: AnyObject?){
    performWorkForParameter(param, operationName: "First")
  }
  
  func secondOperationEntry(param: AnyObject?){
    
    performWorkForParameter(param, operationName: "Second")
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let firstNumber = 111
    let secondNumber = 222
    
    let firstOperation = NSBlockOperation {[weak self] () -> Void in
      if let strongSelf = self{
        strongSelf.firstOperationEntry(firstNumber)
      }
    }
    
    let secondOperation = NSBlockOperation {[weak self] () -> Void in
      if let strongSelf = self{
        strongSelf.secondOperationEntry(secondNumber)
      }
    }
    
    let operationQueue = NSOperationQueue()
    
    firstOperation.addDependency(secondOperation)
    
    operationQueue.addOperation(firstOperation)
    operationQueue.addOperation(secondOperation)
    
    print("Main thread is here")
    
  }

}

