//
//  AppDelegate.swift
//  Requesting Access to the Address Book
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
  var addressBook: ABAddressBookRef?
  
  func createAddressBook(){
    var error: Unmanaged<CFError>?
    
    addressBook = ABAddressBookCreateWithOptions(nil,
      &error).takeRetainedValue()
    
    /* You can use the address book here */
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        createAddressBook()
        /* Now you can use the address book */
      case .Denied:
        println("You are denied access to address book")
        
      case .NotDetermined:
        createAddressBook()
        if let theBook: ABAddressBookRef = addressBook{
          ABAddressBookRequestAccessWithCompletion(theBook,
            {(granted: Bool, error: CFError!) in
              
              if granted{
                println("Access is granted")
              } else {
                println("Access is not granted")
              }
              
            })
        }
        
      case .Restricted:
        println("Access is restricted")
        
      default:
        println("Unhandled")
      }
      
      return true
  }
  
}

