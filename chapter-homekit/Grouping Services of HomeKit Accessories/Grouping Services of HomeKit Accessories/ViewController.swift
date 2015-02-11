//
//  ViewController.swift
//  Grouping Services of HomeKit Accessories
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
import HomeKit

extension HMCharacteristic{
  
  func containsProperty(paramProperty: String) -> Bool{
    if let propeties = self.properties{
      for property in properties as! [String]{
        if property == paramProperty{
          return true
        }
      }
    }
    return false
  }
  
  func isReadable() -> Bool{
    return containsProperty(HMCharacteristicPropertyReadable)
  }
  
  func isWritable() -> Bool{
    return containsProperty(HMCharacteristicPropertyWritable)
  }
  
}

class ViewController: UIViewController, HMHomeManagerDelegate,
HMAccessoryBrowserDelegate {
  
  var home: HMHome!
  var room: HMRoom!
  var switchServiceGroup: HMServiceGroup!
  let switchServiceGroupName = "All Switches"
  
  /* First time it is read, it will generate a random string.
  The next time it is read, it will give you the string that it created
  the first time. Works between application runs and persist the
  data in user defaults */
  var homeName: String = {
    let homeNameKey = "HomeName"
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    /* Can we find the old value? */
    if let name = defaults.stringForKey(homeNameKey){
      if count(name) > 0 {
        return name
      }
    }
    
    /* Create a new name */
    let newName = "Home \(arc4random_uniform(UInt32.max))"
    defaults.setValue(newName, forKey: homeNameKey)
    return newName
    }()
  
  lazy var accessoryBrowser: HMAccessoryBrowser = {
    let browser = HMAccessoryBrowser()
    browser.delegate = self
    return browser
    }()
  
  let roomName = "Strange Room"
  
  var homeManager: HMHomeManager!
  
  func createRoom(){
    
    home.addRoomWithName(roomName, completionHandler: {
      [weak self](room: HMRoom!, error: NSError!) in
      
      if error != nil{
        println("Failed to create the room")
      } else {
        println("Successuflly created the room")
        let strongSelf = self!
        strongSelf.room = room
        strongSelf.findOrCreateSwitchServiceGroup()
      }
      
      })
    
  }
  
  func createHome(){
    
    homeManager.addHomeWithName(homeName, completionHandler: {
      [weak self](home: HMHome!, error: NSError!) in
      
      if error != nil{
        println("Failed to create the home")
      } else {
        println("Successfully created the home")
        let strongSelf = self!
        strongSelf.home = home
        println("Creating the room...")
        strongSelf.createRoom()
      }
      
      })
    
  }
  
  func homeManagerDidUpdateHomes(manager: HMHomeManager) {
    
    for home in manager.homes as! [HMHome]{
      if home.name == homeName{
        
        println("Found the home")
        self.home = home
        
        for room in home.rooms as! [HMRoom]{
          if room.name == roomName{
            println("Found the room")
            self.room = room
            findOrCreateSwitchServiceGroup()
          }
        }
        
        if self.room == nil{
          /* We have to create the room */
          println("The room doesn't exist. Creating it...")
          createRoom()
        }
        
      }
    }
    
    if home == nil{
      println("Home doesn't exist. Creating it...")
      createHome()
    }
    
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didFindNewAccessory accessory: HMAccessory!) {
      
      println("Found an accessory...")
      
      println("Discovered an accessory")
      println("Adding it to the home")
      home.addAccessory(accessory, completionHandler: {
        [weak self](error: NSError!) in
        
        if error != nil{
          println("Failed to add it to the home")
        } else {
          println("Successfully added it to home")
          println("Assigning the accessory to the room...")
          let strongSelf = self!
          strongSelf.home.assignAccessory(accessory,
            toRoom: strongSelf.room,
            completionHandler: {(error: NSError!) in
              
              if error != nil{
                println("Failed to assign the accessory to the room")
              } else {
                println("Successfully assigned the accessory to the room")
                strongSelf.findOrCreateSwitchServiceGroup()
              }
              
            })
          
        }
        
        })
      
  }
  
  func addAllSwitchesToServiceGroup(serviceGroup: HMServiceGroup,
    completionHandler: ((NSError!) -> Void)?){
    
    if let accessories = room.accessories{
      for accessory in accessories as! [HMAccessory]{
        if let services = accessory.services{
          for service in services as! [HMService]{
            if (service.name as NSString).rangeOfString("switch",
              options: .CaseInsensitiveSearch).location != NSNotFound{
                /* This is a switch, add it to the service group */
                println("Found a switch service. Adding it to the group...")
                serviceGroup.addService(service,
                  completionHandler: completionHandler)
            }
          }
        }
      }
      
    }
    
  }
  
  func enumerateServicesInServiceGroup(serviceGroup: HMServiceGroup){
    println("Discovering all the services in this service group...")
    if let services = serviceGroup.services{
      for service in services as! [HMService]{
        println(service)
      }
    }
  }
  
  func discoverServicesInServiceGroup(serviceGroup: HMServiceGroup){
    
    addAllSwitchesToServiceGroup(serviceGroup, completionHandler: {
      [weak self](error: NSError!) in

      if error != nil{
        println("Failed to add the switch to the service group")
      } else {
        let strongSelf = self!
        strongSelf.enumerateServicesInServiceGroup(serviceGroup)
      }
      
      })
    
    enumerateServicesInServiceGroup(serviceGroup)
    
  }
  
  func findOrCreateSwitchServiceGroup(){
    
    /* Find out if we already have our switch service group or not */
    if let groups = home.serviceGroups{
      for serviceGroup in groups as! [HMServiceGroup]{
        if serviceGroup.name == switchServiceGroupName{
          switchServiceGroup = serviceGroup
        }
      }
    }
    
    if switchServiceGroup == nil{
      println("Could not find the switch service group. Creating it...")
      home.addServiceGroupWithName(switchServiceGroupName,
        completionHandler: {[weak self ]
          (group: HMServiceGroup!, error: NSError!) in
          
          if error != nil{
            println("Failed to create the switch service group")
          } else {
            let strongSelf = self!
            println("The switch service group was created successfully")
            strongSelf.switchServiceGroup = group
            strongSelf.discoverServicesInServiceGroup(group)
          }
          
        })
    } else {
      println("Found an existing switch service group")
      discoverServicesInServiceGroup(switchServiceGroup)
      
    }
    
    /* First, start finding new accessories */
    println("Finding new accessories...")
    accessoryBrowser.startSearchingForNewAccessories()
    
  }
  
  
  override func viewDidLoad() {
    
    homeManager = HMHomeManager()
    homeManager.delegate = self
    
  }
  
}

