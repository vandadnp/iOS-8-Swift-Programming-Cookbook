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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController, NSURLSessionDelegate {
//
//  var session: NSURLSession!
//
//  required init(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//
//    /* Create our configuration first */
//    let configuration =
//    NSURLSessionConfiguration.defaultSessionConfiguration()
//    configuration.timeoutIntervalForRequest = 15.0
//
//    /* Now create our session which will allow us to create the tasks */
//    session = NSURLSession(configuration: configuration,
//      delegate: self,
//      delegateQueue: nil)
//
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    /* Now attempt to download the contents of the URL */
//    let url = NSURL(string: "<# place a URL here #>")
//
//    let task = session.dataTaskWithURL(url,
//      completionHandler: {[weak self] (data: NSData!,
//        response: NSURLResponse!,
//        error: NSError!) in
//
//        /* We got our data here */
//        println("Done")
//
//        self!.session.finishTasksAndInvalidate()
//
//      })
//
//    task.resume()
//
//  }
//
//}

/* 2 */
//import UIKit
//
//extension NSURLSessionTask{
//  func start(){
//    self.resume()
//  }
//}
//
//class ViewController: UIViewController, NSURLSessionDelegate {
//
//  var session: NSURLSession!
//
//  required init(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//
//    /* Create our configuration first */
//    let configuration =
//    NSURLSessionConfiguration.defaultSessionConfiguration()
//    configuration.timeoutIntervalForRequest = 15.0
//
//    /* Now create our session which will allow us to create the tasks */
//    session = NSURLSession(configuration: configuration,
//      delegate: self,
//      delegateQueue: nil)
//
//  }
//
//  /* Just a little method to help us display alert dialogs to the user */
//  func displayAlertWithTitle(title: String, message: String){
//    let controller = UIAlertController(title: title,
//      message: message,
//      preferredStyle: .Alert)
//
//    controller.addAction(UIAlertAction(title: "OK",
//      style: .Default,
//      handler: nil))
//
//    presentViewController(controller, animated: true, completion: nil)
//
//  }
//
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//
//    /* Now attempt to download the contents of the URL */
//    let url = NSURL(string: "<# place a URL here #>")
//
//    let task = session.downloadTaskWithURL(url,
//      completionHandler: {[weak self] (url: NSURL!,
//        response: NSURLResponse!,
//        error: NSError!) in
//
//        if error == nil{
//
//          let manager = NSFileManager()
//
//          /* Get the path to the caches folder */
//          var error: NSError?
//          var destinationPath = manager.URLForDirectory(.CachesDirectory,
//            inDomain: .UserDomainMask,
//            appropriateForURL: url,
//            create: true,
//            error: &error)!
//
//          /* Extract the last part of the source URL which is the name of the
//          file we are downloading  */
//          let componentsOfUrl =
//          url.absoluteString!.componentsSeparatedByString("/")
//          let fileNameFromUrl = componentsOfUrl[componentsOfUrl.count - 1]
//
//          /* Append the name of the file in the source URL to the
//          destination folder */
//          destinationPath =
//            destinationPath.URLByAppendingPathComponent(fileNameFromUrl)
//
//          /* Now move the file over */
//          manager.moveItemAtURL(url, toURL: destinationPath, error: nil)
//
//          let message = "Saved the downloaded data to = \(destinationPath)"
//
//          self!.displayAlertWithTitle("Success", message: message)
//
//        } else {
//          self!.displayAlertWithTitle("Error",
//            message: "Could not download the data. An error occurred")
//        }
//
//      })
//
//    /* Our own extension on the task adds the start method */
//    task.start()
//
//  }
//
//}

/* 3 */
import UIKit

extension NSURLSessionTask{
  func start(){
    self.resume()
  }
}

class ViewController: UIViewController, NSURLSessionDelegate,
NSURLSessionDataDelegate {
  
  var session: NSURLSession!
  /* We will download a URL one chunk at a time and append the downloaded
  data to this mutable data */
  var mutableData: NSMutableData = NSMutableData()
  
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
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
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
    let url = NSURL(string: "<# place your URL here #>")
    
    let task = session.dataTaskWithURL(url, completionHandler: nil)
    
    task.start()
    
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