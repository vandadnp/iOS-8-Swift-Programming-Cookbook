//
//  AppDelegate.swift
//  Saving Objects to Files
//
//  Created by Vandad Nahavandipoor on 6/23/14.
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

@objc(Person) class Person: NSObject, NSCoding{
  var firstName: String
  var lastName: String
  
  struct SerializationKey{
    static let firstName = "firstName"
    static let lastName = "lastName"
  }
  
  init(firstName: String, lastName: String){
    self.firstName = firstName
    self.lastName = lastName
    super.init()
  }
  
  convenience override init(){
    self.init(firstName: "Vandad", lastName: "Nahavandipoor")
  }
  
  required init(coder aDecoder: NSCoder) {
      self.firstName = aDecoder.decodeObjectForKey(SerializationKey.firstName)
        as! String
    
      self.lastName = aDecoder.decodeObjectForKey(SerializationKey.lastName)
        as! String
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.firstName, forKey: SerializationKey.firstName)
    aCoder.encodeObject(self.lastName, forKey: SerializationKey.lastName)
  }
  
}

func == (lhs: Person, rhs: Person) -> Bool{
  return lhs.firstName == rhs.firstName &&
    lhs.lastName == rhs.lastName ? true : false
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    let path = NSTemporaryDirectory() + "person"
    var firstPerson = Person()
    NSKeyedArchiver.archiveRootObject(firstPerson, toFile: path)
    
    var secondPerson = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
      as! Person!
    
    if firstPerson == secondPerson{
      println("Both persons are the same")
    } else {
      println("Could not read the archive")
    }
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }

}

