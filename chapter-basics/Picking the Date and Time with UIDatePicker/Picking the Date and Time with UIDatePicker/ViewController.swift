//
//  ViewController.swift
//  Picking the Date and Time with UIDatePicker
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

//import UIKit
//
//class ViewController: UIViewController {
//
//  var datePicker: UIDatePicker!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    datePicker = UIDatePicker()
//    datePicker.center = view.center
//    view.addSubview(datePicker)
//    
//  }
//
//}
//
///* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var datePicker: UIDatePicker!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    datePicker = UIDatePicker()
//    datePicker.center = view.center
//    view.addSubview(datePicker)
//    
//    let currentDate = datePicker.date
//    print(currentDate)
//    
//  }
//  
//}
//
///* 3 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var datePicker: UIDatePicker!
//  
//  func datePickerDateChanged(datePicker: UIDatePicker){
//    print("Selected date = \(datePicker.date)")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    datePicker = UIDatePicker()
//    datePicker.center = view.center
//    view.addSubview(datePicker)
//    
//    datePicker.addTarget(self,
//      action: "datePickerDateChanged:",
//      forControlEvents: .ValueChanged)
//    
//  }
//  
//}
//
///* 4 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var datePicker: UIDatePicker!
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    datePicker = UIDatePicker()
//    datePicker.center = view.center
//    view.addSubview(datePicker)
//    
//    let oneYearTime:NSTimeInterval = 365 * 24 * 60 * 60
//    let todayDate = NSDate()
//    
//    let oneYearFromToday = todayDate.dateByAddingTimeInterval(oneYearTime)
//    
//    let twoYearsFromToday = todayDate.dateByAddingTimeInterval(2 * oneYearTime)
//    
//    datePicker.minimumDate = oneYearFromToday
//    datePicker.maximumDate = twoYearsFromToday
//    
//  }
//  
//}
//
///* 5 */
import UIKit

class ViewController: UIViewController {
  
  var datePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datePicker = UIDatePicker()
    datePicker.center = view.center
    datePicker.datePickerMode = .CountDownTimer
    let twoMinutes = (2 * 60) as NSTimeInterval
    datePicker.countDownDuration = twoMinutes
    view.addSubview(datePicker)
    
  }
  
}

