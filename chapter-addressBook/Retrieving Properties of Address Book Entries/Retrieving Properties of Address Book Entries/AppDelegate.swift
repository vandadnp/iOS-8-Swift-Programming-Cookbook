//
//  AppDelegate.swift
//  Retrieving Properties of Address Book Entries
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

/* 1 */
//import UIKit
//import AddressBook
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//    lazy var addressBook: ABAddressBookRef = {
//    var error: Unmanaged<CFError>?
//    return ABAddressBookCreateWithOptions(nil,
//      &error).takeRetainedValue() as ABAddressBookRef
//    }()
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      switch ABAddressBookGetAuthorizationStatus(){
//      case .Authorized:
//        println("Already authorized")
//        readAllPeopleInAddressBook(addressBook)
//      case .Denied:
//        println("You are denied access to address book")
//      case .NotDetermined:
//        ABAddressBookRequestAccessWithCompletion(addressBook,
//          {[weak self] (granted: Bool, error: CFError!) in
//            
//            if granted{
//              let strongSelf = self!
//              println("Access is granted")
//              strongSelf.readAllPeopleInAddressBook(strongSelf.addressBook)
//            } else {
//              println("Access is not granted")
//            }
//            
//          })
//      case .Restricted:
//        println("Access is restricted")
//        
//      default:
//        println("Unhandled")
//      }
//      
//      return true
//  }
//  
//  func readAllPeopleInAddressBook(addressBook: ABAddressBookRef){
//    
//    /* Get all the people in the address book */
//    let allPeople = ABAddressBookCopyArrayOfAllPeople(
//      addressBook).takeRetainedValue() as NSArray
//    
//    for person: ABRecordRef in allPeople{
//      
//      let firstName = ABRecordCopyValue(person,
//        kABPersonFirstNameProperty).takeRetainedValue() as String
//      
//      let lastName = ABRecordCopyValue(person,
//        kABPersonLastNameProperty).takeRetainedValue() as String
//      
//      let email: ABMultiValueRef = ABRecordCopyValue(person,
//        kABPersonEmailProperty).takeRetainedValue()
//      
//      println("First name = \(firstName)")
//      println("Last name = \(lastName)")
//      println("Email = \(email)")
//      
//    }
//    
//  }
//  
//}

/* 2 */
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
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        readAllPeopleInAddressBook(addressBook)
      case .Denied:
        println("You are denied access to address book")
        
      case .NotDetermined:
        ABAddressBookRequestAccessWithCompletion(addressBook,
          {[weak self] (granted: Bool, error: CFError!) in
            
            if granted{
              let strongSelf = self!
              println("Access is granted")
              strongSelf.readAllPeopleInAddressBook(strongSelf.addressBook)
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
  
  func readEmailsForPerson(person: ABRecordRef){
    
    let emails: ABMultiValueRef = ABRecordCopyValue(person,
      kABPersonEmailProperty).takeRetainedValue()
        
    for counter in 0..<ABMultiValueGetCount(emails){
      
      let email = ABMultiValueCopyValueAtIndex(emails,
        counter).takeRetainedValue() as String
      
      println(email)
      
    }
    
  }
  
  func readAllPeopleInAddressBook(addressBook: ABAddressBookRef){
    
    /* Get all the people in the address book */
    let allPeople = ABAddressBookCopyArrayOfAllPeople(
      addressBook).takeRetainedValue() as NSArray
    
    for person: ABRecordRef in allPeople{
      
      let firstName = ABRecordCopyValue(person,
        kABPersonFirstNameProperty).takeRetainedValue() as String
      let lastName = ABRecordCopyValue(person,
        kABPersonLastNameProperty).takeRetainedValue() as String
      
      println("First name = \(firstName)")
      println("Last name = \(lastName)")
      
      readEmailsForPerson(person)
      
    }
  }
  
}