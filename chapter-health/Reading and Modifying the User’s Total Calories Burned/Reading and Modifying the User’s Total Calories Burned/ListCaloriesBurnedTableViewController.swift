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
    HKQuantityTypeIdentifierActiveEnergyBurned)!
  
  lazy var types: Set<HKObjectType> = {
    return [self.burnedEnergyQuantityType]
    }()
  
  lazy var query: HKObserverQuery = {
    return HKObserverQuery(sampleType: self.burnedEnergyQuantityType,
      predicate: self.predicate,
      updateHandler: self.burnedCaloriesChangedHandler)
    }()
  
  lazy var healthStore = HKHealthStore()
  
  lazy var predicate: NSPredicate = {
    
    let options: NSCalendarOptions = .WrapComponents
    
    let nowDate = NSDate()
    let beginningOfToday = nowDate.beginningOfDay()
    
    let tomorrowDate =
    NSCalendar.currentCalendar().dateByAddingUnit(.NSDayCalendarUnit,
      value: 1, toDate: NSDate(), options: options)
    
    let beginningOfTomorrow = tomorrowDate!.beginningOfDay()
    
    return HKQuery.predicateForSamplesWithStartDate(beginningOfToday,
      endDate: beginningOfTomorrow,
      options: .StrictEndDate)
    }()
  
  func burnedCaloriesChangedHandler(query: HKObserverQuery,
    completionHandler: HKObserverQueryCompletionHandler,
    error: NSError?){
      
      print("The burned calories has changed...")
      
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
      
      healthStore.saveObject(sample, withCompletion: {
        succeeded, error in
        
        if succeeded{
          print("Successfully saved the calories...")
          self.tableView.reloadData()
        } else {
          print("Failed to save the calories")
          if let theError = error{
            print("Error = \(theError)")
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
      resultsHandler: {query, results, error in
        
        print("Received new data from the query. Processing...")
        
        guard let results = results where results.count > 0 else{
          print("Could not read the burned calories ")
          print("or no burned calories data was available")
          return
        }
        
        self.allCaloriesBurned = [CalorieBurner]()
        
        for sample in results as! [HKQuantitySample]{
          let burnerName = NSString(string: sample.metadata?[HKMetadataKeyExerciseName] as! String)
          let calories = sample.quantity.doubleValueForUnit(self.unit)
          
          let burner = CalorieBurner(name: String(burnerName),
            calories: calories,
            startDate: sample.startDate,
            endDate: sample.endDate)
          self.allCaloriesBurned.append(burner)
          
        }
        
        dispatch_async(dispatch_get_main_queue(), {
          self.tableView.reloadData()
        })
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
      withCompletion: {succeeded, error in
        
        if succeeded{
          self.isObservingBurnedCalories = true
          print("Enabled background delivery of burned energy changes")
        } else {
          if let theError = error{
            print("Failed to enable background delivery " +
              "of burned energy changes. ")
            print("Error = \(theError)")
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
    healthStore.disableAllBackgroundDeliveryWithCompletion{
      succeeded, error in
      
      if succeeded{
        self.isObservingBurnedCalories = false
        print("Disabled background delivery of burned energy changes")
      } else {
        if let theError = error{
          print("Failed to disable background delivery of " +
            "burned energy changes. ")
          print("Error = \(theError)")
        }
      }
      
    }
  }
  
  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      let sampleTypes: Set<HKSampleType> = [self.burnedEnergyQuantityType as HKSampleType]
      
      healthStore.requestAuthorizationToShareTypes(sampleTypes,
        readTypes: types,
        completion: {succeeded, error in
          
          if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
              self.startObservingBurnedCaloriesChanges)
          } else {
            if let theError = error{
              print("Error occurred = \(theError)")
            }
          }
          
        })
      
    } else {
      print("Health data is not available")
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
          as! AddBurnedCaloriesToDietViewController
        
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

