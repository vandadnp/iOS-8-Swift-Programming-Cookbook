//
//  ViewController.swift
//  Downloading Synchronously with NSURLConnection
//
//  Created by Vandad Nahavandipoor on 7/9/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
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
//    print("We are here...")
//
//    /* You can have a custom URL here */
//    let urlAsString = "http://www.yahoo.com"
//    let url = NSURL(string: urlAsString)
//
//    let urlRequest = NSURLRequest(URL: url!)
//
//    var response: NSURLResponse?
//
//    print("Firing synchronous url connection...")
//
//    /* Get the data for our URL, synchronously */
//    let data: NSData?
//    do {
//      data = try NSURLConnection.sendSynchronousRequest(urlRequest,
//        returningResponse: &response)
//      print("\(data!.length) bytes of data was returned")
//    } catch {
//      //handle error
//      print("Error happened = \(error)");
//    }
//
//    print("We are done")
//
//  }
//
//}
//
//
/* 2 */
import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("We are here...")
    
    /* You can have a custom URL here */
    let urlAsString = "http://www.yahoo.com"
    let url = NSURL(string: urlAsString)
    
    let urlRequest = NSURLRequest(URL: url!)
    
    var response: NSURLResponse?
    
    print("Firing synchronous url connection...")
    
    let dispatchQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    dispatch_async(dispatchQueue, {
      
      /* Get the data for our URL, synchronously */
      let data: NSData?
      do {
        data = try NSURLConnection.sendSynchronousRequest(urlRequest,
                returningResponse: &response)
        print("\(data!.length) bytes of data was returned")
      } catch {
        //handle error here
      }
      
      })
    
    print("We are done")
    
  }
  
}