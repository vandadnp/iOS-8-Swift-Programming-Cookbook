//
//  ViewController.swift
//  Querying the Cloud with CloudKit
//
//  Created by vandad on 197//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
  
  let database = CKContainer.defaultContainer().privateCloudDatabase
  lazy var operationQueue = NSOperationQueue()
  
  /* Defines our car types */
  enum CarType: String{
    case Estate = "Estate"
    
    func zoneId() -> CKRecordZoneID{
      let zoneId = CKRecordZoneID(zoneName: self.toRaw(),
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
      makerToLookFor, smallestYearToLookFor as NSNumber)
    
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

