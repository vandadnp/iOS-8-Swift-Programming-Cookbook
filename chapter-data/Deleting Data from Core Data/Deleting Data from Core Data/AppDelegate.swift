//
//  AppDelegate.swift
//  Deleting Data from Core Data
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func createNewPersonWithFirstName(firstName: String,
    lastName :String,
    age: Int) -> Bool{
      
      let newPerson =
      NSEntityDescription.insertNewObjectForEntityForName("Person",
        inManagedObjectContext: managedObjectContext!) as Person
      
      (newPerson.firstName, newPerson.lastName, newPerson.age) =
        (firstName, lastName, age)
      
      var savingError: NSError?
      
      if managedObjectContext!.save(&savingError){
        return true
      } else {
        if let error = savingError{
          println("Failed to save the new person. Error = \(error)")
        }
      }
      
      return false
      
  }

  /* 1 */
//  func application(application: UIApplication!,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      /* Create the entities first */
//      createNewPersonWithFirstName("Anthony", lastName: "Robbins", age: 52)
//      createNewPersonWithFirstName("Richard", lastName: "Branson", age: 62)
//      
//      /* Tell the request that we want to read the
//      contents of the Person entity */
//      /* Create the fetch request first */
//      let fetchRequest = NSFetchRequest(entityName: "Person")
//      
//      var requestError: NSError?
//      
//      /* And execute the fetch request on the context */
//      let persons = managedObjectContext!.executeFetchRequest(fetchRequest,
//        error: &requestError) as [Person!]
//      
//      /* Make sure we get the array */
//      if persons.count > 0{
//        
//        /* Delete the last person in the array */
//        let lastPerson = (persons as NSArray).lastObject as Person
//        
//        managedObjectContext!.deleteObject(lastPerson)
//        
//        var savingError: NSError?
//        if managedObjectContext!.save(&savingError){
//          println("Successfully deleted the last person in the array")
//        } else {
//          if let error = savingError{
//            println("Failed to delete the last person. Error = \(error)")
//          }
//        }
//        
//      } else {
//        println("Could not find any Person entities in the context")
//      }
//      
//      return true
//  }
  
  /* 2 */
  func application(application: UIApplication!,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      /* Create the entities first */
      createNewPersonWithFirstName("Anthony", lastName: "Robbins", age: 52)
      createNewPersonWithFirstName("Richard", lastName: "Branson", age: 62)
      
      /* Tell the request that we want to read the
      contents of the Person entity */
      /* Create the fetch request first */
      let fetchRequest = NSFetchRequest(entityName: "Person")
      
      var requestError: NSError?
      
      /* And execute the fetch request on the context */
      let persons = managedObjectContext!.executeFetchRequest(fetchRequest,
        error: &requestError) as [Person!]
      
      /* Make sure we get the array */
      if persons.count > 0{
        
        /* Delete the last person in the array */
        let lastPerson = (persons as NSArray).lastObject as Person
        
        managedObjectContext!.deleteObject(lastPerson)
        
        if lastPerson.deleted{
            println("Successfully deleted the last person...")

          var savingError: NSError?
          if managedObjectContext!.save(&savingError){
            println("Successfully saved the context")
          } else {
            if let error = savingError{
              println("Failed to save the context. Error = \(error)")
            }
          }

        } else {
            println("Failed to delete the last person")
        }
        
      } else {
        println("Could not find any Person entities in the context")
      }
      
      return true
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
    // #pragma mark - Core Data stack
  
  lazy var applicationDocumentsDirectory: NSURL = {
      // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pixolity.ios.coredata" in the application's documents Application Support directory.
      let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
      return urls[urls.count-1] as NSURL
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = NSBundle.mainBundle().URLForResource("Deleting_Data_from_Core_Data", withExtension: "momd")!
      return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
      // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Deleting_Data_from_Core_Data.sqlite")
      var error: NSError? = nil
      var failureReason = "There was an error creating or loading the application's saved data."
      if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
          coordinator = nil
          // Report any error we got.
          let dict = NSMutableDictionary()
          dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
          dict[NSLocalizedFailureReasonErrorKey] = failureReason
          dict[NSUnderlyingErrorKey] = error
          error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
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

