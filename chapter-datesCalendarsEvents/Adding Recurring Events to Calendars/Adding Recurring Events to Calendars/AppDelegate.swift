//
//  AppDelegate.swift
//  Adding Recurring Events to Calendars
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
  
  func createEventWithTitle(
    title: String,
    startDate: NSDate,
    endDate: NSDate,
    inCalendar: EKCalendar,
    inEventStore: EKEventStore,
    notes: String) -> Bool{
      
      /* If a calendar does not allow modification of its contents
      then we cannot insert an event into it */
      if inCalendar.allowsContentModifications == false{
        println("The selected calendar does not allow modifications.")
        return false
      }
      
      /* Create an event */
      var event = EKEvent(eventStore: inEventStore)
      event.calendar = inCalendar
      
      /* Set the properties of the event such as its title,
      start date/time, end date/time, etc. */
      event.title = title
      event.notes = notes
      event.startDate = startDate
      event.endDate = endDate
      
      /* Finally, save the event into the calendar */
      var error:NSError?
      
      let result = inEventStore.saveEvent(event,
        span: EKSpanThisEvent,
        error: &error)
      
      if result == false{
        if let theError = error{
          println("An error occurred \(theError)")
        }
      }
      
      return result
  }
  
  func sourceInEventStore(
    eventStore: EKEventStore,
    type: EKSourceType,
    title: String) -> EKSource?{
      
      for source in eventStore.sources() as! [EKSource]{
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
      
      for calendar in source.calendarsForEntityType(eventType) as! Set<EKCalendar>{
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
  
  func removeEventWithTitle(
    title: String,
    startDate: NSDate,
    endDate: NSDate,
    store: EKEventStore,
    calendar: EKCalendar,
    notes: String) -> Bool{
      
      var result = false
      
      /* If a calendar does not allow modification of its contents
      then we cannot insert an event into it */
      if calendar.allowsContentModifications == false{
        println("The selected calendar does not allow modifications.")
        return false
      }
      
      let predicate = store.predicateForEventsWithStartDate(startDate,
        endDate: endDate,
        calendars: [calendar])
      
      /* Get all the events that match the parameters */
      let events = store.eventsMatchingPredicate(predicate)
        as! [EKEvent]
      
      if events.count > 0{
        
        /* Delete them all */
        for event in events{
          var error:NSError?
          
          if store.removeEvent(event,
            span: EKSpanThisEvent,
            commit: false,
            error: &error) == false{
              if let theError = error{
                println("Failed to remove \(event) with error = \(theError)")
              }
          }
        }
        
        var error:NSError?
        if store.commit(&error){
          println("Successfully committed")
          result = true
        } else if let theError = error{
          println("Failed to commit the event store with error = \(theError)")
        }
        
      } else {
        println("No events matched your input.")
      }
      
      return result
      
  }
  
  /* This method finds the calendar as well */
  func createRecurringEventInStore(store: EKEventStore){
    
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
    
    createRecurringEventInStore(store, calendar: calendar!)
    
  }
  
func createRecurringEventInStore(store: EKEventStore, calendar: EKCalendar)
  -> Bool{
    
    let event = EKEvent(eventStore: store)
    
    /* Create an event that happens today and happens
    every month for a year from now */
    let startDate = NSDate()
    
     /* The event's end date is one hour from the moment it is created */
    let oneHour:NSTimeInterval = 1 * 60 * 60
    let endDate = startDate.dateByAddingTimeInterval(oneHour)
    
    /* Assign the required properties, especially
    the target calendar */
    event.calendar = calendar
    event.title = "My Event"
    event.startDate = startDate
    event.endDate = endDate
    
    /* The end date of the recurring rule
    is one year from now */
    let oneYear:NSTimeInterval = 365 * 24 * 60 * 60;
    let oneYearFromNow = startDate.dateByAddingTimeInterval(oneYear)
    
    /* Create an Event Kit date from this date */
    let recurringEnd = EKRecurrenceEnd.recurrenceEndWithEndDate(
      oneYearFromNow) as! EKRecurrenceEnd
    
    /* And the recurring rule. This event happens every
    month (EKRecurrenceFrequencyMonthly), once a month (interval:1)
    and the recurring rule ends a year from now (end:RecurringEnd) */
    
    let recurringRule = EKRecurrenceRule(
      recurrenceWithFrequency: EKRecurrenceFrequencyMonthly,
      interval: 1,
      end: recurringEnd)
    
    /* Set the recurring rule for the event */
    event.recurrenceRules = [recurringRule]
    
    var error:NSError?
    
    if store.saveEvent(event, span: EKSpanFutureEvents, error: &error){
      println("Successfully created the recurring event.")
      return true
    } else if let theError = error{
      println("Failed to create the recurring " +
        "event with error = \(theError)")
    }
  
    return false
    
}
  
  func example1(){
    
    let eventStore = EKEventStore()
    
    switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
      
    case .Authorized:
      createRecurringEventInStore(eventStore)
    case .Denied:
      displayAccessDenied()
    case .NotDetermined:
      eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
        {[weak self] (granted: Bool, error: NSError!) -> Void in
          if granted{
            self!.createRecurringEventInStore(eventStore)
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

}

