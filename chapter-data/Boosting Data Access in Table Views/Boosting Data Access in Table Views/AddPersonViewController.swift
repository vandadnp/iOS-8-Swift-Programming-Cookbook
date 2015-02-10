//
//  AddPersonViewController.swift
//  Boosting Data Access in Table Views
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CoreData

class AddPersonViewController: UIViewController {
  
  var textFieldFirstName: UITextField!
  var textFieldLastName: UITextField!
  var textFieldAge: UITextField!
  var barButtonAdd: UIBarButtonItem!
  
  func createNewPerson(sender: AnyObject){
    
    let appDelegate = UIApplication.sharedApplication().delegate
      as! AppDelegate
    
    let managedObjectContext = appDelegate.managedObjectContext
    
    let newPerson =
    NSEntityDescription.insertNewObjectForEntityForName("Person",
      inManagedObjectContext: managedObjectContext!) as? Person
    
    if let person = newPerson{
      person.firstName = textFieldFirstName.text
      person.lastName = textFieldLastName.text
      if let age = textFieldAge.text.toInt(){
        person.age = age
      } else {
        person.age = 18
      }
      
      var savingError: NSError?
      
      if managedObjectContext!.save(&savingError){
        navigationController!.popViewControllerAnimated(true)
      } else {
        println("Failed to save the managed object context")
      }
      
    } else {
      println("Failed to create the new person object")
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "New Person"
    
    var textFieldRect = CGRect(x: 20,
      y: 80,
      width: view.bounds.size.width - 40,
      height: 31)
    
    textFieldFirstName = UITextField(frame: textFieldRect)
    textFieldFirstName.placeholder = "First Name"
    textFieldFirstName.borderStyle = .RoundedRect
    textFieldFirstName.autoresizingMask = .FlexibleWidth
    textFieldFirstName.contentVerticalAlignment = .Center
    view.addSubview(textFieldFirstName)
    
    textFieldRect.origin.y += 37
    textFieldLastName = UITextField(frame: textFieldRect)
    textFieldLastName.placeholder = "Last Name"
    textFieldLastName.borderStyle = .RoundedRect
    textFieldLastName.autoresizingMask = .FlexibleWidth
    textFieldLastName.contentVerticalAlignment = .Center
    view.addSubview(textFieldLastName)
    
    textFieldRect.origin.y += 37
    textFieldAge = UITextField(frame: textFieldRect)
    textFieldAge.placeholder = "Age"
    textFieldAge.borderStyle = .RoundedRect
    textFieldAge.autoresizingMask = .FlexibleWidth
    textFieldAge.keyboardType = .NumberPad
    textFieldAge.contentVerticalAlignment = .Center
    view.addSubview(textFieldAge)
    
    barButtonAdd = UIBarButtonItem(title: "Add",
      style: .Plain,
      target: self,
      action: "createNewPerson:")
    
    navigationItem.rightBarButtonItem = barButtonAdd
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    textFieldFirstName.becomeFirstResponder()
  }
  
}
