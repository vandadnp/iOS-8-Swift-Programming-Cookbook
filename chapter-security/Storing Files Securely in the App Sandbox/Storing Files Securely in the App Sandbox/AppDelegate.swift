//
//  AppDelegate.swift
//  Storing Files Securely in the App Sandbox
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
  
  var filePath: String?{
    
    let fileManager = NSFileManager()
    
    do {
      let documentFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory,
        inDomain: .UserDomainMask,
        appropriateForURL: nil,
        create: true)
      
      let fileName = "MyFile.txt"
      let filePath =
      documentFolderUrl.path!.stringByAppendingPathComponent(fileName)
      
      return filePath
      
    } catch {
      //handle error
      print("Error")
    }
    
    
    return nil
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      /*
      Prerequisites:
      
      1) Sign with a valid provision profile
      2) Your profile has to have complete-file-protection enabled.
      3) Add Code Signing Entitlements to your project
      */
      
      let fileManager = NSFileManager()
      
      if let path = filePath{
        
        let dataToWrite = "Hello, World".dataUsingEncoding(
          NSUTF8StringEncoding,
          allowLossyConversion: false)
        
        let fileAttributes = [
          NSFileProtectionKey : NSFileProtectionComplete
        ]
        
        let wrote = fileManager.createFileAtPath(path,
          contents: dataToWrite,
          attributes: fileAttributes)
        
        if wrote{
          print("Successfully and securely stored the file")
        } else {
          print("Failed to write the file")
        }
        
      }
      
      return true
  }
  
}

