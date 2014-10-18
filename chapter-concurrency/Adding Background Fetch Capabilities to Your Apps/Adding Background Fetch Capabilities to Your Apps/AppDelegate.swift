//
//  AppDelegate.swift
//  Adding Background Fetch Capabilities to Your Apps
//
//  Created by Vandad Nahavandipoor on 7/6/14.
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var newsItems = [NewsItem]()
  
  /* The name of the notification that we will send when our news
  items are changed */
  class func newsItemsChangedNotification() -> String{
    return "\(__FUNCTION__)"
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      newsItems.append(NewsItem(date: NSDate(), text: "News Item 1"))
      
      application.setMinimumBackgroundFetchInterval(
        UIApplicationBackgroundFetchIntervalMinimum)
      
      return true
  }
  
  /* Returns true if it could get some news items from the server */
  func fetchNewsItems () -> Bool{
    
    if (arc4random_uniform(2) != 1){
      return false
    }
    
    /* Generate a new item */
    let item = NewsItem(date: NSDate(),
      text: "News Item \(newsItems.count + 1)")
    
    newsItems.append(item)
    
    /* Send a notification to observers telling them that a news item
    is now available */
    NSNotificationCenter.defaultCenter().postNotificationName(
      self.classForCoder.newsItemsChangedNotification(),
      object: nil)
    
    return true
    
  }
  
  func application(application: UIApplication,
    performFetchWithCompletionHandler completionHandler:
    ((UIBackgroundFetchResult) -> Void)!){
      
      if self.fetchNewsItems(){
        completionHandler(.NewData)
      } else {
        completionHandler(.NoData)
      }
      
  }
  
}

