//
//  ViewController.swift
//  Observing Changes to User’s Health Information
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

class ViewController: UIViewController {
                            
  let weightQuantityType = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierBodyMass)

  lazy var types: NSSet = {
    return NSSet(object: self.weightQuantityType)
    }()
  
  lazy var healthStore = HKHealthStore()

  lazy var predicate: NSPredicate = {
    let now = NSDate()
    let yesterday =
    NSCalendar.currentCalendar().dateByAddingUnit(.DayCalendarUnit,
      value: -1,
      toDate: now,
      options: .WrapComponents)
    
    return HKQuery.predicateForSamplesWithStartDate(yesterday,
      endDate: now,
      options: .StrictEndDate)
  }()
  
  lazy var query: HKObserverQuery = {[weak self] in
    let strongSelf = self!
    return HKObserverQuery(sampleType: strongSelf.weightQuantityType,
      predicate: strongSelf.predicate,
      updateHandler: strongSelf.weightChangedHandler)
  }()
  
  func fetchRecordedWeightsInLastDay(){
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
      ascending: true)
    
    let query = HKSampleQuery(sampleType: weightQuantityType,
      predicate: predicate,
      limit: Int(HKObjectQueryNoLimit),
      sortDescriptors: [sortDescriptor],
      resultsHandler: {[weak self] (query: HKSampleQuery!,
        results: [AnyObject]!,
        error: NSError!) in
        
        if results.count > 0{
          
          for sample in results as [HKQuantitySample]{
            /* Get the weight in kilograms from the quantity */
            let weightInKilograms = sample.quantity.doubleValueForUnit(
              HKUnit.gramUnitWithMetricPrefix(.Kilo))
            
            /* This is the value of "KG", localized in user's language */
            let formatter = NSMassFormatter()
            let kilogramSuffix = formatter.unitStringFromValue(
              weightInKilograms, unit: .Kilogram)
            
            dispatch_async(dispatch_get_main_queue(), {
              
              let strongSelf = self!
              
              println("Weight has been changed to " +
                "\(weightInKilograms) \(kilogramSuffix)")
              println("Change date = \(sample.startDate)")
              
              })
          }
          
        } else {
          print("Could not read the user's weight ")
          println("or no weight data was available")
        }
        
        
      })
    
    healthStore.executeQuery(query)
    
  }
  
  func weightChangedHandler(query: HKObserverQuery!,
    completionHandler: HKObserverQueryCompletionHandler!,
    error: NSError!){
    
      /* Be careful, we are not on the UI thread */
      fetchRecordedWeightsInLastDay()
      
      completionHandler()
      
  }
  
  func startObservingWeightChanges(){
    healthStore.executeQuery(query)
    healthStore.enableBackgroundDeliveryForType(weightQuantityType,
      frequency: .Immediate,
      withCompletion: {(succeeded: Bool, error: NSError!) in
        
        if succeeded{
          println("Enabled background delivery of weight changes")
        } else {
          if let theError = error{
            print("Failed to enable background delivery of weight changes. ")
            println("Error = \(theError)")
          }
        }
        
      })
  }
  
  func stopObservingWeightChanges(){
    healthStore.stopQuery(query)
    healthStore.disableAllBackgroundDeliveryWithCompletion{
      (succeeded: Bool, error: NSError!) in
      
      if succeeded{
        println("Disabled background delivery of weight changes")
      } else {
        if let theError = error{
          print("Failed to disable background delivery of weight changes. ")
          println("Error = \(theError)")
        }
      }
      
    }
  }
  
  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      healthStore.requestAuthorizationToShareTypes(nil,
        readTypes: types,
        completion: {[weak self]
          (succeeded: Bool, error: NSError!) in
          
          let strongSelf = self!
          if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
              strongSelf.startObservingWeightChanges)
          } else {
            if let theError = error{
              println("Error occurred = \(theError)")
            }
          }
          
        })
      
    } else {
      println("Health data is not available")
    }
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    stopObservingWeightChanges()
  }

}

