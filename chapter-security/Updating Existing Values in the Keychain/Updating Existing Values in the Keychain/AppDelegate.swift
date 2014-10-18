//
//  AppDelegate.swift
//  Updating Existing Values in the Keychain
//
//  Created by Vandad Nahavandipoor on 7/7/14.
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
import Security

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  
  func readExistingValue(){
    let keyToSearchFor = "Full Name"
    let service = NSBundle.mainBundle().bundleIdentifier!
    
    let query = [
      kSecClass as NSString :
      kSecClassGenericPassword as NSString,
      
      kSecAttrService as NSString : service,
      kSecAttrAccount as NSString : keyToSearchFor,
      kSecReturnAttributes as NSString : kCFBooleanTrue,
      
      ] as NSDictionary
    
    var returnedAttributes: Unmanaged<AnyObject>? = nil
    let results = Int(SecItemCopyMatching(query, &returnedAttributes))
    
    if results == errSecSuccess{
      
      let attributes = returnedAttributes!.takeRetainedValue() as NSDictionary
      
      let comments = attributes[kSecAttrComment as NSString] as String
      
      println("Comments = \(comments)")
      
    } else {
      println("Error happened with code: \(results)")
    }
  }

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
      let keyToSearchFor = "Full Name"
      let service = NSBundle.mainBundle().bundleIdentifier!
      
      let query = [
        kSecClass as NSString :
      kSecClassGenericPassword as NSString,
        
        kSecAttrService as NSString : service,
        kSecAttrAccount as NSString : keyToSearchFor,
      ] as NSDictionary
      
      var result: Unmanaged<AnyObject>? = nil
      let found = Int(SecItemCopyMatching(query, &result))
      
      if found == errSecSuccess{
        
        let newData = "Mark Tremonti".dataUsingEncoding(NSUTF8StringEncoding,
          allowLossyConversion: false)
        
        let update = [
          kSecValueData as NSString : newData!,
          kSecAttrComment as NSString : "My comments"
        ] as NSDictionary
        
        let updated = Int(SecItemUpdate(query, update))
        
        if updated == errSecSuccess{
          println("Successfully updated the existing value")
          readExistingValue()
        } else {
          println("Failed to update the value. Error = \(updated)")
        }
        
      } else {
        println("Error happened. Code = \(found)")
      }
    
    
    return true
  }

}

