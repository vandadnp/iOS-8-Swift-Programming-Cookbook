//
//  ViewController.swift
//  Adding Buttons to the User Interface with UIButton
//
//  Created by Vandad Nahavandipoor on 6/26/14.
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
//  var button: UIButton!
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  var button: UIButton!
//  
//  func buttonIsPressed(sender: UIButton){
//    println("Button is pressed.")
//  }
//  
//  func buttonIsTapped(sender: UIButton){
//    println("Button is tapped.")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    button = UIButton.buttonWithType(.System) as? UIButton
//    
//    button.frame = CGRect(x: 110, y: 70, width: 100, height: 44)
//    
//    button.setTitle("Press Me", forState: .Normal)
//    button.setTitle("I'm Pressed", forState: .Highlighted)
//    
//    button.addTarget(self,
//      action: "buttonIsPressed:",
//      forControlEvents: .TouchDown)
//    
//    button.addTarget(self,
//      action: "buttonIsTapped:",
//      forControlEvents: .TouchUpInside)
//    
//    view.addSubview(button)
//    
//  }
//}

/* 3 */
import UIKit

class ViewController: UIViewController {
  var button: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let normalImage = UIImage(named: "NormalBlueButton")
    let highlightedImage = UIImage(named: "HighlightedBlueButton")
    
    button = UIButton.buttonWithType(.Custom) as? UIButton
    button.frame = CGRect(x: 110, y: 70, width: 100, height: 44)
    
    button.setTitle("Normal", forState: .Normal)
    button.setTitle("Pressed", forState: .Highlighted)
    
    button.setBackgroundImage(normalImage, forState: .Normal)
    button.setBackgroundImage(highlightedImage, forState: .Highlighted)
    
    view.addSubview(button)
    
  }
}

