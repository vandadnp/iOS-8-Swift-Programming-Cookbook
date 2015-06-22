//
//  ActionViewController.swift
//  UppercaseExtension
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

class ActionViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  let type = kUTTypeText as NSString as String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for item in extensionContext!.inputItems as! [NSExtensionItem]{
      for provider in item.attachments as! [NSItemProvider]{
        if provider.hasItemConformingToTypeIdentifier(type){
          provider.loadItemForTypeIdentifier(type, options: nil,
            completionHandler: {
              (item: NSSecureCoding?, error: NSError?) in
              
              if let error = error{
                self.textView.text = "\(error)"
              } else if let loadedItem = item as? String{
                self.textView.text = loadedItem.uppercaseString
              }
              
          })
        }
      }
    }
    
  }
  
  @IBAction func cancel(){
    let userInfo = [NSLocalizedDescriptionKey : "User cancelled"]
    let error = NSError(domain: "Extension", code: -1, userInfo: userInfo)
    extensionContext!.cancelRequestWithError(error)
  }
  
  @IBAction func done() {
    
    let extensionItem = NSExtensionItem()
    let text = textView.text as NSString
    let itemProvider = NSItemProvider(item: text,
      typeIdentifier: type)
    extensionItem.attachments = [itemProvider]
    let itemsToShare = [extensionItem]
    
    extensionContext!.completeRequestReturningItems(itemsToShare,
      completionHandler: nil)
  }
  
}
