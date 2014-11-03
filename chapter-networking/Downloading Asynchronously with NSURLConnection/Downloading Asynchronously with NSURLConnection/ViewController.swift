//
//  ViewController.swift
//  Downloading Asynchronously with NSURLConnection
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
//class ViewController: UIViewController {
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    /* Construct the URL and the request to send to the connection */
//    let urlAsString = "http://www.apple.com"
//    let url = NSURL(string: urlAsString)
//    let urlRequest = NSURLRequest(URL: url!)
//    
//    /* We will do the asynchronous request on our own queue */
//    let queue = NSOperationQueue()
//    
//    NSURLConnection.sendAsynchronousRequest(urlRequest,
//      queue: queue,
//      completionHandler: {(response: NSURLResponse!,
//        data: NSData!,
//        error: NSError!) in
//      
//        /* Now we may have access to the data but check if an error came back
//        first or not */
//        if data.length > 0 && error == nil{
//          let html = NSString(data: data, encoding: NSUTF8StringEncoding)
//          println("html = \(html)")
//        } else if data.length == 0 && error == nil{
//          println("Nothing was downloaded")
//        } else if error != nil{
//          println("Error happened = \(error)")
//        }
//      
//      })
//    
//  }
//  
//}

/* 2 */
import UIKit

extension NSURL{
  /* An extension on the NSURL class that allows us to retrieve the current
  documents folder path */
  class func documentsFolder() -> NSURL{
    let fileManager = NSFileManager()
    return fileManager.URLForDirectory(.DocumentDirectory,
      inDomain: .UserDomainMask,
      appropriateForURL: nil,
      create: false,
      error: nil)!
  }
}

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Construct the URL and the request to send to the connection */
    let urlAsString = "http://www.apple.com"
    let url = NSURL(string: urlAsString)
    let urlRequest = NSURLRequest(URL: url!)
    
    /* We will do the asynchronous request on our own queue */
    let queue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(urlRequest,
      queue: queue,
      completionHandler: {(response: NSURLResponse!,
        data: NSData!,
        error: NSError!) in
        
        /* Now we may have access to the data but check if an error came back
        first or not */
        if data.length > 0 && error == nil{
          
          /* Append the filename to the documents directory */
          let filePath =
          NSURL.documentsFolder().URLByAppendingPathComponent("apple.html")
          
          if data.writeToURL(filePath, atomically: true){
            println("Successfully saved the file to \(filePath)")
          } else {
            println("Failed to save the file to \(filePath)")
          }
          
        } else if data.length == 0 && error == nil{
          println("Nothing was downloaded")
        } else if error != nil{
          println("Error happened = \(error)")
        }
        
      })
    
  }
  
}

