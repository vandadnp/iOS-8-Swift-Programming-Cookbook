//
//  ViewController.swift
//  Setting up Your App for HealthKit
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

class ViewController: UIViewController {
  
  let heightQuantity = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierHeight)!
  
  let weightQuantity = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierBodyMass)!
  
  let heartRateQuantity = HKQuantityType.quantityTypeForIdentifier(
    HKQuantityTypeIdentifierHeartRate)!
  
  lazy var healthStore = HKHealthStore()
  
  /* The type of data that we wouldn't write into the health store */
  lazy var typesToShare: Set<HKSampleType> = {
    return [self.heightQuantity, self.weightQuantity]
  }()
  
  /* We want to read this type of data */
  lazy var typesToRead: Set<HKObjectType> = {
    return [self.heightQuantity, self.weightQuantity, self.heartRateQuantity]
  }()
  
  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      healthStore.requestAuthorizationToShareTypes(typesToShare,
        readTypes: typesToRead,
        completion: {succeeded, error in
          
          if succeeded && error == nil{
            print("Successfully received authorization")
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

