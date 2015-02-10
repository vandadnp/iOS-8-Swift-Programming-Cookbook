//
//  AppDelegate.swift
//  Fetching Data in the Background
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var mutablePersons = [Person]()
  
  func processPersons(){
    
    /* Do your work here using the mutablePersons property of our app*/
    
  }
  
  func populateDatabase(){
    
    for counter in 0..<1000{
      let person = NSEntityDescription.insertNewObjectForEntityForName(
        NSStringFromClass(Person.classForCoder()),
        inManagedObjectContext: managedObjectContext!) as! Person
      
      person.firstName = "First name \(counter)"
      person.lastName = "Last name \(counter)"
      person.age = counter
    }
    
    var savingError: NSError?
    if managedObjectContext!.save(&savingError){
      println("Managed to populate the database")
    } else {
      if let error = savingError{
        println("Failed to populate the database. Error = \(error)")
      }
    }
    
  }
  
  func newFetchRequest() -> NSFetchRequest{
    
    let request = NSFetchRequest(entityName:
      NSStringFromClass(Person.classForCoder()))
    
    request.fetchBatchSize = 20
    request.predicate = NSPredicate(format: "(age >= 100) AND (age <= 200)")
    
    request.resultType = .ManagedObjectIDResultType
    return request
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      /* Set up the background context */
      let backgroundContext = NSManagedObjectContext(
        concurrencyType: .PrivateQueueConcurrencyType)
      
      backgroundContext.persistentStoreCoordinator =
      persistentStoreCoordinator
      
      /* Issue a block on the background context */
      backgroundContext.performBlock{[weak self] in
        
        var fetchError: NSError?
        let personIds = backgroundContext.executeFetchRequest(
          self!.newFetchRequest(),
          error: &fetchError) as! [NSManagedObjectID]
        
        if fetchError == nil{
          
          let mainContext = self!.managedObjectContext
          
          /* Now go on the main context and get the objects on that
          context using their IDs */
          dispatch_async(dispatch_get_main_queue(), {
            for personId in personIds{
              let person = mainContext!.objectWithID(personId) as! Person
              self!.mutablePersons.append(person)
            }
            self!.processPersons()
            })
        } else {
          println("Failed to execute the fetch request")
        }
        
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
      return urls[urls.count-1] as! NSURL
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = NSBundle.mainBundle().URLForResource("Fetching_Data_in_the_Background", withExtension: "momd")!
      return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
      // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Fetching_Data_in_the_Background.sqlite")
      var error: NSError? = nil
      var failureReason = "There was an error creating or loading the application's saved data."
      if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
          coordinator = nil
          // Report any error we got.
          var dict = [String: AnyObject]()
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

