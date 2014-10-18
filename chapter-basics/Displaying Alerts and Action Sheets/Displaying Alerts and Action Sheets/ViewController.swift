//
//  ViewController.swift
//  Displaying Alerts and Action Sheets
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
//  var controller:UIAlertController?
//  
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var controller:UIAlertController?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    controller = UIAlertController(title: "Title",
//      message: "Message",
//      preferredStyle: .Alert)
//    
//    let action = UIAlertAction(title: "Done",
//      style: UIAlertActionStyle.Default,
//      handler: {(paramAction:UIAlertAction!) in
//      println("The Done button was tapped")
//      })
//    
//    controller!.addAction(action)
//    
//  }
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    self.presentViewController(controller!, animated: true, completion: nil)
//  }
//
//}

/* 3 */
import UIKit

class ViewController: UIViewController {
  
  var controller:UIAlertController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    controller = UIAlertController(title: "Please enter your username",
      message: "This is usually 10 characters long",
      preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "Next",
      style: UIAlertActionStyle.Default,
      handler: {[weak self] (paramAction:UIAlertAction!) in
        
        if let textFields = self!.controller?.textFields{
          let theTextFields = textFields as [UITextField]
          let userName = theTextFields[0].text
          println("Your username is \(userName)")
        }
        
      })
    
    controller!.addAction(action)
    
    controller!.addTextFieldWithConfigurationHandler(
      {(textField: UITextField!) in
        textField.placeholder = "XXXXXXXXXX"
      })
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.presentViewController(controller!, animated: true, completion: nil)
  }
  
}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var controller:UIAlertController?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    controller = UIAlertController(
//      title: "Choose how you would like to share this photo",
//      message: "You cannot bring back a deleted photo",
//      preferredStyle: .ActionSheet)
//    
//    let actionEmail = UIAlertAction(title: "Via email",
//      style: UIAlertActionStyle.Default,
//      handler: {(paramAction:UIAlertAction!) in
//        /* Send the photo via email */
//      })
//    
//    let actionImessage = UIAlertAction(title: "Via iMessage",
//      style: UIAlertActionStyle.Default,
//      handler: {(paramAction:UIAlertAction!) in
//        /* Send the photo via iMessage */
//      })
//    
//    let actionDelete = UIAlertAction(title: "Delete photo",
//      style: UIAlertActionStyle.Destructive,
//      handler: {(paramAction:UIAlertAction!) in
//        /* Delete the photo here */
//      })
//    
//    controller!.addAction(actionEmail)
//    controller!.addAction(actionImessage)
//    controller!.addAction(actionDelete)
//    
//  }
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    self.presentViewController(controller!, animated: true, completion: nil)
//  }
//  
//}


