//
//  AppDelegate.swift
//  Enumerating Files and Folders
//
//  Created by Vandad Nahavandipoor on 6/23/14.
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

/* 1 */
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      let fileManager = NSFileManager()
//      let bundleDir = NSBundle.mainBundle().bundlePath
//      
//      do{
//        let bundleContents = try fileManager.contentsOfDirectoryAtPath(bundleDir)
//        if bundleContents.count == 0{
//          print("The app bundle is empty!")
//        } else {
//          print("The app bundle contents = \(bundleContents)")
//        }
//      } catch let error as NSError{
//        print("Could not read the contents. Error = \(error)")
//      }
//      
//      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//      // Override point for customization after application launch.
//      self.window!.backgroundColor = UIColor.whiteColor()
//      self.window!.makeKeyAndVisible()
//      return true
//  }
//  
//}
//
///* 2 */
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func contentsOfAppBundle() -> [NSURL]{

    let propertiesToGet = [
      NSURLIsDirectoryKey,
      NSURLIsReadableKey,
      NSURLCreationDateKey,
      NSURLContentAccessDateKey,
      NSURLContentModificationDateKey
    ]

    let fileManager = NSFileManager()
    let bundleUrl = NSBundle.mainBundle().bundleURL
    
    do{
      let contents = try fileManager.contentsOfDirectoryAtURL(bundleUrl,
        includingPropertiesForKeys: propertiesToGet,
        options: []) as [NSURL]
      return contents
    } catch let error as NSError{
      print("An error occurred \(error)")
      return []
    }

  }

  func stringValueOfBoolProperty(property: String, url: NSURL) -> String{
    var value:AnyObject?

    do{
      try url.getResourceValue(&value, forKey: property)
      let number = value as! NSNumber
      return number.boolValue ? "YES" : "NO"
    } catch let error as NSError{
      print(error)
    }
    
    return "NO"
  }

  func isUrlDirectory(url: NSURL) -> String{
    return stringValueOfBoolProperty(NSURLIsDirectoryKey, url: url)
  }

  func isUrlReadable(url: NSURL) -> NSString{
    return stringValueOfBoolProperty(NSURLIsReadableKey, url: url)
  }


  func dateOfType(type: String, url: NSURL) -> NSDate?{
    var value:AnyObject?
    
    do{
      try url.getResourceValue(&value, forKey: type)
      return value as? NSDate
    } catch let error as NSError{
      print(error)
    }
    
    return nil
  }

  func printUrlPropertiesToConsole(url: NSURL){
    print("URL name = \(url.lastPathComponent)")
    print("Is a Directory? \(isUrlDirectory(url))")
    print("Is Readable? \(isUrlReadable(url))")

    if let creationDate = dateOfType(NSURLCreationDateKey, url: url){
      print("Creation Date = \(creationDate)")
    }

    if let accessDate = dateOfType(NSURLContentAccessDateKey, url: url){
      print("Access Date = \(accessDate)")
    }

    if let modificationDate =
      dateOfType(NSURLContentModificationDateKey, url: url){
        print("Modification Date = \(modificationDate)")
    }

    print("-----------------------------------")

  }

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

    let appBundleContents = contentsOfAppBundle()

    for url in appBundleContents{
      printUrlPropertiesToConsole(url)
    }

    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }
  
}



