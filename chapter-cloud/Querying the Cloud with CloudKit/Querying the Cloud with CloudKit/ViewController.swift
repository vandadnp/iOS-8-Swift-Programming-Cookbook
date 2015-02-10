//
//  ViewController.swift
//  Querying the Cloud with CloudKit
//
//  Created by vandad on 197//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

/* 1 */
//import UIKit
//
//@objc(Person) class Person: NSObject{
//  var firstName: NSString
//  var lastName: NSString
//
//  init(firstName: NSString, lastName: NSString){
//    self.firstName = firstName
//    self.lastName = lastName
//  }
//
//}
//
//class ViewController: UIViewController {
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let richard = Person(firstName: "Richard", lastName: "Branson")
//    let vandad = Person(firstName: "Vandad", lastName: "Nahavandipoor")
//    let anthony = Person(firstName: "Anthony", lastName: "Robbins")
//
//    let persons = [richard, vandad, anthony]
//
//    let longestAcceptableFirstNameLetters = 6
//    let predicate = NSPredicate(format: "firstName.length <= %@",
//      longestAcceptableFirstNameLetters as NSNumber)
//
//    let filteredArray =
//    (persons as NSArray).filteredArrayUsingPredicate(predicate) as? [Person]
//
//    if let array = filteredArray{
//      for person in array{
//        println("Found a person with first name equal or less than 6 letters")
//        println("First name = \(person.firstName)")
//        println("Last name = \(person.lastName)")
//      }
//    } else {
//      println("Could not find any items in the filtered array")
//
//    }
//
//  }
//
//}


/* 2 */
//import UIKit
//import CloudKit
//
//class ViewController: UIViewController {
//  
//  let database = CKContainer.defaultContainer().privateCloudDatabase
//  
//  /* Defines our car types */
//  enum CarType: String{
//    case Estate = "Estate"
//    
//    func zoneId() -> CKRecordZoneID{
//      let zoneId = CKRecordZoneID(zoneName: self.rawValue,
//        ownerName: CKOwnerDefaultName)
//      return zoneId
//    }
//    
//  }
//  
//  /* Checks if the user has logged into her iCloud account or not */
//  func isIcloudAvailable() -> Bool{
//    if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
//      return true
//    } else {
//      return false
//    }
//  }
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    if isIcloudAvailable(){
//      displayAlertWithTitle("iCloud", message: "iCloud is not available." +
//        " Please sign into your iCloud account and restart this app")
//      return
//    }
//    
//    let makerToLookFor = "Volvo"
//    let smallestYearToLookFor = 2013
//    
//    let predicate = NSPredicate(format: "maker = %@ AND year >= %@",
//      makerToLookFor, smallestYearToLookFor as NSNumber)
//    
//    let query = CKQuery(recordType: "MyCar", predicate: predicate)
//    
//    database.performQuery(query, inZoneWithID: nil, completionHandler: {
//      (records: [AnyObject]!, error: NSError!) in
//      
//      if error != nil{
//        println("An error occurred while performing the query.")
//        println("Error = \(error)")
//      } else {
//        println("\(records.count) record(s) came back")
//        for record in records as [CKRecord]{
//          println("Record = \(record)")
//        }
//      }
//      
//      })
//    
//  }
//  
//  /* Just a little method to help us display alert dialogs to the user */
//  func displayAlertWithTitle(title: String, message: String){
//    let controller = UIAlertController(title: title,
//      message: message,
//      preferredStyle: .Alert)
//    
//    controller.addAction(UIAlertAction(title: "OK",
//      style: .Default,
//      handler: nil))
//    
//    presentViewController(controller, animated: true, completion: nil)
//    
//  }
//  
//}

/* 3 */
import UIKit
import CloudKit

class ViewController: UIViewController {
  
  let database = CKContainer.defaultContainer().privateCloudDatabase
  lazy var operationQueue = NSOperationQueue()
  
  /* Defines our car types */
  enum CarType: String{
    case Estate = "Estate"
    
    func zoneId() -> CKRecordZoneID{
      let zoneId = CKRecordZoneID(zoneName: self.rawValue,
        ownerName: CKOwnerDefaultName)
      return zoneId
    }
    
  }
  
  /* Checks if the user has logged into her iCloud account or not */
  func isIcloudAvailable() -> Bool{
    if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  func recordFetchBlock(record: CKRecord!){
    
    println("Fetched a record = \(record)")
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if isIcloudAvailable(){
      displayAlertWithTitle("iCloud", message: "iCloud is not available." +
        " Please sign into your iCloud account and restart this app")
      return
    }
    
    let makerToLookFor = "Volvo"
    let smallestYearToLookFor = 2013
    
    let predicate = NSPredicate(format: "maker = %@ AND year >= %@",
      makerToLookFor, NSNumber(integer: smallestYearToLookFor))
    
    let query = CKQuery(recordType: "MyCar", predicate: predicate)
    
    let operation = CKQueryOperation(query: query)
    operation.recordFetchedBlock = recordFetchBlock
    operation.queryCompletionBlock = {[weak self]
      (cursor: CKQueryCursor!, error: NSError!) in
      if cursor != nil{
        /* There is so much data that a cursor came back to us and we will
        need to fetch the rest of the results in a separate operation */
        println("A cursor was sent to us. Fetching the rest of the records...")
        let newOperation = CKQueryOperation(cursor: cursor)
        newOperation.recordFetchedBlock = self!.recordFetchBlock
        newOperation.queryCompletionBlock = operation.queryCompletionBlock
        self!.operationQueue.addOperation(newOperation)
      } else {
        println("No cursor came back. We've fetched all the data")
      }
    }
    
    operationQueue.addOperation(operation)
    
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

