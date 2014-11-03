//
//  AudienceSelectionViewController.swift
//  Providing a Custom Sharing Extension to iOS
//
//  Created by vandad on 217//14.
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

@objc(AudienceSelectionViewControllerDelegate)
protocol AudienceSelectionViewControllerDelegate{
  optional func audienceSelectionViewController(
    sender: AudienceSelectionViewController,
    selectedValue: String)
}

class AudienceSelectionViewController: UITableViewController {
  
  struct TableViewValues{
    static let identifier = "Cell"
  }
  
  enum Audience: String{
    case Everyone = "Everyone"
    case Family = "Family"
    case Friends = "Friends"
    static let allValues = [Everyone, Family, Friends]
  }
  
  var delegate: AudienceSelectionViewControllerDelegate?
  
  var audience = Audience.Everyone.rawValue
  
  class func defaultAudience() -> String{
    return Audience.Everyone.rawValue
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewStyle) {
    super.init(style: style)
    tableView.registerClass(UITableViewCell.classForCoder(),
      forCellReuseIdentifier: TableViewValues.identifier)
    title = "Choose Audience"
  }
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return Audience.allValues.count
  }

  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewValues.identifier,
        forIndexPath: indexPath) as UITableViewCell
      
      let text = Audience.allValues[indexPath.row].rawValue
      
      cell.textLabel.text = text
      
      if text == audience{
        cell.accessoryType = .Checkmark
      } else {
        cell.accessoryType = .None
      }
      
      return cell
  }

  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      if let theDelegate = delegate{
        let selectedAudience = Audience.allValues[indexPath.row].rawValue
        theDelegate.audienceSelectionViewController!(self,
          selectedValue: selectedAudience)
        
      }
    
  }
  
}
