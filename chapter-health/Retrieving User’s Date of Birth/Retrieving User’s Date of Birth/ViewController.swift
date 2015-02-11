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
    HKCharacteristicTypeIdentifierDateOfBirth)
  
  lazy var types: Set<NSObject>! = {
    return Set([self.dateOfBirthCharacteristicType])
    }()
  
  lazy var healthStore = HKHealthStore()
  
  func readDateOfBirthInformation(){
    
    var dateOfBirthError: NSError?
    let birthDate = healthStore.dateOfBirthWithError(&dateOfBirthError)
      as NSDate?
    
    if let error = dateOfBirthError{
      println("Could not read user's date of birth")
    } else {
      
      if let dateOfBirth = birthDate{
        let formatter = NSNumberFormatter()
        let now = NSDate()
        let components = NSCalendar.currentCalendar().components(
          .YearCalendarUnit,
          fromDate: dateOfBirth,
          toDate: now,
          options: .WrapComponents)
        
        let age = components.year
        
        println("The user is \(age) years old")
      } else {
        println("User has not specified her date of birth yet")
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
              strongSelf.readDateOfBirthInformation)
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

