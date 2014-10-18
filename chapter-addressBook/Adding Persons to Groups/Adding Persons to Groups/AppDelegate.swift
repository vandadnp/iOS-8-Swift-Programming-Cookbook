//
//  AppDelegate.swift
//  Adding Persons to Groups
//
//  Created by Vandad Nahavandipoor on 7/27/14.
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
  
  func newPersonWithFirstName(firstName: String,
    lastName: String,
    inAddressBook: ABAddressBookRef) -> ABRecordRef?{
    
    let person: ABRecordRef = ABPersonCreate().takeRetainedValue()
    
    let couldSetFirstName = ABRecordSetValue(person,
      kABPersonFirstNameProperty,
      firstName as CFTypeRef,
      nil)
    
    let couldSetLastName = ABRecordSetValue(person,
      kABPersonLastNameProperty,
      lastName as CFTypeRef,
      nil)
    
    var error: Unmanaged<CFErrorRef>? = nil
    
    let couldAddPerson = ABAddressBookAddRecord(inAddressBook, person, &error)
    
    if couldAddPerson{
      println("Successfully added the person")
    } else {
      println("Failed to add the person.")
      return nil
    }
    
    if ABAddressBookHasUnsavedChanges(inAddressBook){
      
      var error: Unmanaged<CFErrorRef>? = nil
      let couldSaveAddressBook = ABAddressBookSave(inAddressBook, &error)
      
      if couldSaveAddressBook{
        println("Successfully saved the address book")
      } else {
        println("Failed to save the address book.")
      }
    }
    
    if couldSetFirstName && couldSetLastName{
      println("Successfully set the first name " +
        "and the last name of the person")
    } else {
      println("Failed to set the first name and/or " +
        "the last name of the person")
    }
    
    return person
    
  }
  
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
  
  func addPerson(person: ABRecordRef,
    toGroup: ABRecordRef,
    saveToAddressBook: ABAddressBookRef) -> Bool{
      
      var error: Unmanaged<CFErrorRef>? = nil
      var added = false
      
      /* Now attempt to add the person entry to the group */
      added = ABGroupAddMember(toGroup,
        person,
        &error)
      
      if added == false{
        println("Could not add the person to the group")
        return false
      }
      
      /* Make sure we save any unsaved changes */
      if ABAddressBookHasUnsavedChanges(saveToAddressBook){
        error = nil
        let couldSaveAddressBook = ABAddressBookSave(saveToAddressBook,
          &error)
        if couldSaveAddressBook{
          println("Successfully added the person to the group")
          added = true
        } else {
          println("Failed to save the address book")
        }
      } else {
        println("No changes were saved")
      }
      
      return added
      
  }
  
  func addPersonsAndGroupsToAddressBook(addressBook: ABAddressBookRef){
    
    let richardBranson: ABRecordRef? = newPersonWithFirstName("Richard",
      lastName: "Branson",
      inAddressBook: addressBook)
    
    if let richard: ABRecordRef = richardBranson{
      let entrepreneursGroup: ABRecordRef? = newGroupWithName("Entrepreneurs",
        inAddressBook: addressBook)
      
      if let group: ABRecordRef = entrepreneursGroup{
        if addPerson(richard, toGroup: group, saveToAddressBook: addressBook){
          println("Successfully added Richard Branson to the group")
        } else {
          println("Failed to add Richard Branson to the group")
        }
                
      } else {
        println("Failed to create the group")
      }
      
    } else {
      println("Failed to create an entity for Richard Branson")
    }
    
  }
  
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        addPersonsAndGroupsToAddressBook(addressBook)
      case .Denied:
        println("You are denied access to address book")
      case .NotDetermined:
        ABAddressBookRequestAccessWithCompletion(addressBook,
          {[weak self] (granted: Bool, error: CFError!) in
            
            if granted{
              let strongSelf = self!
              println("Access is granted")
              strongSelf.addPersonsAndGroupsToAddressBook(
                strongSelf.addressBook)
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

