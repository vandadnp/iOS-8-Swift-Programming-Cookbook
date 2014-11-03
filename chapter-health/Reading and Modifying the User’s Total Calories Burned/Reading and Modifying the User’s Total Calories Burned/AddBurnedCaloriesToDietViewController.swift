//
//  AddBurnedCaloriesToDietViewController.swift
//  TestingSwift
//
//  Created by Vandad NP on 10/18/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

extension NSDate{
  func dateByAddingMinutes(minutes: Double) -> NSDate{
    return self.dateByAddingTimeInterval(minutes * 60.0)
  }
}

struct CalorieBurner{
  var name: String
  var calories: Double
  var startDate = NSDate()
  var endDate = NSDate()
  
  init(name: String, calories: Double, startDate: NSDate, endDate: NSDate){
    self.name = name
    self.calories = calories
    self.startDate = startDate
    self.endDate = endDate
  }
  
  init(name: String, calories: Double, minutes: Double){
    self.name = name
    self.calories = calories
    self.startDate = NSDate()
    self.endDate = self.startDate.dateByAddingMinutes(minutes)
  }
}

@objc(AddBurnedCaloriesToDietViewControllerDelegate)
protocol AddBurnedCaloriesToDietViewControllerDelegate{
  optional func addBurnedCaloriesToDietViewController(
    sender: AddBurnedCaloriesToDietViewController,
    addedCalorieBurnerWithName: String,
    calories: Double,
    startDate: NSDate,
    endDate: NSDate)
}

class AddBurnedCaloriesToDietViewController: UITableViewController {

  struct TableViewValues{
    static let identifier = "Cell"
  }
  
  lazy var formatter: NSEnergyFormatter = {
    let theFormatter = NSEnergyFormatter()
    theFormatter.forFoodEnergyUse = true
    return theFormatter
    }()
  
  /* This is our delegate that gets notified whenever the user
  chooses to add a calorie burner to her list */
  var delegate: AddBurnedCaloriesToDietViewControllerDelegate?
  
  /* An array of calorie burners that we will display
  in our table view */
  lazy var allCalorieBurners: [CalorieBurner] = {
    
    let cycling = CalorieBurner(name: "1 hour on the bike",
      calories: 450,
      minutes: 60)
    let running = CalorieBurner(name: "30 minutes fast-paced running",
      calories: 300,
      minutes: 30
    )
    let swimming = CalorieBurner(name: "20 minutes crawl-swimming",
      calories: 400,
      minutes: 20
    )
    
    return [cycling, running, swimming]
    
    }()
  
  @IBAction func addToDiet(){
    
    let burner = allCalorieBurners[tableView.indexPathForSelectedRow()!.row]
    
    if let theDelegate = delegate{
      theDelegate.addBurnedCaloriesToDietViewController?(self,
        addedCalorieBurnerWithName: burner.name,
        calories: burner.calories,
        startDate: burner.startDate,
        endDate: burner.endDate)
    }
    
    navigationController!.popViewControllerAnimated(true)
    
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return allCalorieBurners.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewValues.identifier, forIndexPath: indexPath)
        as UITableViewCell
      
      let burner = allCalorieBurners[indexPath.row]
      
      let caloriesAsString = formatter.stringFromValue(burner.calories,
        unit: .Kilocalorie)
      
      cell.textLabel.text = burner.name
      cell.detailTextLabel!.text = caloriesAsString
      
      return cell
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.selectRowAtIndexPath(
      NSIndexPath(forRow: 0, inSection: 0),
      animated: false,
      scrollPosition: .None)
  }

}
