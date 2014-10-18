//
//  AppDelegate.swift
//  Constructing Date Objects
//
//  Created by Vandad Nahavandipoor on 6/23/14.
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  enum GregorianEra: Int{
    case BC = 0
    case AD
  }
  
  func example1(){
    
    let date = NSCalendar.currentCalendar().dateWithEra(GregorianEra.AD.toRaw(),
      year: 2014,
      month: 12,
      day: 25,
      hour: 10,
      minute: 20,
      second: 30,
      nanosecond: 40)
    
    if date != nil{
      println("The date is \(date)")
    } else {
      println("Could not construct the date")
    }
    
  }
  
  func example2(){
    
    let now = NSDate()
    
    println(now)
    
    let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
      .CalendarUnitHour,
      value: 10,
      toDate: now,
      options:.MatchNextTime)
    
    println(newDate)
    
  }
  
  func example3(){
    let now = NSDate()
    let components = NSCalendar.currentCalendar().componentsInTimeZone(
      NSTimeZone.localTimeZone(), fromDate: now)
    
    dump(components)
  }
  
  func example4(){
    
    var components = NSDateComponents()
    components.year = 2015
    components.month = 3
    components.day = 20
    components.hour = 10
    components.minute = 20
    components.second = 30
    let date = NSCalendar.currentCalendar().dateFromComponents(components)
    println(date)
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    example4()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }
  
}

