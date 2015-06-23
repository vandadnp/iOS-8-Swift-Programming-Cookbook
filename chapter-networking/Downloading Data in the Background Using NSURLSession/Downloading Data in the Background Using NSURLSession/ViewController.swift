//
//  ViewController.swift
//  Downloading Data in the Background Using NSURLSession
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

class ViewController: UIViewController, NSURLSessionDelegate,
NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate {
  
  var session: NSURLSession!
  
  /* This computed property will generate a unique identifier for our
  background session configuration. The first time it is used, it will get
  the current date and time and will return that as a string to you. It will
  also save that string into the system defaults so that it can retrieve
  it the next time it is called. This computed property's value
  is persistent between launches of this app
  */
  var configurationIdentifier: String{
  let userDefaults = NSUserDefaults.standardUserDefaults()
    /* designate a key that makes sense to your app */
    let key = "configurationIdentifier"
    let previousValue = userDefaults.stringForKey(key) as String?
    
    if let thePreviousValue = previousValue{
      return thePreviousValue
    } else {
      let newValue = NSDate().description
      userDefaults.setObject(newValue, forKey: key)
      userDefaults.synchronize()
      return newValue
    }
  }
  
  func URLSession(session: NSURLSession,
    downloadTask: NSURLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
    totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64){
      print("Received data")
  }
  
  func URLSession(session: NSURLSession,
    downloadTask: NSURLSessionDownloadTask,
    didFinishDownloadingToURL location: NSURL){
      print("Finished writing the downloaded content to URL = \(location)")
  }
  
  /* We now get to know that the download procedure was finished */
  func URLSession(session: NSURLSession, task: NSURLSessionTask,
    didCompleteWithError error: NSError?){
    
      print("Finished ")
      
      if error == nil{
        print("without an error")
      } else {
        print("with an error = \(error)")
      }
      
      /* Release the delegate */
      session.finishTasksAndInvalidate()
      
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    /* Create our configuration first */
    let configuration =
    NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
      configurationIdentifier)
    
    configuration.timeoutIntervalForRequest = 15.0
    
    /* Now create our session which will allow us to create the tasks */
    session = NSURLSession(configuration: configuration,
      delegate: self,
      delegateQueue: nil)
    
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
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Now attempt to download the contents of the URL */
    let url = NSURL(string: "<# place your URL here #>")
    
    guard let task = session.downloadTaskWithURL(url!) else{
      return
    }
    
    /* Our own extension on the task adds the start method */
    task.start()
    
  }
  
}

