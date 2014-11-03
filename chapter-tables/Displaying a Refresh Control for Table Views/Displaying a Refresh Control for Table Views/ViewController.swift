//
//  ViewController.swift
//  Displaying a Refresh Control for Table Views
//
//  Created by Vandad Nahavandipoor on 7/1/14.
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

class ViewController: UIViewController, UITableViewDataSource {
  var tableView: UITableView?
  var allTimes = [NSDate]()
  var refreshControl: UIRefreshControl?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    allTimes.append(NSDate())
    
    tableView = UITableView(frame: view.bounds, style: .Plain)
    
    if let theTableView = tableView{
      
      theTableView.registerClass(UITableViewCell.classForCoder(),
        forCellReuseIdentifier: "identifier")
      
      theTableView.dataSource = self
      theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
      
      /* Create the refresh control */
      refreshControl = UIRefreshControl()
      refreshControl!.addTarget(self,
        action: "handleRefresh:",
        forControlEvents: .ValueChanged)
      
      theTableView.addSubview(refreshControl!)
      
      view.addSubview(theTableView)
    }
  }

  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      return allTimes.count
      
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      let cell = tableView.dequeueReusableCellWithIdentifier("identifier",
        forIndexPath: indexPath) as UITableViewCell
      
      cell.textLabel.text = "\(allTimes[indexPath.row])"
      
      return cell
      
  }
  
  func handleRefresh(paramSender: AnyObject){
  
  /* Put a bit of delay between when the refresh control is released
  and when we actually do the refreshing to make the UI look a bit
  smoother than just doing the update without the animation */
    
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
    dispatch_after(popTime,
      dispatch_get_main_queue(), {
        
        /* Add the current date to the list of dates that we have
        so that when the table view is refreshed, a new item will appear
        on the screen so that the user will see the difference between
        the before and the after of the refresh */
        self.allTimes.append(NSDate())
        self.refreshControl!.endRefreshing()
        let indexPathOfNewRow = NSIndexPath(forRow: self.allTimes.count - 1,
          inSection: 0)
        
        self.tableView!.insertRowsAtIndexPaths([indexPathOfNewRow],
          withRowAnimation: .Automatic)
        
      })

  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
}

