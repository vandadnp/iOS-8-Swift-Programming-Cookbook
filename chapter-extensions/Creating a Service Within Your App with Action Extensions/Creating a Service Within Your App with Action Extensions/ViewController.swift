//
//  ViewController.swift
//  Creating a Service Within Your App with Action Extensions
//
//  Created by Vandad Nahavandipoor on 7/27/14.
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
import MobileCoreServices

class ViewController: UIViewController {
  
  @IBOutlet weak var textField: UITextField!
  let type = kUTTypeText as NSString as String
  
  func activityCompletionHandler(activityType: String?,
    completed: Bool,
    returnedItems: [AnyObject]?,
    activityError: NSError?){
      
      if completed && activityError == nil{
        
        let item = returnedItems?[0] as! NSExtensionItem
        
        if let attachments = item.attachments{
          
          let attachment = attachments[0] as! NSItemProvider
          
          if attachment.hasItemConformingToTypeIdentifier(type){
            attachment.loadItemForTypeIdentifier(type, options: nil,
              completionHandler:{
                (item: NSSecureCoding?, error: NSError?) in
                
                if let error = error{
                  self.textField.text = "\(error)"
                } else if let value = item as? String{
                  self.textField.text = value
                }
                
            })
          }
          
        }
        
      }
    
  }
  
  @IBAction func performShare(){
    let controller = UIActivityViewController(activityItems: [textField.text!],
      applicationActivities: nil)
    controller.completionWithItemsHandler = activityCompletionHandler
    presentViewController(controller, animated: true, completion: nil)
  }

}

