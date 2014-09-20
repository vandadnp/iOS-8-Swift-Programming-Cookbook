//
//  ViewController.swift
//  Displaying Static Text with UILabel
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
//  var label: UILabel!
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  var label: UILabel!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    label = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 23))
//    label.text = "iOS Programming Cookbook"
//    label.font = UIFont.boldSystemFontOfSize(14)
//    view.addSubview(label)
//    
//  }
//  
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController {
//  var label: UILabel!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    label = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 25))
//    label.text = "iOS Programming Cookbook"
//    label.font = UIFont.boldSystemFontOfSize(14)
//    view.addSubview(label)
//    
//  }
//  
//}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController {
//  var label: UILabel!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    label = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 70))
//    label.numberOfLines = 3
//    label.lineBreakMode = .ByWordWrapping
//    label.text = "iOS Programming Cookbook"
//    label.font = UIFont.boldSystemFontOfSize(14)
//    view.addSubview(label)
//    
//  }
//  
//}

/* 5 */
//import UIKit
//
//class ViewController: UIViewController {
//  var label: UILabel!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    label = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 23))
//    label.adjustsFontSizeToFitWidth = true
//    label.text = "iOS Programming Cookbook"
//    label.font = UIFont.boldSystemFontOfSize(14)
//    view.addSubview(label)
//    
//  }
//  
//}

/* 6 */
import UIKit

class ViewController: UIViewController {
  var label: UILabel!
  
  func attributedText() -> NSAttributedString{
    
    let string = "iOS SDK" as NSString
    
    let result = NSMutableAttributedString(string: string)
    
    let attributesForFirstWord = [
      NSFontAttributeName : UIFont.boldSystemFontOfSize(60),
      NSForegroundColorAttributeName : UIColor.redColor(),
      NSBackgroundColorAttributeName : UIColor.blackColor()
    ]
    
    let shadow = NSShadow()
    shadow.shadowColor = UIColor.darkGrayColor()
    shadow.shadowOffset = CGSize(width: 4, height: 4)
    
    let attributesForSecondWord = [
      NSFontAttributeName : UIFont.boldSystemFontOfSize(60),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSBackgroundColorAttributeName : UIColor.redColor(),
      NSShadowAttributeName : shadow,
    ]
    
    /* Find the string "iOS" in the whole string and sets its attribute */
    result.setAttributes(attributesForFirstWord,
      range: string.rangeOfString("iOS"))
    
    
    /* Do the same thing for the string "SDK" */
    result.setAttributes(attributesForSecondWord,
      range: string.rangeOfString("SDK"))
    
    return NSAttributedString(attributedString: result)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label = UILabel()
    label.backgroundColor = UIColor.clearColor()
    label.attributedText = attributedText()
    label.sizeToFit()
    label.center = CGPoint(x: view.center.x, y: 100)
    view.addSubview(label)
    
  }
  
}




