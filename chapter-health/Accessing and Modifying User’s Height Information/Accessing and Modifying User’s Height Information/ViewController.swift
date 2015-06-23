//
//  ViewController.swift
//  Accessing and Modifying User’s Height Information
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

enum HeightUnits: String{
  case Millimeters = "Millimeters"
  case Centimeters = "Centimeters"
  case Meters = "Meters"
  case Inches = "Inches"
  case Feet = "Feet"
  static let allValues = [Millimeters, Centimeters, Meters, Inches, Feet]
  
  func healthKitUnit() -> HKUnit{
    switch self{
    case .Millimeters:
      return HKUnit.meterUnitWithMetricPrefix(.Milli)
    case .Centimeters:
      return HKUnit.meterUnitWithMetricPrefix(.Centi)
    case .Meters:
      return HKUnit.meterUnit()
    case .Inches:
      return HKUnit.inchUnit()
    case .Feet:
      return HKUnit.footUnit()
    }
  }
  
}

class ViewController: UIViewController{
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  /* The currently selected height unit */
  var heightUnit:HeightUnits = .Millimeters{
    willSet{
      readHeightInformation()
    }
  }
  
  /* Keep track of which index path is tapped so that we can
  put a check mark next to it */
  var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
  
  let heightQuantityType = HKObjectType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierHeight)!
  
  lazy var types: Set<HKObjectType> = {
    return [self.heightQuantityType]
    }()
  
  lazy var healthStore = HKHealthStore()
  
  struct TableViewInfo{
    static let cellIdentifier = "Cell"
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return HeightUnits.allValues.count
  }
  
  /* If a new cell is selected, show the selection only for that
  cell and remove the selection from the previously-selected cell */
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      let previouslySelectedIndexPath = selectedIndexPath
      selectedIndexPath = indexPath
      
      UITableViewCellSelectionStyle.Blue.rawValue
      
      tableView.reloadRowsAtIndexPaths([previouslySelectedIndexPath,
        selectedIndexPath], withRowAnimation: .Automatic)
      
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewInfo.cellIdentifier, forIndexPath: indexPath)
        as UITableViewCell
      
      let heightUnit = HeightUnits.allValues[indexPath.row]
      
      cell.textLabel!.text = heightUnit.rawValue
      
      if indexPath == selectedIndexPath{
        cell.accessoryType = .Checkmark
      } else {
        cell.accessoryType = .None
      }
      
      return cell
  }
  
  func readHeightInformation(){
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
      ascending: false)
    
    let query = HKSampleQuery(sampleType: heightQuantityType,
      predicate: nil,
      limit: 1,
      sortDescriptors: [sortDescriptor],
      resultsHandler: {(query: HKSampleQuery,
        results: [HKSample]?,
        error: NSError?) in
        
        guard let results = results where results.count > 0 else {
          print("Could not read the user's height ", appendNewline: false)
          print("or no height data was available")
          return
        }
        
        /* We only have one sample really */
        let sample = results[0] as! HKQuantitySample
        /* Get the height in the currently-selected unit */
        let currentlySelectedUnit = self.heightUnit.healthKitUnit()
        
        let heightInUnit = sample.quantity.doubleValueForUnit(
          currentlySelectedUnit)
        
        dispatch_async(dispatch_get_main_queue(), {
          
          /* And finally set the text field's value to the user's height */
          let heightFormattedAsString =
          NSNumberFormatter.localizedStringFromNumber(
            NSNumber(double: heightInUnit),
            numberStyle: .DecimalStyle)
          
          self.textField.text = heightFormattedAsString
          
        })
        
        
        
        
    })
    
    healthStore.executeQuery(query)
    
  }
  
  override func encodeRestorableStateWithCoder(coder: NSCoder) {
    super.encodeRestorableStateWithCoder(coder)
    coder.encodeObject(selectedIndexPath, forKey: "selectedIndexPath")
    coder.encodeObject(heightUnit.rawValue, forKey: "heightUnit")
  }
  
  override func decodeRestorableStateWithCoder(coder: NSCoder) {
    super.decodeRestorableStateWithCoder(coder)
    selectedIndexPath = coder.decodeObjectForKey("selectedIndexPath")
      as! NSIndexPath
    if let newUnit = HeightUnits(rawValue:
      coder.decodeObjectForKey("heightUnit")
      as! String){
        heightUnit = newUnit
    }
  }
  
  @IBAction func saveHeight(){
    let currentlySelectedUnit = heightUnit.healthKitUnit()
    
    let heightQuantity = HKQuantity(unit: currentlySelectedUnit,
      doubleValue: NSString(string: textField.text!).doubleValue)
    let now = NSDate()
    let sample = HKQuantitySample(type: heightQuantityType,
      quantity: heightQuantity,
      startDate: now,
      endDate: now)
    
    healthStore.saveObject(sample, withCompletion: {
      (succeeded: Bool, error: NSError?) in
      
      guard let error = error else {
        print("Successfully saved the user's height")
        return
      }
      
      print("Failed to save the user's height \(error)")
      
    })
  }
  
  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      let sampleTypes: Set<HKSampleType> = [self.heightQuantityType as HKSampleType]
      
      healthStore.requestAuthorizationToShareTypes(sampleTypes,
        readTypes: types,
        completion: {
          (succeeded: Bool, error: NSError?) in
          
          if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
              self.readHeightInformation)
          } else {
            if let theError = error{
              print("Error occurred = \(theError)")
            }
          }
          
      })
      
    } else {
      print("Health data is not available")
    }
    
  }
  
}

