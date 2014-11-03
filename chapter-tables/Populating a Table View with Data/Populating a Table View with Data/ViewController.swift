//
//  ViewController.swift
//  Populating a Table View with Data
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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController, UITableViewDataSource {
//  
//  var tableView: UITableView?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    tableView = UITableView(frame: view.bounds, style: .Plain)
//    
//    if let theTableView = tableView{
//      
//      theTableView.registerClass(UITableViewCell.classForCoder(),
//        forCellReuseIdentifier: "identifier")
//      
//      theTableView.dataSource = self
//      theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
//      
//      view.addSubview(theTableView)
//    }
//  }
//  
//  <# Rest of the code goes here #>
//  
//}

/* 2 */
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  
  var tableView: UITableView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: view.bounds, style: .Plain)
    
    if let theTableView = tableView{
      
      theTableView.registerClass(UITableViewCell.classForCoder(),
        forCellReuseIdentifier: "identifier")
      
      theTableView.dataSource = self
      theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
      
      view.addSubview(theTableView)
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      switch section{
      case 0:
        return 3
      case 1:
        return 5
      case 2:
        return 8
      default:
        return 0
      }
      
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      let cell = tableView.dequeueReusableCellWithIdentifier("identifier",
        forIndexPath: indexPath) as UITableViewCell
      
      cell.textLabel.text = "Section \(indexPath.section), " +
      "Cell \(indexPath.row)"
      
      return cell
      
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
}

