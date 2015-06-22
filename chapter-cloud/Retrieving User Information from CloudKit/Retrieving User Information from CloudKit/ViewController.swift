//
//  ViewController.swift
//  Retrieving User Information from CloudKit
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

///* 1 */
//import UIKit
//import CloudKit
//
//class ViewController: UIViewController {
//
//  func retrieveUserInformation(){
//
//    print("Retrieving user information...")
//
//    let container = CKContainer.defaultContainer()
//    let database = CKContainer.defaultContainer().publicCloudDatabase
//
//    container.fetchUserRecordIDWithCompletionHandler{
//      (recordId: CKRecordID?, error: NSError?) in
//
//      if error != nil{
//        print("Could not receive the record ID")
//
//        if error!.code == CKErrorCode.NotAuthenticated.rawValue{
//          print("This user is not logged into iCloud")
//        } else {
//          print("I cannot understand this error = \(error)")
//        }
//
//      } else {
//
//        print("Fetched the user ID")
//        print("Record Name = \(recordId!.recordName)")
//
//        database.fetchRecordWithID(recordId!,
//          completionHandler: {(record: CKRecord?, error: NSError?) in
//
//            if error != nil{
//              print("Error in fetching user. Error = \(error)")
//            } else {
//
//              if record!.recordType == CKRecordTypeUserRecord{
//                print("Successfully fetched the user record")
//
//                /* You can add some objects to this user if you want to
//                and save it back to the database */
//
//              } else {
//                print("The record that came back is not a user record")
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
//    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
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
//
///* 2 */
//import UIKit
//import CloudKit
//
//class ViewController: UIViewController {
//  
//  let container = CKContainer.defaultContainer()
//  
//  func retrieveUserInformation(){
//    
//    print("Retrieving user information...")
//    container.fetchUserRecordIDWithCompletionHandler{
//      (recordId: CKRecordID?, error: NSError?) in
//      
//      if error != nil{
//        print("Could not receive the record ID. Error = \(error)")
//      } else {
//        
//        print("Fetched the user ID")
//        print("Record Name = \(recordId!.recordName)")
//        
//        self.container.discoverUserInfoWithUserRecordID(recordId!,
//          completionHandler: {
//            (userInfo: CKDiscoveredUserInfo?, error: NSError?) in
//            
//            if error != nil{
//              print("Error in fetching user. Error = \(error)")
//            } else {
//              
//              /* You have access to the record ID as wel in
//              userInfo.userRecordID */
//              
//              print("First name = \(userInfo!.firstName)")
//              print("Last name = \(userInfo!.lastName)")
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
//    print("Requesting permission to access user's information...")
//    
//    container.requestApplicationPermission(.PermissionUserDiscoverability,
//      completionHandler: {
//        (status: CKApplicationPermissionStatus, error: NSError?) in
//        
//        if error != nil{
//          print("Error happened = \(error)")
//        } else {
//          
//          switch status{
//          case .Granted:
//            print("Access is granted. Processing...")
//            self.retrieveUserInformation()
//          default:
//            print("We do not have permission to user's information")
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
//    print("Retrieving permissions...")
//    container.statusForApplicationPermission(.PermissionUserDiscoverability,
//      completionHandler: {
//        (status: CKApplicationPermissionStatus, error: NSError?) in
//        
//        if error != nil{
//          print("Error happened = \(error)")
//        } else {
//          
//          switch status{
//          case .Granted:
//            print("Access is granted. Processing...")
//            self.retrieveUserInformation()
//          case .InitialState:
//            self.requestPermissionToAccessUserInformation()
//          default:
//            print("We do not have permission to user's information")
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
//    if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
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
//
///* 3 */
import UIKit
import CloudKit

class ViewController: UIViewController {
  
  let container = CKContainer.defaultContainer()
  
  func retrieveUserContactInformation(){
    
    print("Discovering all user's contacts' iCloud information...")
    
    container.discoverAllContactUserInfosWithCompletionHandler{
      (userInfos: [CKDiscoveredUserInfo]?, error: NSError?) in
      
      if error != nil{
        print("An error occurred. Error = \(error)")
      } else {
        
        print("\(userInfos!.count) resuls came back")
        
        for userInfo in userInfos! as [CKDiscoveredUserInfo]{
          print("Found contact's information")
          print("First name = \(userInfo.firstName)")
          print("Last name = \(userInfo.lastName)")
          
        }
      }
      
    }
    
  }
  
  func requestPermissionToAccessUserInformation(){
    
    print("Requesting permission to access user's information...")
    
    container.requestApplicationPermission(.PermissionUserDiscoverability,
      completionHandler: {
        (status: CKApplicationPermissionStatus, error: NSError?) in
        
        if error != nil{
          print("Error happened = \(error)")
        } else {
          
          switch status{
          case .Granted:
            print("Access is granted. Processing...")
            self.retrieveUserContactInformation()
          default:
            print("We do not have permission to user's information")
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
    
    print("Retrieving permissions...")
    container.statusForApplicationPermission(.PermissionUserDiscoverability,
      completionHandler: {
        (status: CKApplicationPermissionStatus, error: NSError?) in
        
        if error != nil{
          print("Error happened = \(error)")
        } else {
          
          switch status{
          case .Granted:
            print("Access is granted. Processing...")
            self.retrieveUserContactInformation()
          case .InitialState:
            self.requestPermissionToAccessUserInformation()
          default:
            print("We do not have permission to user's information")
          }
          
        }
        
      })
    
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
