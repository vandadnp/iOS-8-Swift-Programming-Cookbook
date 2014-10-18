//
//  AppDelegate.swift
//  Deleting Files and Folders
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func example1(){
    
    let fileManager = NSFileManager()
    
    func createFolderAtPath(path: String){
      
      var error:NSError?
      
      if fileManager.createDirectoryAtPath(path,
        withIntermediateDirectories: true,
        attributes: nil,
        error: &error) == false && error != nil{
          println("Failed to create folder at \(path), error = \(error!)")
      }
      
    }
    
    /* Creates 5 .txt files in the given folder, named 1.txt, 2.txt, etc */
    func createFilesInFolder(folder: String){
      
      for counter in 1...5{
        let fileName = NSString(format: "%lu.txt", counter)
        let path = folder.stringByAppendingPathComponent(fileName)
        let fileContents = "Some text"
        var error:NSError?
        if fileContents.writeToFile(path,
          atomically: true,
          encoding: NSUTF8StringEncoding,
          error: &error) == false{
            if let theError = error{
              println("Failed to save the file at path \(path)" +
                " with error = \(theError)")
            }
        }
      }
      
    }
    
    /* Enumerates all files/folders at a given path */
    func enumerateFilesInFolder(folder: String){
      
      var error:NSError?
      let contents = fileManager.contentsOfDirectoryAtPath(
        folder,
        error: &error)!
      
      if let theError = error{
        println("An error occurred \(theError)")
      } else if contents.count == 0{
        println("No content was found")
      } else {
        println("Contents of path \(folder) = \(contents)")
      }
      
    }
    
    /* Deletes all files/folders in a given path */
    func deleteFilesInFolder(folder: String){
      
      var error:NSError?
      let contents = fileManager.contentsOfDirectoryAtPath(folder,
        error: &error) as [String]
      
      if let theError = error{
        println("An error occurred = \(theError)")
      } else {
        for fileName in contents{
          let filePath = folder.stringByAppendingPathComponent(fileName)
          if fileManager.removeItemAtPath(filePath, error: nil){
            println("Successfully removed item at path \(filePath)")
          } else {
            println("Failed to remove item at path \(filePath)")
          }
        }
      }
      
    }
    
    /* Deletes a folder with a given path */
    func deleteFolderAtPath(path: String){
      
      var error:NSError?
      if fileManager.removeItemAtPath(path, error: &error){
        println("Successfully deleted the path \(path)")
      } else {
        if let theError = error{
          println("Failed to remove path \(path) with error \(theError)")
        }
      }
      
    }
    
    let txtFolder = NSTemporaryDirectory().stringByAppendingPathComponent("txt")
    
    createFolderAtPath(txtFolder)
    createFilesInFolder(txtFolder)
    enumerateFilesInFolder(txtFolder)
    deleteFilesInFolder(txtFolder)
    enumerateFilesInFolder(txtFolder)
    deleteFolderAtPath(txtFolder)
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    example1()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    
    return true
  }
  
}

