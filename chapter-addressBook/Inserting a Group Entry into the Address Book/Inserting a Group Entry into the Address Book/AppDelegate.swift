//
//  AppDelegate.swift
//  Inserting a Group Entry into the Address Book
//
//  Created by Vandad Nahavandipoor on 7/26/14.
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
import AddressBook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  lazy var addressBook: ABAddressBookRef = {
    var error: Unmanaged<CFError>?
    return ABAddressBookCreateWithOptions(nil,
      &error).takeRetainedValue() as ABAddressBookRef
  }()
  
  func newGroupWithName(name: String, inAddressBook: ABAddressBookRef) ->
    ABRecordRef?{
      
      let group: ABRecordRef = ABGroupCreate().takeRetainedValue()
      
      var error: Unmanaged<CFError>?
      let couldSetGroupName = ABRecordSetValue(group,
        kABGroupNameProperty, name, &error)
      
      if couldSetGroupName{
        
        error = nil
        let couldAddRecord = ABAddressBookAddRecord(inAddressBook,
          group,
          &error)
        
        if couldAddRecord{
          
          println("Successfully added the new group")
          
          if ABAddressBookHasUnsavedChanges(inAddressBook){
            error = nil
            let couldSaveAddressBook =
            ABAddressBookSave(inAddressBook, &error)
            if couldSaveAddressBook{
              println("Successfully saved the address book")
            } else {
              println("Failed to save the address book")
              return nil
            }
          } else {
            println("No unsaved changes")
            return nil
          }
        } else {
          println("Could not add a new group")
          return nil
        }
      } else {
        println("Failed to set the name of the group")
        return nil
      }
      
      return group
      
  }
  
  func createNewGroupInAddressBook(addressBook: ABAddressBookRef){
    
    let personalCoachesGroup: ABRecordRef? =
    newGroupWithName("Personal Coaches",
      inAddressBook: addressBook)
    
    if let group: ABRecordRef = personalCoachesGroup{
      println("Successfully created the group")
    } else {
      println("Could not create the group")
    }
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        createNewGroupInAddressBook(addressBook)
      case .Denied:
        println("You are denied access to address book")
        
      case .NotDetermined:
        ABAddressBookRequestAccessWithCompletion(addressBook,
          {[weak self] (granted: Bool, error: CFError!) in
            
            if granted{
              let strongSelf = self!
              println("Access is granted")
              strongSelf.createNewGroupInAddressBook(strongSelf.addressBook)
            } else {
              println("Access is not granted")
            }
            
          })
      case .Restricted:
        println("Access is restricted")
        
      default:
        println("Unhandled")
      }
      
      return true
  }
}

