//
//  ViewController.swift
//  Enabling Swipe Deletion of Table View Cells
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

class ViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {
  
  var tableView: UITableView?
  var allRows = [String]()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    for index in 0..<10{
      allRows.append("Cell at index of \(index)")
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.setLeftBarButtonItem(editButtonItem(), animated: false)
    
    tableView = UITableView(frame: view.bounds, style: .Plain)
    
    if let theTableView = tableView{
      
      theTableView.registerClass(UITableViewCell.classForCoder(),
        forCellReuseIdentifier: "identifier")
      
      theTableView.dataSource = self
      theTableView.delegate = self
      theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
      
      view.addSubview(theTableView)
    }
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      return allRows.count
      
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      let cell = tableView.dequeueReusableCellWithIdentifier("identifier",
        forIndexPath: indexPath) as UITableViewCell
      
      cell.textLabel.text = allRows[indexPath.row]
      
      return cell
      
  }
  
  func tableView(tableView: UITableView,
    editingStyleForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCellEditingStyle{
      return .Delete
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView!.setEditing(editing, animated: animated)
  }
  
  func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath){
    
      if editingStyle == .Delete{
        /* First remove this object from the source */
        allRows.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
      }
    
  }
  
}

