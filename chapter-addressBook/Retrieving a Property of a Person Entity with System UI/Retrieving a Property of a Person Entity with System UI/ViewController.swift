//
//  ViewController.swift
//  Retrieving a Property of a Person Entity with System UI
//
//  Created by Vandad Nahavandipoor on 7/26/14.
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
import AddressBookUI

class ViewController: UIViewController,
ABPeoplePickerNavigationControllerDelegate {
  
  let personPicker: ABPeoplePickerNavigationController
  
  required init(coder aDecoder: NSCoder) {
    personPicker = ABPeoplePickerNavigationController()
    super.init(coder: aDecoder)
    personPicker.displayedProperties = [
      Int(kABPersonAddressProperty)
    ]
    personPicker.peoplePickerDelegate = self
  }
  
  @IBAction func performPickPersonProperty(sender : AnyObject) {
    self.presentViewController(personPicker, animated: true, completion: nil)
  }
  
  func peoplePickerNavigationControllerDidCancel(
    peoplePicker: ABPeoplePickerNavigationController!){
      /* Mandatory to implement */
  }
  
  func peoplePickerNavigationController(
    peoplePicker: ABPeoplePickerNavigationController!,
    didSelectPerson person: ABRecordRef!,
    property: ABPropertyID,
    identifier: ABMultiValueIdentifier) {
      
      let addresses: ABMultiValueRef = ABRecordCopyValue(person,
        property).takeRetainedValue()
      
      let index = Int(identifier) as CFIndex
      
      let address: NSDictionary = ABMultiValueCopyValueAtIndex(addresses,
        index).takeRetainedValue() as NSDictionary
      
      println("Country = \(address[kABPersonAddressCountryKey])")
      println("City = \(address[kABPersonAddressCityKey])")
      println("Street = \(address[kABPersonAddressStreetKey])")
      
  }
  
}

