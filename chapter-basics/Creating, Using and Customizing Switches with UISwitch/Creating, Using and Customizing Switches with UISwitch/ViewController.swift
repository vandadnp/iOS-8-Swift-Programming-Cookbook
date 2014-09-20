//
//  ViewController.swift
//  Creating, Using and Customizing Switches with UISwitch
//
//  Created by Vandad Nahavandipoor on 6/27/14.
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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var mainSwitch:UISwitch!
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var mainSwitch:UISwitch!
//  
//  func switchIsChanged(sender: UISwitch){
//    println("Sender is = \(sender)")
//    
//    if sender.on{
//      println("The switch is turned on")
//    } else {
//      println("The switch is turned off")
//    }
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    mainSwitch = UISwitch(frame: CGRect(x: 100, y: 100, width: 0, height: 0))
//    view.addSubview(mainSwitch!)
//    
////    if mainSwitch.on{
////      /* Switch is on */
////    } else {
////      /* Switch is off */
////    }
//    
//    mainSwitch.addTarget(self,
//      action: "switchIsChanged:",
//      forControlEvents: .ValueChanged)
//    
//  }
//  
//}

/* 3 */
import UIKit

class ViewController: UIViewController {
  
  var mainSwitch:UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainSwitch = UISwitch(frame: CGRect(x: 100, y: 100, width: 0, height: 0))
    
    /* Adjust the off-mode tint color */
    mainSwitch.tintColor = UIColor.redColor()
    /* Adjust the on-mode tint color */
    mainSwitch.onTintColor = UIColor.brownColor()
    /* Also change the knob's tint color */
    mainSwitch.thumbTintColor = UIColor.greenColor()
    
    view.addSubview(mainSwitch)
    
  }
  
}