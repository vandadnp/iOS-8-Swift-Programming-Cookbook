//
//  AppDelegate.swift
//  Converting Between Units
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
//      /* 1 */
//      let gramUnit = HKUnit(fromMassFormatterUnit: .Gram)
//      let kilogramUnit = HKUnit(fromMassFormatterUnit: .Kilogram)
//      let weightInGrams:Double = 74_250
//      let weightQuantity = HKQuantity(unit: gramUnit,
//        doubleValue: weightInGrams)
//      let weightInKilograms = weightQuantity.doubleValueForUnit(kilogramUnit)
//      
//      print("Your weight is \(weightInKilograms) kilograms")
//      print("Your weight is \(weightInGrams) grams")
//      
//      /* 2 */
//      let caloriesValue:Double = 1_500
//      
//      let caloriesUnit = HKQuantity(unit: HKUnit.calorieUnit(),
//        doubleValue: caloriesValue)
//      
//      let kilojoulesValue = caloriesUnit.doubleValueForUnit(
//        HKUnit.jouleUnitWithMetricPrefix(.Kilo))
//      
//      let energyFormatter = NSEnergyFormatter()
//      
//      let caloriesString = energyFormatter.stringFromValue(
//        caloriesValue, unit: .Calorie)
//      let kilojoulesString = energyFormatter.stringFromValue(kilojoulesValue,
//        unit: .Kilojoule)
//      
//      print("You've burned \(caloriesString)")
//      print("You've burned \(kilojoulesString)")
//
      /* 3 */
      let distanceInMeters:Double = 1_234
      
      let metersUnit = HKQuantity(unit: HKUnit.meterUnit(),
        doubleValue: distanceInMeters)
      
      let feetValue = metersUnit.doubleValueForUnit(
        HKUnit.footUnit())
      
      let lengthFormatter = NSLengthFormatter()
      
      let metersString = lengthFormatter.stringFromValue(distanceInMeters,
        unit: .Meter)
      let feetString = lengthFormatter.stringFromValue(feetValue,
        unit: .Foot)
      
      print("You've driven \(metersString)")
      print("You've driven \(feetString)")
      
      return true
  }
  
}

