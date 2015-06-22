//
//  ViewController.swift
//  Observing Changes to Records in CloudKit
//
//  Created by Vandad Nahavandipoor on 7/11/14.
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
import CloudKit

class ViewController: UIViewController {
  
  let database = CKContainer.defaultContainer().privateCloudDatabase
  let recordType = "MyCar"
  let maker = "carmaker"
  let model = "Some model name"
  let subscriptionId = "MySubscriptionIdentifier"
  let backgroundTaskName = "saveNewCar"
  
  /* The background task identifier for the task that will save our
  record in the database when our app goes to the background */
  var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
  UIBackgroundTaskInvalid

  func subscription() -> CKSubscription{
    
    let predicate = NSPredicate(format: "maker == %@", maker)
    
    let subscription = CKSubscription(recordType: recordType,
      predicate: predicate,
      subscriptionID: subscriptionId,
      options: .FiresOnRecordCreation)
    
    let notificationInfo = CKNotificationInfo()
    notificationInfo.alertLocalizationKey = "creationAlertBodyKey"
    notificationInfo.shouldBadge = false
    notificationInfo.desiredKeys = ["model"]
    notificationInfo.alertActionLocalizationKey = "creationAlertActionKey"
    
    subscription.notificationInfo = notificationInfo
    
    return subscription
  }
  
  func createAndSaveANewCar(){
    
    let recordName = NSUUID().UUIDString
    
    let recordId = CKRecordID(recordName: recordName)
    
    let newCar = CKRecord(recordType: recordType, recordID: recordId)
    
    newCar.setValue(maker, forKey: "maker")
    newCar.setValue(model, forKey: "model")
    newCar.setValue(5, forKey: "numberOfDoors")
    newCar.setValue(2016, forKey: "year")
    newCar.setValue("Orange", forKey: "color")
    
    print("Saving the new car...")
    database.saveRecord(newCar, completionHandler: {
      (record: CKRecord?, error: NSError?) in
      
      if error != nil{
        print("Failed to save the car. Error = \(error)")
      } else {
        print("Successfully saved the car")
      }
      
      if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid{
        UIApplication.sharedApplication().endBackgroundTask(
          self.backgroundTaskIdentifier)
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
      }
      
      })
    
  }
  
  func appWentToBackground(notification: NSNotification){
    
    print("Going to the background...")
    
    /* Start a background taks that saves a new car record
    into the database */
    self.backgroundTaskIdentifier =
      UIApplication.sharedApplication().beginBackgroundTaskWithName(
        backgroundTaskName,
        expirationHandler: {
          print("Background task is expired now")
        })
    
    print("App is in the background so let's create the car object")
    self.createAndSaveANewCar()
    
  }
  
  func appCameToForeground(notification: NSNotification){
    
    print("Application came to the foreground")
    
    if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid{
      print("We need to invalidate our background task")
      UIApplication.sharedApplication().endBackgroundTask(
        self.backgroundTaskIdentifier)
      self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
    }
  }
  
  func goAheadAfterPushNotificationRegistration(notification: NSNotification!){
    
    print("We are asked to proceed since notifications are registered...")
    
    print("Trying to find the subscription...")
    database.fetchSubscriptionWithID(subscriptionId, completionHandler: {
      (subscription: CKSubscription?, error: NSError?) in
      
      guard let error = error else {
        print("Found the subscription already. No need to create it.")
        return
      }
      
      
      if error.code == CKErrorCode.UnknownItem.rawValue{
        print("This subscription doesn't exist. Creating it now...")
        
        self.database.saveSubscription(self.subscription(),
          completionHandler:
          {(subscription: CKSubscription?, error: NSError?) in
            
            if error != nil{
              print("Could not save the subscription. Error = \(error)")
            } else {
              print("Successfully saved the subscription")
            }
            
        })
        
      } else {
        print("An unknown error occurred. Error = \(error)")
      }
      
      })
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if isIcloudAvailable(){
      displayAlertWithTitle("iCloud", message: "iCloud is not available." +
        " Please sign into your iCloud account and restart this app")
      return
    }
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "appWentToBackground:",
      name: UIApplicationDidEnterBackgroundNotification,
      object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "appCameToForeground:",
      name: UIApplicationWillEnterForegroundNotification,
      object: nil)
    
    /* If we are already registered for push notifications, we don't have
    to wait for the app delegate to inform us that we can go ahead */
    if UIApplication.sharedApplication().isRegisteredForRemoteNotifications(){
      goAheadAfterPushNotificationRegistration(nil)
    } else {
      NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "goAheadAfterPushNotificationRegistration:",
        name: AppDelegate.goAheadWithSubscriptionCreationNotificationName(),
        object: nil)
    }
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  /* Checks if the user has logged into her iCloud account or not */
  func isIcloudAvailable() -> Bool{
    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
}
