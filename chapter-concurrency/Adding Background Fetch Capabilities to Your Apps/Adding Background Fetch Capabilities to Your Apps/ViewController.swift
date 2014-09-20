//
//  ViewController.swift
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

class ViewController: UITableViewController {
  
  var mustReloadView = false
  
  /* Our news items comes from the app delegate */
  var newsItems: [NewsItem]{
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  return appDelegate.newsItems
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Listen to when the news items are changed */
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleNewsItemsChanged:",
      name: AppDelegate.newsItemsChangedNotification(),
      object: nil)
    
    /* Handle what we need to do when the app comes back to the
    foreground */
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleAppIsBroughtToForeground:",
      name: UIApplicationWillEnterForegroundNotification,
      object: nil)
    
  }
  
  /* If there is need to reload after we come back to the foreground, 
  do it here */
  func handleAppIsBroughtToForeground(notification: NSNotification){
    if mustReloadView{
      tableView.reloadData()
    }
  }
  
  /* We are being told new news items are available. Reload the table view */
  func handleNewsItemsChanged(notification: NSNotification) {
    if self.isBeingPresented(){
      tableView.reloadData()
    } else {
      mustReloadView = true
    }
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return newsItems.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell",
        forIndexPath: indexPath) as UITableViewCell
      
      cell.textLabel!.text = newsItems[indexPath.row].text
      
      return cell
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}

