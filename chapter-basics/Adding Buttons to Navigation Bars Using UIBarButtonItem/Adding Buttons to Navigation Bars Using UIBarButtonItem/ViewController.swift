//
//  ViewController.swift
//  Adding Buttons to Navigation Bars Using UIBarButtonItem
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
//  func performAdd(sender: UIBarButtonItem){
//    println("Add method got called")
//  }
//                            
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    navigationItem.rightBarButtonItem = UIBarButtonItem(
//      title: "Add",
//      style: .Plain,
//      target: self,
//      action: "performAdd:")
//    
//  }
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  func performAdd(sender: UIBarButtonItem){
//    println("Add method got called")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    navigationItem.rightBarButtonItem = UIBarButtonItem(
//      barButtonSystemItem: .Add,
//      target: self,
//      action: "performAdd:")
//    
//  }
//  
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  func switchIsChanged(sender: UISwitch){
//    if sender.on{
//      println("Switch is on")
//    } else {
//      println("Switch is off")
//    }
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let simpleSwitch = UISwitch()
//    simpleSwitch.on = true
//    
//    simpleSwitch.addTarget(self,
//      action: "switchIsChanged:",
//      forControlEvents: .ValueChanged)
//    
//    self.navigationItem.rightBarButtonItem =
//      UIBarButtonItem(customView: simpleSwitch)
//
//  }
//
//}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  let items = ["Up", "Down"]
//  
//  func segmentedControlTapped(sender: UISegmentedControl){
//    
//    if sender.selectedSegmentIndex < items.count{
//      println(items[sender.selectedSegmentIndex])
//    } else {
//      println("Unknown button is pressed")
//    }
//    
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let segmentedControl = UISegmentedControl(items: items)
//    segmentedControl.momentary = true
//    
//    segmentedControl.addTarget(self,
//      action: "segmentedControlTapped:",
//      forControlEvents: .ValueChanged)
//    
//    navigationItem.rightBarButtonItem =
//      UIBarButtonItem(customView: segmentedControl)
//    
//  }
//  
//}

/* 5 */
import UIKit

class ViewController: UIViewController {
  
  let items = ["Up", "Down"]
  
  override func viewDidAppear(animated: Bool){
    super.viewDidAppear(animated)
    
    let segmentedControl = UISegmentedControl(items: items)
    
let rightBarButton =
UIBarButtonItem(customView:segmentedControl)

navigationItem.setRightBarButtonItem(rightBarButton, animated: true)
    
  }
  
}