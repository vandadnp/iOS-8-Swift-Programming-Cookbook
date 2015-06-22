//
//  ViewController.swift
//  Creating Scrollable Content with UIScrollView
//
//  Created by Vandad Nahavandipoor on 6/29/14.
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
//  var imageView: UIImageView!
//  var scrollView: UIScrollView!
//  let image = UIImage(named: "Safari")
//}
//
///* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  var imageView: UIImageView!
//  var scrollView: UIScrollView!
//  let image = UIImage(named: "Safari")
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    imageView = UIImageView(image: image)
//    scrollView = UIScrollView(frame: view.bounds)
//
//    scrollView.addSubview(imageView)
//    scrollView.contentSize = imageView.bounds.size
//    view.addSubview(scrollView)
//    
//  }
//  
//}
//
///* 3 */
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
  var imageView: UIImageView!
  var scrollView: UIScrollView!
  let image = UIImage(named: "Safari")
  
  func scrollViewDidScroll(scrollView: UIScrollView){
  /* Gets called when user scrolls or drags */
    scrollView.alpha = 0.50
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView){
  /* Gets called only after scrolling */
    scrollView.alpha = 1
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView,
    willDecelerate decelerate: Bool){
      scrollView.alpha = 1
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView = UIImageView(image: image)
    scrollView = UIScrollView(frame: view.bounds)
    
    scrollView.addSubview(imageView)
    scrollView.contentSize = imageView.bounds.size
    scrollView.delegate = self
    scrollView.indicatorStyle = .White
    view.addSubview(scrollView)
    
  }
  
}