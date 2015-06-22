//
//  AppDelegate.swift
//  Creating and Managing Folders for Apps in iCloud
//
//  Created by Vandad Nahavandipoor on 7/11/14.
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
//  let fileManager = NSFileManager()
//  var documentsDirectory: String?
//
//  func doesDocumentsDirectoryExist() -> Bool{
//    var isDirectory = false as ObjCBool
//
//    if let directory = documentsDirectory{
//      if fileManager.fileExistsAtPath(directory,
//        isDirectory: &isDirectory){
//          if isDirectory{
//            return true
//          }
//      }
//    }
//
//    return false
//  }
//
//  func createDocumentsDirectory(){
//    print("Must create the directory.")
//
//    var directoryCreationError: NSError?
//
//    if let directory = documentsDirectory{
//      do {
//        try fileManager.createDirectoryAtPath(directory,
//                withIntermediateDirectories:true,
//                attributes:nil)
//          print("Successfully created the folder")
//      } catch let error1 as NSError {
//        directoryCreationError = error1
//        if let error = directoryCreationError{
//          print("Failed to create the folder with error = \(error)")
//        }
//      }
//    } else {
//      print("The directory was nil")
//    }
//
//  }
//
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//    [NSObject : AnyObject]?) -> Bool {
//
//      let containerURL =
//      fileManager.URLForUbiquityContainerIdentifier(nil)
//
//      documentsDirectory =
//      containerURL!.path!.stringByAppendingPathComponent("Documents")
//
//      if doesDocumentsDirectoryExist(){
//        print("This folder already exists.")
//      } else {
//        createDocumentsDirectory()
//      }
//
//      return true
//  }
//
//}
//
/* 2 */
import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let fileManager = NSFileManager()
  var documentsDirectory: String?
  
  func storeFile(){
    print("Storing a file in the directory...")
    
    if let _ = documentsDirectory{
      
      let path =
      documentsDirectory!.stringByAppendingPathComponent("File.txt")
      
      var writingError: NSError?
      
      do {
        try "Hello, World!".writeToFile(path,
                atomically: true,
                encoding: NSUTF8StringEncoding)
          print("Successfully saved the file")
      } catch let error1 as NSError {
        writingError = error1
        if let error = writingError{
          print("An error occurred while writing the file = \(error)")
        }
      }
      
    } else {
      print("The directory was nil")
    }
    
  }
  
  func doesDocumentsDirectoryExist() -> Bool{
    var isDirectory = false as ObjCBool
    
    if let directory = documentsDirectory{
      if fileManager.fileExistsAtPath(directory,
        isDirectory: &isDirectory){
          if isDirectory{
            return true
          }
      }
    }
    
    return false
  }
  
  func createDocumentsDirectory(){
    print("Must create the directory.")
    
    var directoryCreationError: NSError?
    
    if let directory = documentsDirectory{
      do {
        try fileManager.createDirectoryAtPath(directory,
                withIntermediateDirectories:true,
                attributes:nil)
          print("Successfully created the folder")
          /* Now store the file */
          storeFile()
      } catch let error1 as NSError {
        directoryCreationError = error1
        if let error = directoryCreationError{
          print("Failed to create the folder with error = \(error)")
        }
      }
    } else {
      print("The directory was nil")
    }
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
      
      let containerURL =
      fileManager.URLForUbiquityContainerIdentifier(nil)
      
      documentsDirectory =
        containerURL!.path!.stringByAppendingPathComponent("Documents")
      
      if doesDocumentsDirectoryExist(){
        print("This folder already exists.")
        /* Now store the file */
        storeFile()
      } else {
        createDocumentsDirectory()
      }
      
      return true
  }
  
}


