//
//  ViewController.swift
//  Querying the Cloud with CloudKit
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
//        print("Found a person with first name equal or less than 6 letters")
//        print("First name = \(person.firstName)")
//        print("Last name = \(person.lastName)")
//      }
//    } else {
//      print("Could not find any items in the filtered array")
//
//    }
//
//  }
//
//}
//
//
///* 2 */
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
//    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
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
//      (records: [CKRecord]?, error: NSError?) in
//      
//      if error != nil{
//        print("An error occurred while performing the query.")
//        print("Error = \(error)")
//      } else {
//        
//        guard let records = records else {
//          return
//        }
//        
//        print("\(records.count) record(s) came back")
//        for record in records as [CKRecord]{
//          print("Record = \(record)")
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

///* 3 */
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
    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  func recordFetchBlock(record: CKRecord!){
    
    print("Fetched a record = \(record)")
    
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
    operation.queryCompletionBlock = {
      (cursor: CKQueryCursor?, error: NSError?) in
      
      guard let cursor = cursor else {
        print("No cursor came back. We've fetched all the data")
        return
      }
      
      /* There is so much data that a cursor came back to us and we will
      need to fetch the rest of the results in a separate operation */
      print("A cursor was sent to us. Fetching the rest of the records...")
      let newOperation = CKQueryOperation(cursor: cursor)
      newOperation.recordFetchedBlock = self.recordFetchBlock
      newOperation.queryCompletionBlock = operation.queryCompletionBlock
      self.operationQueue.addOperation(newOperation)
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

