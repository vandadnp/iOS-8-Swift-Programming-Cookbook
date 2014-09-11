//
//  ViewController.swift
//  Picking Values with the UIPickerView
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
//  var picker: UIPickerView?
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var picker: UIPickerView?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    picker = UIPickerView()
//    picker!.center = view.center
//    view.addSubview(picker!)
//  }
//  
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController, UIPickerViewDataSource {
//  
//  var picker: UIPickerView?
//  
//  func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
//    if pickerView == picker{
//      return 1
//    }
//    return 0
//  }
//  
//  func pickerView(pickerView: UIPickerView!,
//    numberOfRowsInComponent component: Int) -> Int {
//    if pickerView == picker{
//      return 10
//    }
//    return 0
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    picker = UIPickerView()
//    picker!.dataSource = self
//    picker!.center = view.center
//    view.addSubview(picker!)
//  }
//  
//}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController,
//UIPickerViewDataSource, UIPickerViewDelegate {
//  
//  var picker: UIPickerView?
//  
//  func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
//    if pickerView == picker{
//      return 1
//    }
//    return 0
//  }
//  
//  func pickerView(pickerView: UIPickerView!,
//    numberOfRowsInComponent component: Int) -> Int {
//      if pickerView == picker{
//        return 10
//      }
//      return 0
//  }
//
//  func pickerView(pickerView: UIPickerView!,
//    titleForRow row: Int,
//    forComponent component: Int) -> String!{
//    return "\(row + 1)"
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    picker = UIPickerView()
//    picker!.dataSource = self
//    picker!.delegate = self
//    picker!.center = view.center
//    view.addSubview(picker!)
//  }
//  
//}

/* 5 */
import UIKit

class ViewController: UIViewController,
UIPickerViewDataSource, UIPickerViewDelegate {
  
  var picker: UIPickerView?
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
    if pickerView == picker{
      return 1
    }
    return 0
  }
  
  func pickerView(pickerView: UIPickerView!,
    numberOfRowsInComponent component: Int) -> Int {
      if pickerView == picker{
        return 10
      }
      return 0
  }
  
  func pickerView(pickerView: UIPickerView!,
    titleForRow row: Int,
    forComponent component: Int) -> String!{
      return "\(row + 1)"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    picker = UIPickerView()
    picker!.dataSource = self
    picker!.delegate = self
    picker!.center = view.center
    view.addSubview(picker!)
  }
  
}