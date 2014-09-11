//
//  AddBurnedCaloriesToDietViewController.swift
//  Reading and Modifying the User’s Total Calories Burned
//
//  Created by vandad on 237//14.
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

/* An extension on NSDate that allows us to add a specific set of minutes
to any date */
extension NSDate{
  func dateByAddingMinutes(minutes: Double) -> NSDate{
    return self.dateByAddingTimeInterval(minutes * 60.0)
  }
}


/* A structure that represents any activity that burns calories */
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


/* The delegate protocol for our view controller that will inform the delegate
whenever a new burner is added to the list */
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
  
  /* Define our variables and constants here */
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

  /* Pass the calorie burner to the delegate and pop */
  @IBAction func addToDiet(){
    
    let burner = allCalorieBurners[tableView.indexPathForSelectedRow().row]
    
    if let theDelegate = delegate{
      theDelegate.addBurnedCaloriesToDietViewController?(self,
        addedCalorieBurnerWithName: burner.name,
        calories: burner.calories,
        startDate: burner.startDate,
        endDate: burner.endDate)
    }
    
    navigationController.popViewControllerAnimated(true)
    
  }
  
  /* Display the calorie burners on the table view */
  override func tableView(tableView: UITableView!,
    numberOfRowsInSection section: Int) -> Int {
    return allCalorieBurners.count
  }
  
  override func tableView(tableView: UITableView!,
    cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewValues.identifier, forIndexPath: indexPath)
        as UITableViewCell
      
      let burner = allCalorieBurners[indexPath.row]
      
      let caloriesAsString = formatter.stringFromValue(burner.calories,
        unit: .Kilocalorie)
      
      cell.textLabel.text = burner.name
      cell.detailTextLabel.text = caloriesAsString
      
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
