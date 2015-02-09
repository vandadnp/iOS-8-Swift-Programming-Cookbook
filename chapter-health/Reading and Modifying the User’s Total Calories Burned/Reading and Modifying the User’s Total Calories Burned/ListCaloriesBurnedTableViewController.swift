//
//  ViewController.swift
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
import HealthKit

/* We will store this as metadata for the exercise in the health store */
let HKMetadataKeyExerciseName = "ExerciseName"

extension NSDate{
  func beginningOfDay() -> NSDate{
    return NSCalendar.currentCalendar().dateBySettingHour(0,
      minute: 0,
      second: 0,
      ofDate: self,
      options: .WrapComponents)!
  }
}

class ListCaloriesBurnedTableViewController: UITableViewController,
AddBurnedCaloriesToDietViewControllerDelegate {
  
  /* The array of all the exercises that the user has performed
  today */
  var allCaloriesBurned = [CalorieBurner]()
  /* To format the calorie values */
  lazy var formatter: NSEnergyFormatter = {
    let theFormatter = NSEnergyFormatter()
    theFormatter.forFoodEnergyUse = true
    return theFormatter
  }()
  /* Find out when the user wants to add a new calorie burner
  to the list and set our view controller as the delegate of the second
  view controller */
  let segueIdentifier = "burnCalories"
  var isObservingBurnedCalories = false
  
  /* When people say calories, they are actually talking about kilocalories
  but I guess because Kilocalories is difficult to say, we have opted to
  say calories instead over the years */
  lazy var unit = HKUnit.kilocalorieUnit()
  
  struct TableViewValues{
    static let identifier = "Cell"
  }
  
  let burnedEnergyQuantityType = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierActiveEnergyBurned)
  
  lazy var types: NSSet = {
    return NSSet(object: self.burnedEnergyQuantityType)
    }()
  
  lazy var query: HKObserverQuery = {[weak self] in
    let strongSelf = self!
    return HKObserverQuery(sampleType: strongSelf.burnedEnergyQuantityType,
      predicate: strongSelf.predicate,
      updateHandler: strongSelf.burnedCaloriesChangedHandler)
    }()
  
  lazy var healthStore = HKHealthStore()
  
  lazy var predicate: NSPredicate = {
    
    let options: NSCalendarOptions = .WrapComponents
    
    let nowDate = NSDate()
    let beginningOfToday = nowDate.beginningOfDay()
    
    let tomorrowDate =
    NSCalendar.currentCalendar().dateByAddingUnit(.DayCalendarUnit,
      value: 1, toDate: NSDate(), options: options)
    
    let beginningOfTomorrow = tomorrowDate!.beginningOfDay()
    
    return HKQuery.predicateForSamplesWithStartDate(beginningOfToday,
      endDate: beginningOfTomorrow,
      options: .StrictEndDate)
    }()
  
  func burnedCaloriesChangedHandler(query: HKObserverQuery!,
    completionHandler: HKObserverQueryCompletionHandler!,
    error: NSError!){
      
      println("The burned calories has changed...")
      
      /* Be careful, we are not on the UI thread */
      fetchBurnedCaloriesInLastDay()
      
  }
  
  func addBurnedCaloriesToDietViewController(
    sender: AddBurnedCaloriesToDietViewController,
    addedCalorieBurnerWithName: String,
    calories: Double,
    startDate: NSDate,
    endDate: NSDate) {
      
      let quantity = HKQuantity(unit: unit, doubleValue: calories)
      let metadata = [
        HKMetadataKeyExerciseName: addedCalorieBurnerWithName
      ]
      
      let sample = HKQuantitySample(type: burnedEnergyQuantityType,
        quantity: quantity,
        startDate: startDate,
        endDate: endDate,
        metadata: metadata)
      
      healthStore.saveObject(sample, withCompletion: {[weak self]
        (succeeded: Bool, error: NSError!) in
        
        let strongSelf = self!
        
        if succeeded{
          println("Successfully saved the calories...")
          strongSelf.tableView.reloadData()
        } else {
          println("Failed to save the calories")
          if let theError = error{
            println("Error = \(theError)")
          }
        }
        
        })
      
  }
  
  func fetchBurnedCaloriesInLastDay(){
    
    let sortDescriptor = NSSortDescriptor(
      key: HKSampleSortIdentifierStartDate,
      ascending: false)
    
    let query = HKSampleQuery(sampleType: burnedEnergyQuantityType,
      predicate: predicate,
      limit: Int(HKObjectQueryNoLimit),
      sortDescriptors: [sortDescriptor],
      resultsHandler: {[weak self] (query: HKSampleQuery!,
        results: [AnyObject]!,
        error: NSError!) in
        
        println("Received new data from the query. Processing...")
        
        let strongSelf = self!
        
        if results.count > 0{
          
          strongSelf.allCaloriesBurned = [CalorieBurner]()
          
          for sample in results as [HKQuantitySample]{
            
            let burnerName = sample.metadata[HKMetadataKeyExerciseName]
              as? NSString
            let calories = sample.quantity.doubleValueForUnit(strongSelf.unit)
            let caloriesAsString =
            strongSelf.formatter.stringFromValue(calories, unit: .Kilocalorie)
            
            let burner = CalorieBurner(name: burnerName!,
              calories: calories,
              startDate: sample.startDate,
              endDate: sample.endDate)
            strongSelf.allCaloriesBurned.append(burner)
            
          }
          
          dispatch_async(dispatch_get_main_queue(), {
            strongSelf.tableView.reloadData()
            })
          
        } else {
          print("Could not read the burned calories ")
          println("or no burned calories data was available")
        }
        
        
      })
    
    healthStore.executeQuery(query)
    
  }
  
  
  func startObservingBurnedCaloriesChanges(){
    
    if isObservingBurnedCalories{
      return
    }
    
    healthStore.executeQuery(query)
    healthStore.enableBackgroundDeliveryForType(burnedEnergyQuantityType,
      frequency: .Immediate,
      withCompletion: {[weak self] (succeeded: Bool, error: NSError!) in
        
        if succeeded{
          self!.isObservingBurnedCalories = true
          println("Enabled background delivery of burned energy changes")
        } else {
          if let theError = error{
            print("Failed to enable background delivery " +
              "of burned energy changes. ")
            println("Error = \(theError)")
          }
        }
        
      })
  }
  
  deinit{
    stopObservingBurnedCaloriesChanges()
  }
  
  func stopObservingBurnedCaloriesChanges(){
    
    if isObservingBurnedCalories == false{
      return
    }
    
    healthStore.stopQuery(query)
    healthStore.disableAllBackgroundDeliveryWithCompletion{[weak self]
      (succeeded: Bool, error: NSError!) in
      
      if succeeded{
        self!.isObservingBurnedCalories = false
        println("Disabled background delivery of burned energy changes")
      } else {
        if let theError = error{
          print("Failed to disable background delivery of " +
            "burned energy changes. ")
          println("Error = \(theError)")
        }
      }
      
    }
  }
  
  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      healthStore.requestAuthorizationToShareTypes(types,
        readTypes: types,
        completion: {[weak self]
          (succeeded: Bool, error: NSError!) in
          
          let strongSelf = self!
          if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
              strongSelf.startObservingBurnedCaloriesChanges)
          } else {
            if let theError = error{
              println("Error occurred = \(theError)")
            }
          }
          
        })
      
    } else {
      println("Health data is not available")
    }
    
    if allCaloriesBurned.count > 0{
      let firstCell = NSIndexPath(forRow: 0, inSection: 0)
      tableView.selectRowAtIndexPath(firstCell,
        animated: true,
        scrollPosition: UITableViewScrollPosition.Top)
    }
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue,
    sender: AnyObject!) {
      
      if segue.identifier == segueIdentifier{
        let controller = segue.destinationViewController
          as AddBurnedCaloriesToDietViewController
        
        controller.delegate = self
      }
      
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return allCaloriesBurned.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewValues.identifier, forIndexPath: indexPath)
        as UITableViewCell
      
      let burner = allCaloriesBurned[indexPath.row]
      
      let caloriesAsString = formatter.stringFromValue(burner.calories,
        unit: .Kilocalorie)
      
      cell.textLabel!.text = burner.name
      cell.detailTextLabel!.text = caloriesAsString
      
      return cell
  }
  
}

