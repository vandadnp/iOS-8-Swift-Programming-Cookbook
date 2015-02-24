//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by vandad on 217//14.
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
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController,
AudienceSelectionViewControllerDelegate, NSURLSessionDelegate {
  
  var imageData: NSData?
  
  func audienceSelectionViewController(sender: AudienceSelectionViewController,
    selectedValue: String) {
      audienceConfigurationItem.value = selectedValue
      popConfigurationViewController()
  }
  
  func showAudienceSelection(){
    let controller = AudienceSelectionViewController(style: .Plain)
    controller.audience = audienceConfigurationItem.value
    controller.delegate = self
    pushConfigurationViewController(controller)
  }
  
  override func isContentValid() -> Bool {
    /* The post button should be enabled only if we have the image data
    and the user has entered at least one character of text */
    if let data = imageData{
      if count(contentText) > 0{
        return true
      }
    }
    
    return false
  }
  
  override func presentationAnimationDidFinish() {
    super.presentationAnimationDidFinish()
    
    placeholder = "Your comments"
    
    let content = extensionContext!.inputItems[0] as! NSExtensionItem
    let contentType = kUTTypeImage as! String
    
    for attachment in content.attachments as! [NSItemProvider]{
      if attachment.hasItemConformingToTypeIdentifier(contentType){
        
        let dispatchQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(dispatchQueue, {[weak self] in
          
          let strongSelf = self!
          
          attachment.loadItemForTypeIdentifier(contentType,
            options: nil,
            completionHandler: {(content: NSSecureCoding!, error: NSError!) in
              if let data = content as? NSData{
                dispatch_async(dispatch_get_main_queue(), {
                  strongSelf.imageData = data
                  strongSelf.validateContent()
                  })
              }
            })
          
          })
        
      }
      
      break
    }
    
  }
  
  override func didSelectPost() {
    
    let identifier = NSBundle.mainBundle().bundleIdentifier! + "." +
      NSUUID().UUIDString
    
    let configuration =
    NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
      identifier)
    
    let session = NSURLSession(configuration: configuration,
      delegate: self,
      delegateQueue: nil)
    
    let url = NSURL(string: "https://<# your url goes here#>/&text=" +
      self.contentText)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = imageData!
    
    let task = session.uploadTaskWithRequest(request,
      fromData: request.HTTPBody)
    
    task.resume()
    
    extensionContext!.completeRequestReturningItems([], completionHandler: nil)
  }
  
  lazy var audienceConfigurationItem: SLComposeSheetConfigurationItem = {
    let item = SLComposeSheetConfigurationItem()
    item.title = "Audience"
    item.value = AudienceSelectionViewController.defaultAudience()
    item.tapHandler = self.showAudienceSelection
    return item
    }()
  
  override func configurationItems() -> [AnyObject]! {
    return [audienceConfigurationItem]
  }
  
}
