//
//  PersonsListTableViewController.swift
//  Boosting Data Access in Table Views
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreData

class PersonsListTableViewController: UITableViewController,
NSFetchedResultsControllerDelegate {
  
  struct TableViewConstants{
    static let cellIdentifier = "Cell"
  }
  
  var barButtonAddPerson: UIBarButtonItem!
  var frc: NSFetchedResultsController!
  
  var managedObjectContext: NSManagedObjectContext?{
  return (UIApplication.sharedApplication().delegate
    as! AppDelegate).managedObjectContext
  }
  
  func addNewPerson(sender: AnyObject){
    /* This is a custom segue identifier that we have defined in our
    storyboard that simply does a "Show" segue from our view controller
    to the "Add New Person" view controller */
    performSegueWithIdentifier("addPerson", sender: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    barButtonAddPerson = UIBarButtonItem(barButtonSystemItem: .Add,
      target: self,
      action: "addNewPerson:")
    
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController,
    didChangeObject anObject: NSManagedObject,
    atIndexPath indexPath: NSIndexPath?,
    forChangeType type: NSFetchedResultsChangeType,
    newIndexPath: NSIndexPath?) {
      
      if type == .Delete{
        tableView.deleteRowsAtIndexPaths([indexPath!],
          withRowAnimation: .Automatic)
      }
        
      else if type == .Insert{
        tableView.insertRowsAtIndexPaths([newIndexPath!],
          withRowAnimation: .Automatic)
      }
      
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    tableView.endUpdates()
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      let sectionInfo = frc.sections![section] as NSFetchedResultsSectionInfo
      return sectionInfo.numberOfObjects
      
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewConstants.cellIdentifier,
        forIndexPath: indexPath) as UITableViewCell
      
      let person = frc.objectAtIndexPath(indexPath) as! Person
      
      cell.textLabel!.text = person.firstName + " " + person.lastName
      cell.detailTextLabel!.text = "Age: \(person.age)"
      
      return cell
      
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    if editing{
      navigationItem.setRightBarButtonItem(nil, animated: true)
    } else {
      navigationItem.setRightBarButtonItem(barButtonAddPerson, animated: true)
    }
    
  }
  
  override func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath){
      
      let personToDelete = self.frc.objectAtIndexPath(indexPath) as! Person
      
      managedObjectContext!.deleteObject(personToDelete)
      
      if personToDelete.deleted{
        
        do {
          try managedObjectContext!.save()
          print("Successfully deleted the object")
        } catch let error as NSError {
          print("Failed to save the context with error = \(error)")
        }
      }
      
  }
  
  override func tableView(tableView: UITableView,
    editingStyleForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCellEditingStyle {
    return .Delete
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Persons"
    
    navigationItem.leftBarButtonItem = editButtonItem()
    navigationItem.rightBarButtonItem = barButtonAddPerson
    
    /* Create the fetch request first */
    let fetchRequest = NSFetchRequest(entityName: "Person")
    
    let ageSort = NSSortDescriptor(key: "age", ascending: true)
    
    let firstNameSort = NSSortDescriptor(key: "firstName", ascending: true)
    
    fetchRequest.sortDescriptors = [ageSort, firstNameSort]
    
    frc = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    frc.delegate = self
    do {
      try frc.performFetch()
      print("Successfully fetched")
    } catch let error as NSError {
      print("Failed to fetch \(error)")
    }
    
  }
  
}

