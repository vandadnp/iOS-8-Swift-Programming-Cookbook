//
//  ViewController.swift
//  Displaying Long Lines of Text with UITextView
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
//  
//  var textView: UITextView?
//
//}
//
///* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var textView: UITextView?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    textView = UITextView(frame: view.bounds)
//    if let theTextView = textView{
//      theTextView.text = "Some text goes here..."
//      
//      theTextView.contentInset =
//        UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//      
//      theTextView.font = UIFont.systemFontOfSize(16)
//      view.addSubview(theTextView)
//    }
//    
//  }
//  
//}
//
///* 3 */
import UIKit

class ViewController: UIViewController {
  
  var textView: UITextView?
  
  let defaultContentInset =
  UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
  
  func handleKeyboardDidShow (notification: NSNotification){
  
    /* Get the frame of the keyboard */
    let keyboardRectAsObject =
    notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    
    /* Place it in a CGRect */
    var keyboardRect = CGRectZero
    
    keyboardRectAsObject.getValue(&keyboardRect)
  
    /* Give a bottom margin to our text view that makes it
    reach to the top of the keyboard */
    textView!.contentInset =
      UIEdgeInsets(top: defaultContentInset.top,
        left: 0, bottom: keyboardRect.height, right: 0)
  }
  
  func handleKeyboardWillHide(notification: NSNotification){
    textView!.contentInset = defaultContentInset
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView = UITextView(frame: view.bounds)
    if let theTextView = textView{
      theTextView.text = "Some text goes here..."
      theTextView.font = UIFont.systemFontOfSize(16)
      theTextView.contentInset = defaultContentInset
      
      view.addSubview(theTextView)
      
      NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "handleKeyboardDidShow:",
        name: UIKeyboardDidShowNotification,
        object: nil)
      
      
      NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "handleKeyboardWillHide:",
        name: UIKeyboardWillHideNotification,
        object: nil)
      
    }
    
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}