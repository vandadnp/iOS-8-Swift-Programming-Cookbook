//
//  AppDelegate.swift
//  Searching the Address Book
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
  
  func doesPersonExistWithFirstName(firstName paramFirstName: String,
    lastName paramLastName: String,
    inAddressBook addressBook: ABAddressBookRef) -> Bool{
      
      var exists = false
      let people = ABAddressBookCopyArrayOfAllPeople(
        addressBook).takeRetainedValue() as NSArray as [ABRecordRef]
      
      for person: ABRecordRef in people{
        
        let firstName = ABRecordCopyValue(person,
          kABPersonFirstNameProperty).takeRetainedValue() as String
        
        let lastName = ABRecordCopyValue(person,
          kABPersonLastNameProperty).takeRetainedValue() as String
                      
            if firstName == paramFirstName &&
              lastName == paramLastName{
                return true
            }
            
      }
      return false
  }
  
  func doesGroupExistWithGroupName(name: String,
    inAddressBook addressBook: ABAddressBookRef) -> Bool{
      
      let groups = ABAddressBookCopyArrayOfAllGroups(
        addressBook).takeRetainedValue() as NSArray as [ABRecordRef]
      
      for group: ABRecordRef in groups{
        
        let groupName = ABRecordCopyValue(group,
          kABGroupNameProperty).takeRetainedValue() as String
        
        if groupName == name{
          return true
        }
        
      }
      return false
  }
  
  func doesPersonExistWithFullName(fullName: String,
    inAddressBook addressBook: ABAddressBookRef) -> Bool{
      
      let people = ABAddressBookCopyPeopleWithName(addressBook,
        fullName as NSString as CFStringRef).takeRetainedValue() as NSArray
      
        if people.count > 0{
          return true
        }
      
      return false

  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        if doesPersonExistWithFullName("Richard Branson",
          inAddressBook: addressBook){
            println("This person exists")
        } else {
            println("This person doesn't exist")
        }
      case .Denied:
        println("You are denied access to address book")
        
      case .NotDetermined:
        ABAddressBookRequestAccessWithCompletion(addressBook,
          {[weak self] (granted: Bool, error: CFError!) in
            
            if granted{
              let strongSelf = self!
              println("Access is granted")
              if strongSelf.doesPersonExistWithFullName("Richard Branson",
                inAddressBook: strongSelf.addressBook){
                println("This person exists")
              } else {
                println("This person doesn't exist")
              }
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

