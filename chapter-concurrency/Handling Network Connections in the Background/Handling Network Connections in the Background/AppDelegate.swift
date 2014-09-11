//
//  AppDelegate.swift
//  Handling Network Connections in the Background
//
//  Created by Vandad Nahavandipoor on 7/7/14.
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
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
//
//      let urlAsString = "http://www.apple.com"
//      let url = NSURL(string: urlAsString)
//      let urlRequest = NSURLRequest(URL: url)
//      let queue = NSOperationQueue()
//
//      NSURLConnection.sendAsynchronousRequest(urlRequest,
//        queue: queue,
//        completionHandler: {(response: NSURLResponse!,
//          data: NSData!,
//          error: NSError!) in
//
//        if data.length > 0 && error == nil{
//          /* Date did come back */
//        }
//        else if data.length == 0 && error == nil{
//          /* No data came back */
//        }
//        else if error != nil{
//          /* Error happened. Make sure you handle this properly */
//        }
//        })
//
//      return true
//  }
//
//}

/* 2 */
//import UIKit
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
//
//      let urlAsString = "http://www.apple.com"
//      let url = NSURL(string: urlAsString)
//      let urlRequest = NSURLRequest(URL: url)
//      let queue = NSOperationQueue()
//      var error: NSError?
//
//      let data = NSURLConnection.sendSynchronousRequest(urlRequest,
//        returningResponse: nil,
//        error: &error)
//
//      if data != nil && error == nil{
//        /* Date did come back */
//      }
//      else if data!.length == 0 && error == nil{
//        /* No data came back */
//      }
//      else if error != nil{
//        /* Error happened. Make sure you handle this properly */
//      }
//
//      return true
//  }
//
//}

/* 3 */
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
      
      let dispatchQueue =
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      
      dispatch_async(dispatchQueue, {
        /* Replace this URL with the URL of a file that is
        rather big in size */
        let urlAsString = "http://www.apple.com"
        let url = NSURL(string: urlAsString)
        let urlRequest = NSURLRequest(URL: url)
        let queue = NSOperationQueue()
        var error: NSError?
        
        let data = NSURLConnection.sendSynchronousRequest(urlRequest,
          returningResponse: nil,
          error: &error)
        
        if data != nil && error == nil{
          /* Date did come back */
        }
        else if data!.length == 0 && error == nil{
          /* No data came back */
        }
        else if error != nil{
          /* Error happened. Make sure you handle this properly */
        }
        })
      
      return true
  }
  
}