//
//  ViewController.swift
//  Grouping Compact Options with UISegmentedControl
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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var segmentedControl:UISegmentedControl!
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let segments = [
//      "iPhone",
//      "iPad",
//      "iPod",
//      "iMac"]
//    
//    segmentedControl = UISegmentedControl(items: segments)
//    segmentedControl.center = view.center
//    self.view.addSubview(segmentedControl)
//    
//  }
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var segmentedControl:UISegmentedControl!
//  
//  func segmentedControlValueChanged(sender: UISegmentedControl){
//    
//    let selectedSegmentIndex = sender.selectedSegmentIndex
//    
//    let selectedSegmentText =
//    sender.titleForSegmentAtIndex(selectedSegmentIndex)
//    
//    println("Segment \(selectedSegmentIndex) with text" +
//      " of \(selectedSegmentText) is selected")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let segments = [
//      "iPhone",
//      "iPad",
//      "iPod",
//      "iMac"]
//    
//    segmentedControl = UISegmentedControl(items: segments)
//    segmentedControl.center = view.center
//    
//    segmentedControl.addTarget(self,
//      action: "segmentedControlValueChanged:",
//      forControlEvents: .ValueChanged)
//    
//    self.view.addSubview(segmentedControl)
//    
//  }
//  
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var segmentedControl:UISegmentedControl!
//  
//  func segmentedControlValueChanged(sender: UISegmentedControl){
//    
//    let selectedSegmentIndex = sender.selectedSegmentIndex
//    
//    let selectedSegmentText =
//    sender.titleForSegmentAtIndex(selectedSegmentIndex)
//    
//    println("Segment \(selectedSegmentIndex) with text" +
//      " of \(selectedSegmentText) is selected")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let segments = [
//      "iPhone",
//      "iPad",
//      "iPod",
//      "iMac"]
//    
//    segmentedControl = UISegmentedControl(items: segments)
//    segmentedControl.center = view.center
//    segmentedControl.momentary = true
//    segmentedControl.addTarget(self,
//      action: "segmentedControlValueChanged:",
//      forControlEvents: .ValueChanged)
//    
//    self.view.addSubview(segmentedControl)
//    
//  }
//  
//}

/* 4 */
import UIKit

class ViewController: UIViewController {
  
  var segmentedControl:UISegmentedControl!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let segments = [
      "Red",
      UIImage(named: "blueDot")!,
      "Green",
      "Yellow"]
    
    segmentedControl = UISegmentedControl(items: segments)
    segmentedControl.center = view.center
    self.view.addSubview(segmentedControl)
    
  }
  
}

