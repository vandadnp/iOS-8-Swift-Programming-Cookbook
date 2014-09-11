//
//  ViewController.swift
//  Retrieving User Information from CloudKit
//
//  Created by vandad on 197//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

/* 1 */
//import UIKit
//import CloudKit
//
//class ViewController: UIViewController {
//
//  func retrieveUserInformation(){
//
//    println("Retrieving user information...")
//
//    let container = CKContainer.defaultContainer()
//    let database = CKContainer.defaultContainer().publicCloudDatabase
//
//    container.fetchUserRecordIDWithCompletionHandler{
//      (recordId: CKRecordID!, error: NSError!) in
//
//      if error != nil{
//        println("Could not receive the record ID")
//
//        if CKErrorCode.fromRaw(error.code)! == .NotAuthenticated{
//          println("This user is not logged into iCloud")
//        } else {
//          println("I cannot understand this error = \(error)")
//        }
//
//      } else {
//
//        println("Fetched the user ID")
//        println("Record Name = \(recordId.recordName)")
//
//        database.fetchRecordWithID(recordId,
//          completionHandler: {(record: CKRecord!, error: NSError!) in
//
//            if error != nil{
//              println("Error in fetching user. Error = \(error)")
//            } else {
//
//              if record.recordType == CKRecordTypeUserRecord{
//                println("Successfully fetched the user record")
//
//                /* You can add some objects to this user if you want to
//                and save it back to the database */
//
//              } else {
//                println("The record that came back is not a user record")
//              }
//
//            }
//
//          })
//
//      }
//
//    }
//
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
//    retrieveUserInformation()
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

/* 2 */
//import UIKit
//import CloudKit
//
//class ViewController: UIViewController {
//  
//  let container = CKContainer.defaultContainer()
//  
//  func retrieveUserInformation(){
//    
//    println("Retrieving user information...")
//    container.fetchUserRecordIDWithCompletionHandler{[weak self]
//      (recordId: CKRecordID!, error: NSError!) in
//      
//      if error != nil{
//        println("Could not receive the record ID. Error = \(error)")
//      } else {
//        
//        println("Fetched the user ID")
//        println("Record Name = \(recordId.recordName)")
//        
//        self!.container.discoverUserInfoWithUserRecordID(recordId,
//          completionHandler: {
//            (userInfo: CKDiscoveredUserInfo!, error: NSError!) in
//            
//            if error != nil{
//              println("Error in fetching user. Error = \(error)")
//            } else {
//              
//              /* You have access to the record ID as wel in
//              userInfo.userRecordID */
//              
//              println("First name = \(userInfo.firstName)")
//              println("Last name = \(userInfo.lastName)")
//              
//            }
//            
//          })
//        
//      }
//      
//    }
//    
//  }
//  
//  func requestPermissionToAccessUserInformation(){
//    
//    println("Requesting permission to access user's information...")
//    
//    container.requestApplicationPermission(.PermissionUserDiscoverability,
//      completionHandler: {[weak self]
//        (status: CKApplicationPermissionStatus, error: NSError!) in
//        
//        if error != nil{
//          println("Error happened = \(error)")
//        } else {
//          
//          switch status{
//          case .Granted:
//            println("Access is granted. Processing...")
//            self!.retrieveUserInformation()
//          default:
//            println("We do not have permission to user's information")
//          }
//          
//        }
//        
//      })
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
//    println("Retrieving permissions...")
//    container.statusForApplicationPermission(.PermissionUserDiscoverability,
//      completionHandler: {[weak self]
//        (status: CKApplicationPermissionStatus, error: NSError!) in
//        
//        if error != nil{
//          println("Error happened = \(error)")
//        } else {
//          
//          switch status{
//          case .Granted:
//            println("Access is granted. Processing...")
//            self!.retrieveUserInformation()
//          case .InitialState:
//            self!.requestPermissionToAccessUserInformation()
//          default:
//            println("We do not have permission to user's information")
//          }
//          
//        }
//        
//      })
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
  
  let container = CKContainer.defaultContainer()
  
  func retrieveUserContactInformation(){
    
    println("Discovering all user's contacts' iCloud information...")
    
    container.discoverAllContactUserInfosWithCompletionHandler{
      (userInfos: [AnyObject]!, error: NSError!) in
      
      if error != nil{
        println("An error occurred. Error = \(error)")
      } else {
        
        println("\(userInfos.count) resuls came back")
        
        for userInfo in userInfos as [CKDiscoveredUserInfo]{
          
          println("Found contact's information")
          println("First name = \(userInfo.firstName)")
          println("Last name = \(userInfo.lastName)")
          
        }
      }
      
    }
    
  }
  
  func requestPermissionToAccessUserInformation(){
    
    println("Requesting permission to access user's information...")
    
    container.requestApplicationPermission(.PermissionUserDiscoverability,
      completionHandler: {[weak self]
        (status: CKApplicationPermissionStatus, error: NSError!) in
        
        if error != nil{
          println("Error happened = \(error)")
        } else {
          
          switch status{
          case .Granted:
            println("Access is granted. Processing...")
            self!.retrieveUserContactInformation()
          default:
            println("We do not have permission to user's information")
          }
          
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
    
    println("Retrieving permissions...")
    container.statusForApplicationPermission(.PermissionUserDiscoverability,
      completionHandler: {[weak self]
        (status: CKApplicationPermissionStatus, error: NSError!) in
        
        if error != nil{
          println("Error happened = \(error)")
        } else {
          
          switch status{
          case .Granted:
            println("Access is granted. Processing...")
            self!.retrieveUserContactInformation()
          case .InitialState:
            self!.requestPermissionToAccessUserInformation()
          default:
            println("We do not have permission to user's information")
          }
          
        }
        
      })
    
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