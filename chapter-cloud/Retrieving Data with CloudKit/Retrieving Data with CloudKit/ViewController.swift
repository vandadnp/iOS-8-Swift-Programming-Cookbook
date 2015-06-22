//
//  ViewController.swift
//  Retrieving Data with CloudKit
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
  
  /* This method generates a record ID and keeps it in the system defaults
  so that the second time it is called, it will generate the exact same record
  ID like before which we can use to find the stored record in the database */
  func recordId() -> CKRecordID{
    
    /* The key into NSUserDefaults */
    let key = "recordId"
    
    var recordName =
    NSUserDefaults.standardUserDefaults().stringForKey(key)
    
    func createNewRecordName(){
      print("No record name was previously generated")
      print("Creating a new one...")
      recordName = NSUUID().UUIDString
      NSUserDefaults.standardUserDefaults().setValue(recordName, forKey: key)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    if let name = recordName{
      if name.characters.count == 0{
        createNewRecordName()
      } else {
        print("The previously generated record ID was recovered")
      }
    } else {
      createNewRecordName()
    }
    
    return CKRecordID(recordName: recordName!, zoneID: CarType.Estate.zoneId())
    
  }
  
  func saveRecordWithCompletionHandler(completionHandler:
    (succeeded: Bool, error: NSError!) -> Void){
      
      /* Store information about a Volvo V50 car */
      let volvoV50 = CKRecord(recordType: "MyCar", recordID: recordId())
      volvoV50.setObject("Volvo", forKey: "maker")
      volvoV50.setObject("V50", forKey: "model")
      volvoV50.setObject(5, forKey: "numberOfDoors")
      volvoV50.setObject(2015, forKey: "year")
      
      /* Save this record publicly */
      database.saveRecord(volvoV50, completionHandler: {
        (record: CKRecord?, error: NSError?) in
        completionHandler(succeeded: (error == nil), error: error)
        })
      
  }
  
  /* 1 */
//    override func viewDidAppear(animated: Bool) {
//      super.viewDidAppear(animated)
//  
//      if isIcloudAvailable(){
//        displayAlertWithTitle("iCloud", message: "iCloud is not available." +
//          " Please sign into your iCloud account and restart this app")
//        return
//      }
//  
//      print("Fetching the record to see if it exists already...")
//  
//      /* Attempt to find the record if we have saved it already */
//      database.fetchRecordWithID(recordId(), completionHandler:{
//        (record: CKRecord?, error: NSError?) in
//        
//        guard let error = error else {
//          print("Seems like we had previously stored the record. Great!")
//          print("Retrieved record = \(record)")
//          return
//        }
//  
//        print("An error occurred")
//        
//        if error.code == CKErrorCode.UnknownItem.rawValue{
//          print("This error means that the record was not found.")
//          print("Saving the record...")
//          
//          self.saveRecordWithCompletionHandler{
//            (succeeded: Bool, error: NSError!) in
//            
//            if succeeded{
//              print("Successfully saved the record")
//            } else {
//              print("Failed to save the record. Error = \(error)")
//            }
//            
//          }
//          
//        } else {
//          print("I don't understand this error. Error = \(error)")
//        }
//  
//        })
//  
//    }
  
  
  
  /* 2 */
  
  enum Color : String{
    case Red = "Red"
    case Blue = "Blue"
    case Green = "Green"
    case Yellow = "Yellow"
    
    static let allColors = [Red, Blue, Green, Yellow]
    
    static func randomColor() -> Color{
      let colorIndex = Int(arc4random_uniform(UInt32(allColors.count)))
      return Color.allColors[colorIndex]
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if isIcloudAvailable(){
      displayAlertWithTitle("iCloud", message: "iCloud is not available." +
        " Please sign into your iCloud account and restart this app")
      return
    }
    
    print("Fetching the record to see if it exists already...")
    
    /* Attempt to find the record if we have saved it already */
    database.fetchRecordWithID(recordId(), completionHandler:{
      (record: CKRecord?, error: NSError?) in
      
      if error != nil{
        print("An error occurred")
        
        if error!.code == CKErrorCode.UnknownItem.rawValue{
          print("This error means that the record was not found.")
          print("Saving the record...")
          
          self.saveRecordWithCompletionHandler{
            (succeeded: Bool, error: NSError!) in
            
            if succeeded{
              print("Successfully saved the record")
            } else {
              print("Failed to save the record. Error = \(error)")
            }
            
          }
          
        } else {
          print("I don't understand this error. Error = \(error)")
        }
        
      } else {
        print("Seems like we had previously stored the record. Great!")
        print("Retrieved record = \(record)")
        
        guard let record = record else {
          print("The record is nil")
          return
        }
        
        /* Now make your changes to the record */
        let colorKey = "color"
        let newColor = Color.randomColor().rawValue
        var oldColor = record.valueForKey(colorKey) as? String
        if oldColor == nil{
          oldColor = "Unknown"
        }
        print("Changing the car color from \(oldColor) to \(newColor)")
        record.setValue(newColor, forKey:colorKey)
        self.database.saveRecord(record, completionHandler:
          {(record:CKRecord?, error: NSError?) in
            
            if error == nil{
              print("Successfully modified the record")
            } else {
              print("Failed to modify the record. Error = \(error)")
            }
            
          })
        
      }
      
      })
    
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

