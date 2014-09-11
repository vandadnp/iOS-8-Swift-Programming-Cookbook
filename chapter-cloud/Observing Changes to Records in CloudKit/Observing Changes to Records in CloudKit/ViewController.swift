//
//  ViewController.swift
//  Observing Changes to Records in CloudKit
//
//  Created by vandad on 197//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

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
    
    var predicate = NSPredicate(format: "maker == %@", maker)
    
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
    
    println("Saving the new car...")
    database.saveRecord(newCar, completionHandler: {[weak self]
      (record: CKRecord!, error: NSError!) in
      
      if error != nil{
        println("Failed to save the car. Error = \(error)")
      } else {
        println("Successfully saved the car")
      }
      
      if self!.backgroundTaskIdentifier != UIBackgroundTaskInvalid{
        UIApplication.sharedApplication().endBackgroundTask(
          self!.backgroundTaskIdentifier)
        self!.backgroundTaskIdentifier = UIBackgroundTaskInvalid
      }
      
      })
    
  }
  
  func appWentToBackground(notification: NSNotification){
    
    println("Going to the background...")
    
    /* Start a background taks that saves a new car record
    into the database */
    self.backgroundTaskIdentifier =
      UIApplication.sharedApplication().beginBackgroundTaskWithName(
        backgroundTaskName,
        expirationHandler: {[weak self] in
          println("Background task is expired now")
        })
    
    println("App is in the background so let's create the car object")
    self.createAndSaveANewCar()
    
  }
  
  func appCameToForeground(notification: NSNotification){
    
    println("Application came to the foreground")
    
    if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid{
      println("We need to invalidate our background task")
      UIApplication.sharedApplication().endBackgroundTask(
        self.backgroundTaskIdentifier)
      self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
    }
  }
  
  func goAheadAfterPushNotificationRegistration(notification: NSNotification!){
    
    println("We are asked to proceed since notifications are registered...")
    
    println("Trying to find the subscription...")
    database.fetchSubscriptionWithID(subscriptionId, completionHandler: {
      [weak self] (subscription: CKSubscription!, error: NSError!) in
      
      if error != nil{
        if CKErrorCode.fromRaw(error.code)! == .UnknownItem{
          println("This subscription doesn't exist. Creating it now...")
          
          self!.database.saveSubscription(self!.subscription(),
            completionHandler:
            {(subscription: CKSubscription!, error: NSError!) in
              
              if error != nil{
                println("Could not save the subscription. Error = \(error)")
              } else {
                println("Successfully saved the subscription")
              }
              
            })
          
        } else {
          println("An unknown error occurred. Error = \(error)")
        }
      } else {
        
        println("Found the subscription already. No need to create it.")
        
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
    if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
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
