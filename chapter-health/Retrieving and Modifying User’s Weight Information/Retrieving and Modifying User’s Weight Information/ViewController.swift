//
//  ViewController.swift
//  Retrieving and Modifying User’s Weight Information
//
//  Created by vandad on 227//14.
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

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  /* This is a label that shows the user's weight unit (Kilograms) on
  the right hand side of our text field */
  let textFieldRightLabel = UILabel(frame: CGRectZero)
  
  let weightQuantityType = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierBodyMass)
  
  lazy var types: Set<NSObject>! = {
    return Set([self.weightQuantityType])
    }()
  
  lazy var healthStore = HKHealthStore()
  
  @IBAction func saveUserWeight(){
  
    let kilogramUnit = HKUnit.gramUnitWithMetricPrefix(.Kilo)
    let weightQuantity = HKQuantity(unit: kilogramUnit,
      doubleValue: (textField.text as NSString).doubleValue)
    let now = NSDate()
    let sample = HKQuantitySample(type: weightQuantityType,
      quantity: weightQuantity,
      startDate: now,
      endDate: now)
    
    healthStore.saveObject(sample, withCompletion: {
      (succeeded: Bool, error: NSError!) in
      
      if error == nil{
        println("Successfully saved the user's weight")
      } else {
        println("Failed to save the user's weight")
      }
      
      })
    
  }
  
  func readWeightInformation(){
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
      ascending: false)
    
    let query = HKSampleQuery(sampleType: weightQuantityType,
      predicate: nil,
      limit: 1,
      sortDescriptors: [sortDescriptor],
      resultsHandler: {[weak self] (query: HKSampleQuery!,
        results: [AnyObject]!,
        error: NSError!) in
      
        if results.count > 0{
          
          /* We only have one sample really */
          let sample = results[0] as! HKQuantitySample
          /* Get the weight in kilograms from the quantity */
          let weightInKilograms = sample.quantity.doubleValueForUnit(
            HKUnit.gramUnitWithMetricPrefix(.Kilo))
          
          /* This is the value of "KG", localized in user's language */
          let formatter = NSMassFormatter()
          let kilogramSuffix = formatter.unitStringFromValue(weightInKilograms,
            unit: .Kilogram)
          
          dispatch_async(dispatch_get_main_queue(), {
            
            let strongSelf = self!
            
            
            /* Set the value of "KG" on the right hand side of the
            text field */
            strongSelf.textFieldRightLabel.text = kilogramSuffix
            strongSelf.textFieldRightLabel.sizeToFit()
            
            /* And finally set the text field's value to the user's
            weight */
            let weightFormattedAsString =
            NSNumberFormatter.localizedStringFromNumber(
              NSNumber(double: weightInKilograms),
              numberStyle: .NoStyle)
            
            strongSelf.textField.text = weightFormattedAsString
            
            })
          
        } else {
          print("Could not read the user's weight ")
          println("or no weight data was available")
        }
        
      
      })
    
    healthStore.executeQuery(query)
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField.rightView = textFieldRightLabel
    textField.rightViewMode = .Always
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
              strongSelf.readWeightInformation)
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

}

