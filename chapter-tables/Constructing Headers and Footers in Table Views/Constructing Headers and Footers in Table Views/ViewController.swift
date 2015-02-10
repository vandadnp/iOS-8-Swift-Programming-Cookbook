//
//  ViewController.swift
//  Constructing Headers and Footers in Table Views
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
  UITableViewDelegate, UITableViewDataSource {
  
  var tableView: UITableView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: view.bounds, style: .Grouped)
    
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
      return 3
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      let cell = tableView.dequeueReusableCellWithIdentifier("identifier",
        forIndexPath: indexPath) as! UITableViewCell
      
      cell.textLabel!.text = "Cell \(indexPath.row)"
      
      return cell
      
  }
  
  func newLabelWithTitle(title: String) -> UILabel{
    let label = UILabel()
    label.text = title
    label.backgroundColor = UIColor.clearColor()
    label.sizeToFit()
    return label
  }
  
  func newViewForHeaderOrFooterWithText(text: String) -> UIView{
    let headerLabel = newLabelWithTitle(text)
    
    /* Move the label 10 points to the right */
    headerLabel.frame.origin.x += 10
    /* Go 5 points down in y axis */
    headerLabel.frame.origin.y = 5
    
    /* Give the container view 10 points more in width than our label
    because the label needs a 10 extra points left-margin */
    let resultFrame = CGRect(x: 0,
      y: 0,
      width: headerLabel.frame.size.width + 10,
      height: headerLabel.frame.size.height)
    
    let headerView = UIView(frame: resultFrame)
    headerView.addSubview(headerLabel)
    
    return headerView
  }
  
  func tableView(tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat{
      return 30
  }
  
//  func tableView(tableView: UITableView,
//    viewForHeaderInSection section: Int) -> UIView?{
//      return newViewForHeaderOrFooterWithText("Section \(section) Header")
//  }
//  
//  func tableView(tableView: UITableView,
//    viewForFooterInSection section: Int) -> UIView?{
//      return newViewForHeaderOrFooterWithText("Section \(section) Footer")
//  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String?{
    return "Section \(section) Header"
  }
  
  func tableView(tableView: UITableView,
    titleForFooterInSection section: Int) -> String?{
    return "Section \(section) Footer"
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
}

