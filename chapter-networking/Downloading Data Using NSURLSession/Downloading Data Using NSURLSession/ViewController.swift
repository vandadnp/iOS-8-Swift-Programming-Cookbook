//
//  ViewController.swift
//  Downloading Data Using NSURLSession
//
//  Created by Vandad Nahavandipoor on 7/9/14.
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

extension NSURLSessionTask{
  func start(){
    self.resume()
  }
}

class ViewController: UIViewController , NSURLSessionDelegate,
NSURLSessionDataDelegate {
  
  /* Define our variables here */
  var session: NSURLSession!
  /* We will download a URL one chunk at a time and append the downloaded
  data to this mutable data */
  var mutableData: NSMutableData = NSMutableData()

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    /* Set up the url session */
    
    /* Create our configuration first */
    let configuration =
    NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.timeoutIntervalForRequest = 15.0
    
    /* Now create our session which will allow us to create the tasks */
    session = NSURLSession(configuration: configuration,
      delegate: self,
      delegateQueue: nil)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Now attempt to download the contents of the URL */
    let url = NSURL(string: "http://www.apple.com")
    
    let task = session.dataTaskWithURL(url, completionHandler: nil)
    
    task.start()
    
  }
  
  /* This method will get called on a random thread because
  we have not provided an operation queue to our session */
  func URLSession(session: NSURLSession!,
    dataTask: NSURLSessionDataTask!,
    didReceiveData data: NSData!) {
      
      data.enumerateByteRangesUsingBlock{[weak self]
        (pointer: UnsafePointer<()>,
        range: NSRange,
        stop: UnsafeMutablePointer<ObjCBool>) in
        let newData = NSData(bytes: pointer, length: range.length)
        self!.mutableData.appendData(newData)
      }
      
  }
  
  func URLSession(session: NSURLSession!,
    task: NSURLSessionTask!,
    didCompleteWithError error: NSError!){
      
      /* Now you have your data in the mutableData property */
      session.finishTasksAndInvalidate()
      
      dispatch_async(dispatch_get_main_queue(), {[weak self] in
        
        var message = "Finished downloading your content"
        
        if error != nil{
          message = "Failed to download your content"
        }
        
        self!.displayAlertWithTitle("Done", message: message)
        
      })
      
  }
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
}