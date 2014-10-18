//
//  AppDelegate.swift
//  Retrieving the Attendees of an Event
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
      
      for source in eventStore.sources() as [EKSource]{
        if source.sourceType.value == type.value &&
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
      
      for calendar in source.calendarsForEntityType(eventType).allObjects
        as [EKCalendar]{
          if calendar.title.caseInsensitiveCompare(title) ==
            NSComparisonResult.OrderedSame &&
            calendar.type.value == type.value{
              return calendar
          }
      }
      
      return nil
  }
  
  func displayAccessDenied(){
    println("Access to the event store is denied.")
  }
  
  func displayAccessRestricted(){
    println("Access to the event store is restricted.")
  }
  
  func enumerateTodayEventsInStore(store: EKEventStore, calendar: EKCalendar){
    
    /* The event starts from today, right now */
    let startDate = NSDate()
    
    /* The end date will be 1 day from now */
    let endDate = startDate.dateByAddingTimeInterval(24 * 60 * 60)
    
    /* Create the predicate that we can later pass to
    the event store in order to fetch the events */
    let searchPredicate = store.predicateForEventsWithStartDate(
      startDate,
      endDate: endDate,
      calendars: [calendar])
    
    /* Fetch all the events that fall between the
    starting and the ending dates */
    let events = store.eventsMatchingPredicate(searchPredicate) as [EKEvent]
    
    /* Array of NSString equivalents of the values
    in the EKParticipantRole enumeration */
    let attendeeRole = [
      "Unknown",
      "Required",
      "Optional",
      "Chair",
      "Non Participant",
    ]
    
    /* Array of NSString equivalents of the values
    in the EKParticipantStatus enumeration */
    let attendeeStatus = [
      "Unknown",
      "Pending",
      "Accepted",
      "Declined",
      "Tentative",
      "Delegated",
      "Completed",
      "In Process",
    ]
    
    /* Array of NSString equivalents of the values
    in the EKParticipantType enumeration */
    let attendeeType = [
      "Unknown",
      "Person",
      "Room",
      "Resource",
      "Group"
    ]
    
    /* Go through all the events and print their information
    out to the console */
    
    for event in events{
      
      println("Event title = \(event.title)")
      println("Event start date = \(event.startDate)")
      println("Event end date = \(event.endDate)")
      
      if event.attendees.count == 0{
        println("This event has no attendees")
        continue
      }
      
      for attendee in event.attendees as [EKParticipant]{
        println("Attendee name = \(attendee.name)")
        
        let role = attendeeRole[Int(attendee.participantRole.value)]
        println("Attendee role = \(role)")
        
        let status = attendeeStatus[Int(attendee.participantStatus.value)]
        println("Attendee status = \(status)")
        
        let type = attendeeStatus[Int(attendee.participantType.value)]
        println("Attendee type = \(type)")
        
        println("Attendee URL = \(attendee.URL)")
        
      }
      
    }
    
  }
  
  func enumerateTodayEventsInStore(store: EKEventStore){
    
    let icloudSource = sourceInEventStore(store,
      type: EKSourceTypeCalDAV,
      title: "iCloud")
    
    if icloudSource == nil{
      println("You have not configured iCloud for your device.")
      return
    }
    
    let calendar = calendarWithTitle("Calendar",
      type: EKCalendarTypeCalDAV,
      source: icloudSource!,
      eventType: EKEntityTypeEvent)
    
    if calendar == nil{
      println("Could not find the calendar we were looking for.")
      return
    }
    
    enumerateTodayEventsInStore(store, calendar: calendar!)
    
  }
  
  func example1(){
    
    let eventStore = EKEventStore()
    
    switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
      
    case .Authorized:
      enumerateTodayEventsInStore(eventStore)
    case .Denied:
      displayAccessDenied()
    case .NotDetermined:
      eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
        {[weak self] (granted: Bool, error: NSError!) -> Void in
          if granted{
            self!.enumerateTodayEventsInStore(eventStore)
          } else {
            self!.displayAccessDenied()
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
  
  func applicationWillResignActive(application: UIApplication) {
    
    example1()
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  
  
  
  
  
  
  
  
  
}

