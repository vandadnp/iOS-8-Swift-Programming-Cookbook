//
//  AppDelegate.swift
//  Adding Alarms to Calendars
//
//  Created by Vandad Nahavandipoor on 6/24/14.
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
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func sourceInEventStore(
    eventStore: EKEventStore,
    type: EKSourceType,
    title: String) -> EKSource?{
      
      for source in eventStore.sources{
        if source.sourceType.rawValue == type.rawValue &&
          source.title.caseInsensitiveCompare(title) ==
          NSComparisonResult.OrderedSame{
            return source
        }
      }
      
      return nil
  }
  
  func calendarWithTitle(
    title: String,
    type: EKCalendarType,
    source: EKSource,
    eventType: EKEntityType) -> EKCalendar?{
      
      for calendar in source.calendarsForEntityType(eventType)
        as Set<EKCalendar>{
        if calendar.title.caseInsensitiveCompare(title) ==
          NSComparisonResult.OrderedSame &&
          calendar.type.rawValue == type.rawValue{
            return calendar
        }
      }
      
      return nil
  }
  
  func displayAccessDenied(){
    print("Access to the event store is denied.")
  }
  
  func displayAccessRestricted(){
    print("Access to the event store is restricted.")
  }
  
  func addAlarmToCalendarWithStore(store: EKEventStore, calendar: EKCalendar){
    
    /* The event starts 60 seconds from now */
    let startDate = NSDate(timeIntervalSinceNow: 60.0)
    
    /* And end the event 20 seconds after its start date */
    let endDate = startDate.dateByAddingTimeInterval(20.0)
    
    let eventWithAlarm = EKEvent(eventStore: store)
    eventWithAlarm.calendar = calendar
    eventWithAlarm.startDate = startDate
    eventWithAlarm.endDate = endDate
    
    /* The alarm goes off 2 seconds before the event happens */
    let alarm = EKAlarm(relativeOffset: -2.0)
    
    eventWithAlarm.title = "Event with Alarm"
    eventWithAlarm.addAlarm(alarm)
    
    do {
      try store.saveEvent(eventWithAlarm, span: .ThisEvent)
      print("Saved an event that fires 60 seconds from now.")
    } catch let error as NSError {
        print("Failed to save the event. Error = \(error)")
    }
    
  }
  
  func addAlarmToCalendarWithStore(store: EKEventStore){
    
    let icloudSource = sourceInEventStore(store,
      type: .CalDAV,
      title: "iCloud")
    
    if icloudSource == nil{
      print("You have not configured iCloud for your device.")
      return
    }
    
    let calendar = calendarWithTitle("Calendar",
      type: .CalDAV,
      source: icloudSource!,
      eventType: .Event)
    
    if calendar == nil{
      print("Could not find the calendar we were looking for.")
      return
    }
    
    addAlarmToCalendarWithStore(store, calendar: calendar!)
    
  }
  
  func example1(){
    
    let eventStore = EKEventStore()
    
    switch EKEventStore.authorizationStatusForEntityType(.Event){
      
    case .Authorized:
      addAlarmToCalendarWithStore(eventStore)
    case .Denied:
      displayAccessDenied()
    case .NotDetermined:
      eventStore.requestAccessToEntityType(.Event, completion:
        {(granted: Bool, error: NSError?) -> Void in
          if granted{
            self.addAlarmToCalendarWithStore(eventStore)
          } else {
            self.displayAccessDenied()
          }
        })
    case .Restricted:
      displayAccessRestricted()
    }
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    example1()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }
  
}

