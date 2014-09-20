//
//  ViewController.swift
//  Creating Simple Concurrency with Operations
//
//  Created by Vandad Nahavandipoor on 7/3/14.
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
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    /* This is the convenience constructor of the operation */
    let operation = CountingOperation()
    let operationQueue = NSOperationQueue()
    operationQueue.addOperation(operation)
  }

}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  func operationCode(){
//    for _ in 0..<100{
//      println("Thread = \(NSThread.currentThread())")
//    }
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    let operation1 = NSBlockOperation(block: operationCode)
//    let operation2 = NSBlockOperation(block: operationCode)
//    let operationQueue = NSOperationQueue()
//    operationQueue.addOperation(operation1)
//    operationQueue.addOperation(operation2)
//  }
//
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  /* returns NSData or NSError */
//  func dataForUrl(url: NSURL) -> AnyObject{
//    let request = NSURLRequest(URL: url)
//
//    var error: NSError?
//    let data = NSURLConnection.sendSynchronousRequest(request,
//      returningResponse: nil,
//      error: &error)
//
//    if let theError = error{
//      return theError
//    } else {
//      return data
//    }
//
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    /* Put whatever URL that you wish, here */
//    let url = NSURL(string: "http://www.apple.com")
//
//    /* Our invocation operation points to our operation selector
//      which we coded before */
//    let operation = NSInvocationOperation(target: self,
//      selector: "dataForUrl:",
//      object: url)
//
//    /* We set the completion block in order to read the results
//    of our operation when it is done */
//    operation.completionBlock = {
//
//      if operation.result is NSData{
//        println("Data came back = \(operation.result)")
//      } else if operation.result is NSError{
//        println("Error occurred = \(operation.result)")
//      } else {
//        println("Unknown results came out of the operation")
//      }
//
//    }
//
//    /* And now we will submit our operation to a queue in order for it
//    to get executed */
//    let operationQueue = NSOperationQueue()
//    operationQueue.addOperation(operation)
//
//  }
//
//}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  func downloadUrls(urls: Array<NSURL>){
//    
//    for url in urls{
//      
//      let request = NSURLRequest(URL: url)
//      NSURLConnection.sendAsynchronousRequest(request,
//        queue: NSOperationQueue.currentQueue(),
//        completionHandler: {(response: NSURLResponse!,
//          data: NSData!,
//          error: NSError!) in
//          
//          if error{
//            /* An error occurred */
//            println("Failed to download data. Error = \(error)")
//          } else {
//            println("Data is downloaded. Save it to disk...")
//          }
//          
//        })
//      
//    }
//    
//  }
//  
//  func downloadUrls(){
//    
//    /* You can add your own URLs here as strings */
//    let urlsAsString = [
//      "http://goo.gl/BYih4G",
//      "http://goo.gl/ErcCAa",
//      "http://goo.gl/pJW9xK",
//    ]
//    
//    /* Convert all the string urls to actual urls */
//    var urls = Array<NSURL>()
//    for string in urlsAsString{
//      urls.append(NSURL(string: string))
//    }
//    
//    /* And then pass them to the function which will
//    eventually download the items */
//    downloadUrls(urls)
//    
//  }
//  
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    /* Define our operation here using a block operation */
//    let operation = NSBlockOperation(block: downloadUrls)
//    
//    let operationQueue = NSOperationQueue()
//    /* We are assuming that the reason we are downloading the content
//    to disk is that the user wanted us to and that it was "user initiated" */
//    operationQueue.qualityOfService = .UserInitiated
//    /* We will avoid overloading the system with too many url downloads
//    and only download a few simultaneously */
//    operationQueue.maxConcurrentOperationCount = 3
//    operationQueue.addOperation(operation)
//    
//  }
//  
//}


