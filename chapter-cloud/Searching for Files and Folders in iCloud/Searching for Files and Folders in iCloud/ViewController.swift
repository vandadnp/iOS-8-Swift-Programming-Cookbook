//
//  ViewController.swift
//  Searching for Files and Folders in iCloud
//
//  Created by vandad on 207//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

/* 1 */
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
    println("Storing a file in the directory...")
    
    if let directory = cloudDocumentsDirectory{
      
      let pathInAppBundle =
      NSTemporaryDirectory().stringByAppendingPathComponent(fileName)
      
      let pathInCloud =
      directory.stringByAppendingPathComponent(fileName)
      
      var writingError: NSError?
      
      if "Hello, World!".writeToFile(pathInAppBundle,
        atomically: true,
        encoding: NSUTF8StringEncoding,
        error: &writingError){
          println("Successfully saved the file in the app bundle")
          
          println("Now moving this file into the cloud...")
          
          let sourceUrl = NSURL(fileURLWithPath: pathInAppBundle)
          let destinationUrl = NSURL(fileURLWithPath: pathInCloud)
          
          var savingError: NSError?
          if fileManager.setUbiquitous(true,
            itemAtURL: sourceUrl,
            destinationURL: destinationUrl,
            error: &savingError){
              println("Successfully moved the file to the cloud...")
          } else {
            if let error = savingError{
              println("Failed to move the file to the cloud = \(error)")
            }
          }
          
      } else {
        if let error = writingError{
          println("An error occurred while writing the file = \(error)")
        }
      }
      startQuery()
    } else {
      println("The directory was nil")
    }
    
  }
  
  func doesDocumentsDirectoryExist() -> Bool{
    var isDirectory = false as ObjCBool
    var mustCreateDocumentsDirectory = false
    
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
    println("Must create the directory.")
    
    var directoryCreationError: NSError?
    
    if let directory = cloudDocumentsDirectory{
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
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let containerURL =
    fileManager.URLForUbiquityContainerIdentifier(nil)
    
    cloudDocumentsDirectory =
      containerURL!.path!.stringByAppendingPathComponent("Documents")
    
  }
  
  func startQuery(){
    println("Starting the query now...")
    
    metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
    let predicate = NSPredicate(format: "%K like %@",
      NSMetadataItemFSNameKey,
      "*.*")
    
    metadataQuery.predicate = predicate
    if metadataQuery.startQuery(){
      println("Successfully started the query.")
    } else {
      println("Failed to start the query.")
    }
  }
  
  func handleMetadataQueryFinished(sender: NSMetadataQuery){
    
    println("Search finished");
    
    /* Stop listening for notifications as we are not expecting
    anything more */
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
    /* We are done with the query, let's stop the process now */
    metadataQuery.disableUpdates()
    metadataQuery.stopQuery()
    
    for item in metadataQuery.results as [NSMetadataItem]{
      
      let itemName = item.valueForAttribute(NSMetadataItemFSNameKey)
        as String
      
      let itemUrl = item.valueForAttribute(NSMetadataItemURLKey)
        as NSURL
      
      let itemSize = item.valueForAttribute(NSMetadataItemFSSizeKey)
        as Int
      
      println("Item name = \(itemName)")
      println("Item url = \(itemUrl)")
      println("Item size = \(itemSize)")
      
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    println("Listening for notifications...")
    /* Listen for a notification that gets fired when the metadata query
    has finished finding the items we were looking for */
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleMetadataQueryFinished:",
      name: NSMetadataQueryDidFinishGatheringNotification,
      object: nil)
    
    if doesDocumentsDirectoryExist(){
      println("This folder already exists.")
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

