//
//  ViewController.swift
//  Presenting Sharing Options with UIActivityViewController
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
//class ViewController: UIViewController, UITextFieldDelegate {
//  
//  var textField:UITextField!
//  var buttonShare:UIButton!
//  
//  func createTextField(){
//    textField = UITextField(frame:
//      CGRect(x: 20, y: 35, width: 280, height: 30))
//    textField.borderStyle = .RoundedRect;
//    textField.placeholder = "Enter text to share..."
//    textField.delegate = self
//    view.addSubview(textField)
//  }
//  
//  func createButton(){
//    buttonShare = UIButton.buttonWithType(.System) as? UIButton
//    buttonShare.frame = CGRect(x: 20, y: 80, width: 280, height: 44)
//    buttonShare.setTitle("Share", forState:.Normal)
//    
//    buttonShare.addTarget(self,
//      action:"handleShare:",
//      forControlEvents:.TouchUpInside)
//    
//    view.addSubview(buttonShare)
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    createTextField()
//    createButton()
//  }
//  
//}

/* 2 */
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  var textField:UITextField!
  var buttonShare:UIButton!
  var activityViewController:UIActivityViewController!
  
  func handleShare(sender: UIButton){
  
    if (textField.text.isEmpty){
      let message = "Please enter a text and then press Share"
      
      let alertController = UIAlertController(title: nil,
        message: message,
        preferredStyle: .Alert)
      
      alertController.addAction(
        UIAlertAction(title: "OK", style: .Default, handler: nil))
      
      presentViewController(alertController, animated: true, completion: nil)
      
      return
    }
    
    /* it is VERY important to cast your strings to NSString
    otherwise the controller cannot display the appropriate sharing options */
    activityViewController = UIActivityViewController(
      activityItems: [textField.text as NSString],
      applicationActivities: nil)
    
    presentViewController(activityViewController,
      animated: true,
      completion: {
      })
  }
  
  func textFieldShouldReturn(textField: UITextField!) -> Bool{
    textField.resignFirstResponder()
    return true
  }
  
  func createTextField(){
    textField = UITextField(frame:
      CGRect(x: 20, y: 35, width: 280, height: 30))
    textField.borderStyle = .RoundedRect;
    textField.placeholder = "Enter text to share..."
    textField.delegate = self
    view.addSubview(textField)
  }
  
  func createButton(){
    buttonShare = UIButton.buttonWithType(.System) as? UIButton
    buttonShare.frame = CGRect(x: 20, y: 80, width: 280, height: 44)
    buttonShare.setTitle("Share", forState:.Normal)
    
    buttonShare.addTarget(self,
      action:"handleShare:",
      forControlEvents:.TouchUpInside)
    
    view.addSubview(buttonShare)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createTextField()
    createButton()
  }
  
}
