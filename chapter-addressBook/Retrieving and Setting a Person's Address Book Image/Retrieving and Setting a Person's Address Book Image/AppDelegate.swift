//
//  AppDelegate.swift
//  Retrieving and Setting a Person's Address Book Image
//
//  Created by Vandad Nahavandipoor on 7/27/14.
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
import AddressBook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  lazy var addressBook: ABAddressBookRef = {
    var error: Unmanaged<CFError>?
    return ABAddressBookCreateWithOptions(nil,
      &error).takeRetainedValue() as ABAddressBookRef
    }()
  
  func imageForPerson(person: ABRecordRef) -> UIImage?{
    
    let data = ABPersonCopyImageData(person).takeRetainedValue() as NSData
    
    let image = UIImage(data: data)
    return image
  }
  
  func newPersonWithFirstName(firstName: String,
    lastName: String,
    inAddressBook: ABAddressBookRef) -> ABRecordRef?{
      
      let person: ABRecordRef = ABPersonCreate().takeRetainedValue()
      
      let couldSetFirstName = ABRecordSetValue(person,
        kABPersonFirstNameProperty,
        firstName as CFTypeRef,
        nil)
      
      let couldSetLastName = ABRecordSetValue(person,
        kABPersonLastNameProperty,
        lastName as CFTypeRef,
        nil)
      
      var error: Unmanaged<CFErrorRef>? = nil
      
      let couldAddPerson = ABAddressBookAddRecord(inAddressBook, person, &error)
      
      if couldAddPerson{
        println("Successfully added the person")
      } else {
        println("Failed to add the person.")
        return nil
      }
      
      if ABAddressBookHasUnsavedChanges(inAddressBook){
        
        var error: Unmanaged<CFErrorRef>? = nil
        let couldSaveAddressBook = ABAddressBookSave(inAddressBook, &error)
        
        if couldSaveAddressBook{
          println("Successfully saved the address book")
        } else {
          println("Failed to save the address book.")
        }
      }
      
      if couldSetFirstName && couldSetLastName{
        println("Successfully set the first name " +
          "and the last name of the person")
      } else {
        println("Failed to set the first name and/or " +
          "the last name of the person")
      }
      
      return person
      
  }
  
  func setImageForPerson(person: ABRecordRef,
    inAddressBook addressBook: ABAddressBookRef,
    imageData: NSData) -> Bool{
      
      var error: Unmanaged<CFErrorRef>? = nil
      
      let couldSetPersonImage =
      ABPersonSetImageData(person, imageData as CFDataRef, &error)
      
      if couldSetPersonImage{
        println("Successfully set the person's image. Saving...")
        if ABAddressBookHasUnsavedChanges(addressBook){
          error = nil
          
          let couldSaveAddressBook = ABAddressBookSave(addressBook, &error)
          
          if couldSaveAddressBook{
            println("Successfully saved the address book")
            return true
          } else {
            println("Failed to save the address book")
          }
        } else {
          println("There are no changes to be saved!")
        }
      } else {
        println("Failed to set the person's image")
      }
      
      return false
      
  }
  
  func performExample(){
    let person: ABRecordRef? = newPersonWithFirstName("Richard",
      lastName: "Branson", inAddressBook: addressBook)
    
    if let richard: ABRecordRef = person{
      
      let newImage = UIImage(named: "image")
      let newImageData = UIImageJPEGRepresentation(newImage, 1.0)
      
      if setImageForPerson(richard, inAddressBook: addressBook,
        imageData: newImageData){
          
          println("Successfully set the person's image")
          
          let image = imageForPerson(richard)
          
          if let currentImage = image{
            println("Found the image")
          } else {
            println("This person has no image")
          }
          
      } else {
        println("Could not set the person's image")
      }
      
    }
    
  }
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      switch ABAddressBookGetAuthorizationStatus(){
      case .Authorized:
        println("Already authorized")
        performExample()
      case .Denied:
        println("You are denied access to address book")
        
      case .NotDetermined:
        ABAddressBookRequestAccessWithCompletion(addressBook,
          {[weak self] (granted: Bool, error: CFError!) in
            
            if granted{
              let strongSelf = self!
              println("Access is granted")
              strongSelf.performExample()
            } else {
              println("Access is not granted")
            }
            
        })
      case .Restricted:
        println("Access is restricted")
        
      default:
        println("Unhandled")
      }
      
      return true
  }
  
}

