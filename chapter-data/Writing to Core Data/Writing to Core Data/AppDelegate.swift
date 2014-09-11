//
//  AppDelegate.swift
//  Writing to Core Data
//
//  Created by Vandad Nahavandipoor on 8/6/14.
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
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

      let entityName = NSStringFromClass(Person.classForCoder())

      let person = NSEntityDescription.insertNewObjectForEntityForName(
        entityName,
        inManagedObjectContext: managedObjectContext!) as Person

      person.firstName = "First name"
      person.firstName = "Last name"
      person.age = NSNumber(unsignedInt: arc4random_uniform(120))
      
      var savingError: NSError?

      if managedObjectContext!.save(&savingError){
        println("Successfully saved the new person")
      } else {
        if let error = savingError{
          println("Failed to save the new person. Error = \(error)")
        }
      }

    return true
  }

  func applicationWillTerminate(application: UIApplication!) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var applicationDocumentsDirectory: NSURL = {
      // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pixolity.ios.Writing_to_Core_Data" in the application's documents Application Support directory.
      let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
      return urls[urls.count-1] as NSURL
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = NSBundle.mainBundle().URLForResource("Writing_to_Core_Data", withExtension: "momd")
      return NSManagedObjectModel(contentsOfURL: modelURL)
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
      // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Writing_to_Core_Data.sqlite")
      var error: NSError? = nil
      var failureReason = "There was an error creating or loading the application's saved data."
      if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
          coordinator = nil
          // Report any error we got.
          let dict = NSMutableDictionary()
          dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
          dict[NSLocalizedFailureReasonErrorKey] = failureReason
          dict[NSUnderlyingErrorKey] = error
          error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
          // Replace this with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          NSLog("Unresolved error \(error), \(error!.userInfo)")
          abort()
      }
      
      return coordinator
  }()

  lazy var managedObjectContext: NSManagedObjectContext? = {
      // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
      let coordinator = self.persistentStoreCoordinator
      if coordinator == nil {
          return nil
      }
      var managedObjectContext = NSManagedObjectContext()
      managedObjectContext.persistentStoreCoordinator = coordinator
      return managedObjectContext
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      if let moc = self.managedObjectContext {
          var error: NSError? = nil
          if moc.hasChanges && !moc.save(&error) {
              // Replace this implementation with code to handle the error appropriately.
              // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              NSLog("Unresolved error \(error), \(error!.userInfo)")
              abort()
          }
      }
  }

}

