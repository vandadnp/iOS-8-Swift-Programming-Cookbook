//
//  ViewController.swift
//  Listening and Reacting to Keyboard Notifications
//
//  Created by Vandad Nahavandipoor on 7/11/14.
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

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func handleKeyboardWillShow(notification: NSNotification){
    
    let userInfo = notification.userInfo
    
    if let info = userInfo{
      /* Get the duration of the animation of the keyboard for when it
      gets displayed on the screen. We will animate our contents using
      the same animation duration */
      let animationDurationObject =
      info[UIKeyboardAnimationDurationUserInfoKey] as! NSValue
      
      let keyboardEndRectObject =
      info[UIKeyboardFrameEndUserInfoKey] as! NSValue
      
      var animationDuration = 0.0
      var keyboardEndRect = CGRectZero
      
      animationDurationObject.getValue(&animationDuration)
      keyboardEndRectObject.getValue(&keyboardEndRect)
      
      let window = UIApplication.sharedApplication().keyWindow
      
      /* Convert the frame from window's coordinate system to
      our view's coordinate system */
      keyboardEndRect = view.convertRect(keyboardEndRect, fromView: window)
      
      /* Find out how much of our view is being covered by the keyboard */
      let intersectionOfKeyboardRectAndWindowRect =
      CGRectIntersection(view.frame, keyboardEndRect);
      
      /* Scroll the scroll view up to show the full contents of our view */
      UIView.animateWithDuration(animationDuration, animations: {[weak self] in
        
        self!.scrollView.contentInset = UIEdgeInsets(top: 0,
          left: 0,
          bottom: intersectionOfKeyboardRectAndWindowRect.size.height,
          right: 0)
        
        self!.scrollView.scrollRectToVisible(self!.textField.frame,
          animated: false)
        
      })
    }
    
  }
  
  func handleKeyboardWillHide(sender: NSNotification){
    
    let userInfo = sender.userInfo
    
    if let info = userInfo{
      let animationDurationObject =
      info[UIKeyboardAnimationDurationUserInfoKey]
        as! NSValue
      
      var animationDuration = 0.0;
      
      animationDurationObject.getValue(&animationDuration)
      
      UIView.animateWithDuration(animationDuration, animations: {
        [weak self] in
        self!.scrollView.contentInset = UIEdgeInsetsZero
      })
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    let center = NSNotificationCenter.defaultCenter()
    
    center.addObserver(self,
      selector: "handleKeyboardWillShow:",
      name: UIKeyboardWillShowNotification,
      object: nil)
    
    center.addObserver(self,
      selector: "handleKeyboardWillHide:",
      name: UIKeyboardWillHideNotification,
      object: nil)
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
  }
  
}

