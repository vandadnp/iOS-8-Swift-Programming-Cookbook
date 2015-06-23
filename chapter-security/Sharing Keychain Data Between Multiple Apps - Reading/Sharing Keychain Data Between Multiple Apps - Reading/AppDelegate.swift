//
//  AppDelegate.swift
//  Sharing Keychain Data Between Multiple Apps - Reading
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      let key = "Full Name"
      
      /* This is the bundle ID of the app that wrote the data to the keychain.
      This is NOT this app's bundle ID */
      let service = "com.pixolity.ios.cookbook.app"
      
      let accessGroup = "F3FU372W5M.*"
      
      let query = [
        kSecClass as String :
        kSecClassGenericPassword as String,
        
        kSecAttrService as String : service,
        kSecAttrAccessGroup as String : accessGroup,
        kSecAttrAccount as String : key,
        kSecReturnData as String : kCFBooleanTrue,
        ]
      
      
      var returnedData: Unmanaged<AnyObject>? = nil
      let results = Int(SecItemCopyMatching(query, &returnedData))
      
      if results == Int(errSecSuccess){
        
        let data = returnedData!.takeRetainedValue() as! NSData
        
        let value = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        print("Value = \(value)")
        
      } else {
        print("Error happened with code: \(results)")
      }

    return true
  }
  
}

