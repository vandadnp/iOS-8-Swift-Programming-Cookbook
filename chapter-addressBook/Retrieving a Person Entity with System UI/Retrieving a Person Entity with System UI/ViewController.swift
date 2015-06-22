//
//  ViewController.swift
//  Retrieving a Person Entity with System UI
//
//  Created by Vandad Nahavandipoor on 6/25/14.
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
//import AddressBookUI
//
//class ViewController: UIViewController,
//ABPeoplePickerNavigationControllerDelegate {
//  
//  let personPicker: ABPeoplePickerNavigationController
//  
//  required init(coder aDecoder: NSCoder) {
//    personPicker = ABPeoplePickerNavigationController()
//    super.init(coder: aDecoder)
//    personPicker.peoplePickerDelegate = self
//  }
//  
//  @IBAction func performPickPerson(sender : AnyObject) {
//    self.presentViewController(personPicker, animated: true, completion: nil)
//  }
//  
//  func peoplePickerNavigationControllerDidCancel(
//    peoplePicker: ABPeoplePickerNavigationController){
//    /* Mandatory to implement */
//  }
//  
//  func peoplePickerNavigationController(
//    peoplePicker: ABPeoplePickerNavigationController,
//    didSelectPerson person: ABRecordRef) {
//      
//      /* Do we know which picker this is? */
//      if peoplePicker != personPicker{
//        return
//      }
//      
//      /* Get all the phone numbers this user has */
//      
//      let phones: ABMultiValueRef = ABRecordCopyValue(person,
//        kABPersonPhoneProperty).takeRetainedValue()
//      
//      let countOfPhones = ABMultiValueGetCount(phones)
//      
//      for index in 0..<countOfPhones{
//        let phone = ABMultiValueCopyValueAtIndex(phones,
//          index).takeRetainedValue() as! String
//        
//        print(phone)
//        
//      }
//    
//  }
//  
//}
//
///* 2 */
import UIKit
import AddressBookUI

class ViewController: UIViewController,
ABPeoplePickerNavigationControllerDelegate {

  let personPicker: ABPeoplePickerNavigationController

  required init(coder aDecoder: NSCoder) {
    personPicker = ABPeoplePickerNavigationController()
    super.init(coder: aDecoder)
    personPicker.peoplePickerDelegate = self
  }

  @IBAction func performPickPerson(sender : AnyObject) {
    self.presentViewController(personPicker, animated: true, completion: nil)
  }

  func peoplePickerNavigationControllerDidCancel(
    peoplePicker: ABPeoplePickerNavigationController){
    /* Mandatory to implement */
  }
  
  func peoplePickerNavigationController(
    peoplePicker: ABPeoplePickerNavigationController,
    didSelectPerson person: ABRecordRef) {

      /* Do we know which picker this is? */
      if peoplePicker != personPicker{
        return
      }
      
      let emails: ABMultiValueRef = ABRecordCopyValue(person,
        kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
      
      let allEmails = ABMultiValueCopyArrayOfAllValues(
        emails).takeRetainedValue() as NSArray
      
      for email in allEmails{
        print(email)
      }
      
  }

}


