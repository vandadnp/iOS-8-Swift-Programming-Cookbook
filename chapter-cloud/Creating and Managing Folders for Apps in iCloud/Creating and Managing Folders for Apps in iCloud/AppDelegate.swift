//
//  AppDelegate.swift
//  Creating and Managing Folders for Apps in iCloud
//
//  Created by vandad on 207//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

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
//    var mustCreateDocumentsDirectory = false
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
//    println("Must create the directory.")
//
//    var directoryCreationError: NSError?
//
//    if let directory = documentsDirectory{
//      if fileManager.createDirectoryAtPath(directory,
//        withIntermediateDirectories:true,
//        attributes:nil,
//        error:&directoryCreationError){
//          println("Successfully created the folder")
//      } else {
//        if let error = directoryCreationError{
//          println("Failed to create the folder with error = \(error)")
//        }
//      }
//    } else {
//      println("The directory was nil")
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
//        println("This folder already exists.")
//      } else {
//        createDocumentsDirectory()
//      }
//
//      return true
//  }
//
//}

/* 2 */
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let fileManager = NSFileManager()
  var documentsDirectory: String?
  
  func storeFile(){
    println("Storing a file in the directory...")
    
    if let directory = documentsDirectory{
      
      let path =
      documentsDirectory!.stringByAppendingPathComponent("File.txt")
      
      var writingError: NSError?
      
      if "Hello, World!".writeToFile(path,
        atomically: true,
        encoding: NSUTF8StringEncoding,
        error: &writingError){
          println("Successfully saved the file")
      } else {
        if let error = writingError{
          println("An error occurred while writing the file = \(error)")
        }
      }
      
    } else {
      println("The directory was nil")
    }
    
  }
  
  func doesDocumentsDirectoryExist() -> Bool{
    var isDirectory = false as ObjCBool
    var mustCreateDocumentsDirectory = false
    
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
    println("Must create the directory.")
    
    var directoryCreationError: NSError?
    
    if let directory = documentsDirectory{
      if fileManager.createDirectoryAtPath(directory,
        withIntermediateDirectories:true,
        attributes:nil,
        error:&directoryCreationError){
          println("Successfully created the folder")
          /* Now store the file */
          storeFile()
      } else {
        if let error = directoryCreationError{
          println("Failed to create the folder with error = \(error)")
        }
      }
    } else {
      println("The directory was nil")
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
        println("This folder already exists.")
        /* Now store the file */
        storeFile()
      } else {
        createDocumentsDirectory()
      }
      
      return true
  }
  
}


