//
//  ViewController.swift
//  Retrieving User’s Date of Birth
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
  
  let dateOfBirthCharacteristicType =
  HKCharacteristicType.characteristicTypeForIdentifier(
    HKCharacteristicTypeIdentifierDateOfBirth)!
  
  lazy var types: Set<HKObjectType> = {
    return [self.dateOfBirthCharacteristicType]
    }()
  
  lazy var healthStore = HKHealthStore()
  
  func readDateOfBirthInformation(){
    
    do{
      let birthDate = try healthStore.dateOfBirthWithError()
      
      let now = NSDate()
      let components = NSCalendar.currentCalendar().components(
        .NSYearCalendarUnit,
        fromDate: birthDate,
        toDate: now,
        options: .WrapComponents)
      
      let age = components.year
      
      print("The user is \(age) years old")
      
    } catch {
      print("Could not read user's date of birth")
    }
    
    
  }

  /* Ask for permission to access the health store */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if HKHealthStore.isHealthDataAvailable(){
      
      healthStore.requestAuthorizationToShareTypes(nil,
        readTypes: types,
        completion: {succeeded, error in
          
          if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
              self.readDateOfBirthInformation)
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

