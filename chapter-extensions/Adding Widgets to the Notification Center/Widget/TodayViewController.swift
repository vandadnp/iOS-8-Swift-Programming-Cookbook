//
//  TodayViewController.swift
//  Widget
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
  
  /* The same identifier is saved in our storyboard for the prototype
  cells for this table view controller */
  struct TableViewConstants{
    static let cellIdentifier = "Cell"
  }
  
  /* List of items that we want to display in our table view */
  var items: [String] = []
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return items.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewConstants.cellIdentifier,
        forIndexPath: indexPath) as UITableViewCell
      
      cell.textLabel.text = items[indexPath.row]
      
      return cell
      
  }
  
  func resetContentSize(){
    self.preferredContentSize = tableView.contentSize
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    resetContentSize()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    resetContentSize()
  }
  
  func performFetch() -> NCUpdateResult{
    
    for counter in 0..<arc4random_uniform(10){
      items.append("Item \(counter)")
    }
    
    return .NewData
  }
  
  func widgetPerformUpdateWithCompletionHandler(
    completionHandler: ((NCUpdateResult) -> Void)!) {
      
      let result = performFetch()
      
      if result == .NewData{
        tableView.reloadData()
        resetContentSize()
      }
      
      completionHandler(result)
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      let urlAsString = "widget://" + "\(indexPath.section)-\(indexPath.row)"
      let url = NSURL(string: urlAsString)
      self.extensionContext!.openURL(url!, completionHandler: nil)
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}
