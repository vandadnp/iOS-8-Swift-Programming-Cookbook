//
//  ViewController.swift
//  Sending HTTP Requests with NSURLConnection
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
//    let httpMethod = "GET"
//    
//    /* We have a 15 second timeout for our connection */
//    let timeout = 15
//    
//    /* You can choose your own URL here */
//    var urlAsString = "<# place your url here #>"
//    
//    urlAsString += "?param1=First"
//    urlAsString += "&param2=Second"
//    
//    let url = NSURL(string: urlAsString)
//    
//    /* Set the timeout on our request here */
//    let urlRequest = NSMutableURLRequest(URL: url!,
//      cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
//      timeoutInterval: 15.0)
//    
//    urlRequest.HTTPMethod = httpMethod
//    
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
//      }
//    )
//    
//  }
//
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let httpMethod = "POST"
    
    /* We have a 15 second timeout for our connection */
    let timeout = 15
    
    /* You can choose your own URL here */
    var urlAsString = "<# place your url here #>"
    
    /* These are the parameters that will be sent as part of the URL */
    urlAsString += "?param1=First"
    urlAsString += "&param2=Second"
    
    let url = NSURL(string: urlAsString)
    
    /* Set the timeout on our request here */
    let urlRequest = NSMutableURLRequest(URL: url!,
      cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 15.0)
    
    urlRequest.HTTPMethod = httpMethod
    
    /* These are the POST parameters */
    let body =
    "bodyParam1=BodyValue1&bodyParam2=BodyValue2".dataUsingEncoding(
      NSUTF8StringEncoding,
      allowLossyConversion: false)
    
    urlRequest.HTTPBody = body
    
    let queue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(urlRequest,
      queue: queue,
      completionHandler: {(response: NSURLResponse!,
        data: NSData!,
        error: NSError!) in
        
        /* Now we may have access to the data but check if an error came back
        first or not */
        if data.length > 0 && error == nil{
          let html = NSString(data: data, encoding: NSUTF8StringEncoding)
          println("html = \(html)")
        } else if data.length == 0 && error == nil{
          println("Nothing was downloaded")
        } else if error != nil{
          println("Error happened = \(error)")
        }
        
      }
    )
    
  }
  
}

