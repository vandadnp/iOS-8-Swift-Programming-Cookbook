//
//  ViewController.swift
//  Searching for Files and Folders in iCloud
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

///* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let predicate = NSPredicate(format: "%K like %@",
//    NSMetadataItemFSNameKey,
//    "*")
//
//    let samePredicate = NSPredicate(format: "NSMetadataItemFSNameKey like %@",
//    "*")
//
//  }
//
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  
  let metadataQuery = NSMetadataQuery()
  let fileManager = NSFileManager()
  var cloudDocumentsDirectory: String?
  let fileName = "MyFileName.txt"
  
  func storeFile(){
    print("Storing a file in the directory...")
    
    if let directory = cloudDocumentsDirectory{
      
      let pathInAppBundle =
      NSTemporaryDirectory().stringByAppendingPathComponent(fileName)
      
      let pathInCloud =
      directory.stringByAppendingPathComponent(fileName)
      
      var writingError: NSError?
      
      do {
        try "Hello, World!".writeToFile(pathInAppBundle,
          atomically: true,
          encoding: NSUTF8StringEncoding)
        print("Successfully saved the file in the app bundle")
        
        print("Now moving this file into the cloud...")
        
        let sourceUrl = NSURL(fileURLWithPath: pathInAppBundle)
        let destinationUrl = NSURL(fileURLWithPath: pathInCloud)
        
        var savingError: NSError?
        do {
          try fileManager.setUbiquitous(true,
            itemAtURL: sourceUrl,
            destinationURL: destinationUrl)
          print("Successfully moved the file to the cloud...")
        } catch let error1 as NSError {
          savingError = error1
          if let error = savingError{
            print("Failed to move the file to the cloud = \(error)")
          }
        }
        
      } catch let error1 as NSError {
        writingError = error1
        if let error = writingError{
          print("An error occurred while writing the file = \(error)")
        }
      }
      startQuery()
    } else {
      print("The directory was nil")
    }
    
  }
  
  func doesDocumentsDirectoryExist() -> Bool{
    var isDirectory = false as ObjCBool
    
    if let directory = cloudDocumentsDirectory{
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
    
    if let directory = cloudDocumentsDirectory{
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
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let containerURL =
    fileManager.URLForUbiquityContainerIdentifier(nil)
    
    cloudDocumentsDirectory =
      containerURL!.path!.stringByAppendingPathComponent("Documents")
    
  }
  
  func startQuery(){
    print("Starting the query now...")
    
    metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
    let predicate = NSPredicate(format: "%K like %@",
      NSMetadataItemFSNameKey,
      "*.*")
    
    metadataQuery.predicate = predicate
    if metadataQuery.startQuery(){
      print("Successfully started the query.")
    } else {
      print("Failed to start the query.")
    }
  }
  
  func handleMetadataQueryFinished(sender: NSMetadataQuery){
    
    print("Search finished");
    
    /* Stop listening for notifications as we are not expecting
    anything more */
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
    /* We are done with the query, let's stop the process now */
    metadataQuery.disableUpdates()
    metadataQuery.stopQuery()
    
    for item in metadataQuery.results as! [NSMetadataItem]{
      
      let itemName = item.valueForAttribute(NSMetadataItemFSNameKey)
        as! String
      
      let itemUrl = item.valueForAttribute(NSMetadataItemURLKey)
        as! NSURL
      
      let itemSize = item.valueForAttribute(NSMetadataItemFSSizeKey)
        as! Int
      
      print("Item name = \(itemName)")
      print("Item url = \(itemUrl)")
      print("Item size = \(itemSize)")
      
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    print("Listening for notifications...")
    /* Listen for a notification that gets fired when the metadata query
    has finished finding the items we were looking for */
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleMetadataQueryFinished:",
      name: NSMetadataQueryDidFinishGatheringNotification,
      object: nil)
    
    if doesDocumentsDirectoryExist(){
      print("This folder already exists.")
      /* Now store the file */
      storeFile()
    } else {
      createDocumentsDirectory()
    }
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}

