//
//  ViewController.swift
//  Implementing Range Pickers with UISlider
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
//  var slider: UISlider!
//                            
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 23))
//    slider.center = view.center
//    slider.minimumValue = 0
//    slider.maximumValue = 100
//    slider.value = slider!.maximumValue / 2.0
//    view.addSubview(slider)
//    
//  }
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var slider: UISlider!
//  
//  func sliderValueChanged(slider: UISlider){
//    println("Slider's new value is \(slider.value)")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 23))
//    slider.center = view.center
//    slider.minimumValue = 0
//    slider.maximumValue = 100
//    slider.value = slider!.maximumValue / 2.0
//    
//    slider.addTarget(self,
//      action: "sliderValueChanged:",
//      forControlEvents: .ValueChanged)
//    
//    view.addSubview(slider)
//    
//  }
//  
//}

/* 3 */
import UIKit

class ViewController: UIViewController {
  
  var slider: UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 23))
    slider.center = view.center
    slider.minimumValue = 0
    slider.maximumValue = 100
    slider.value = slider!.maximumValue / 2.0
    
    slider.setThumbImage(UIImage(named: "ThumbNormal"), forState: .Normal)
    slider.setThumbImage(UIImage(named: "ThumbHighlighted"), forState: .Highlighted)
    
    view.addSubview(slider)
    
  }
  
}