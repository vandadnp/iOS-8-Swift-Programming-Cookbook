//
//  AppDelegate.swift
//  Finding Values in the Keychain
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

/* 1 */
//import UIKit
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//
//      let keyToSearchFor = "Full Name"
//      let service = NSBundle.mainBundle().bundleIdentifier!
//
//      let query = [
//        kSecClass as NSString :
//        kSecClassGenericPassword as NSString,
//
//        kSecAttrService as NSString : service,
//        kSecAttrAccount as NSString : keyToSearchFor,
//        kSecReturnAttributes as NSString : kCFBooleanTrue,
//      ] as NSDictionary
//
//
//      var valueAttributes: Unmanaged<AnyObject>? = nil
//      let results = Int(SecItemCopyMatching(query, &valueAttributes))
//
//      if results == errSecSuccess{
//
//        let attributes = valueAttributes!.takeRetainedValue() as NSDictionary
//
//        let key = attributes[kSecAttrAccount as NSString]
//          as String
//
//        let accessGroup = attributes[kSecAttrAccessGroup as NSString] as String
//
//        let creationDate = attributes[kSecAttrCreationDate as NSString] as NSDate
//
//        let modifiedDate = attributes[
//          kSecAttrModificationDate as NSString] as NSDate
//
//        let serviceValue = attributes[kSecAttrService as NSString] as String
//
//        println("Key = \(key)")
//        println("Access Group = \(accessGroup)")
//        println("Creation Date = \(creationDate)")
//        println("Modification Date = \(modifiedDate)")
//        println("Service = \(serviceValue)")
//
//      } else {
//        println("Error happened with code: \(results)")
//      }
//
//    return true
//  }
//
//}

/* 2 */
import UIKit
import Security

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

func application(application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

    let keyToSearchFor = "Full Name"
    let service = NSBundle.mainBundle().bundleIdentifier!

    let query = [
      kSecClass as NSString :
      kSecClassGenericPassword as NSString,

      kSecAttrService as NSString : service,
      kSecAttrAccount as NSString : keyToSearchFor,
      kSecReturnData as NSString : kCFBooleanTrue,
      ] as NSDictionary

    var returnedData: Unmanaged<AnyObject>? = nil
    let results = Int(SecItemCopyMatching(query, &returnedData))

    if results == errSecSuccess{

      let data = returnedData!.takeRetainedValue() as NSData

      let value = NSString(data: data, encoding: NSUTF8StringEncoding)

      println("Value = \(value)")

    } else {
      println("Error happened with code: \(results)")
    }

    return true
}

}