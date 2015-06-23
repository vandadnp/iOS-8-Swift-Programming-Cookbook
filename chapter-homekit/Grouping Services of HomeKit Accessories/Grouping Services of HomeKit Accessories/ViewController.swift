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
    
    guard self.properties.count > 0 else {
      return false
    }
    
      for property in properties{
        if property == paramProperty{
          return true
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
      if name.characters.count > 0 {
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
      room, error in
      
      guard let room = room else {
        print("Failed to create the room")
        return
      }
      
      print("Successuflly created the room")
      self.room = room
      self.findOrCreateSwitchServiceGroup()
      
      })
    
  }
  
  func createHome(){
    
    homeManager.addHomeWithName(homeName, completionHandler: {
      home, error in
      
      guard let home = home else {
        print("Failed to create the home")
        return
      }
      
      print("Successfully created the home")
      self.home = home
      print("Creating the room...")
      self.createRoom()
      })
    
  }
  
  func homeManagerDidUpdateHomes(manager: HMHomeManager) {
    
    for home in manager.homes as [HMHome]{
      if home.name == homeName{
        
        print("Found the home")
        self.home = home
        
        for room in home.rooms as [HMRoom]{
          if room.name == roomName{
            print("Found the room")
            self.room = room
            findOrCreateSwitchServiceGroup()
          }
        }
        
        if self.room == nil{
          /* We have to create the room */
          print("The room doesn't exist. Creating it...")
          createRoom()
        }
        
      }
    }
    
    if home == nil{
      print("Home doesn't exist. Creating it...")
      createHome()
    }
    
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didFindNewAccessory accessory: HMAccessory) {
      
      print("Found an accessory...")
      
      print("Discovered an accessory")
      print("Adding it to the home")
      home.addAccessory(accessory, completionHandler: {
        error in
        
        if error != nil{
          print("Failed to add it to the home")
        } else {
          print("Successfully added it to home")
          print("Assigning the accessory to the room...")
          self.home.assignAccessory(accessory,
            toRoom: self.room,
            completionHandler: {error in
              
              if error != nil{
                print("Failed to assign the accessory to the room")
              } else {
                print("Successfully assigned the accessory to the room")
                self.findOrCreateSwitchServiceGroup()
              }
              
            })
          
        }
        
        })
      
  }
  
  func addAllSwitchesToServiceGroup(serviceGroup: HMServiceGroup,
    completionHandler: ((NSError?) -> Void)){
    
      for accessory in room.accessories{
        for service in accessory.services{
          if (service.name as NSString).rangeOfString("switch",
            options: .CaseInsensitiveSearch).location != NSNotFound{
              /* This is a switch, add it to the service group */
              print("Found a switch service. Adding it to the group...")
              serviceGroup.addService(service,
                completionHandler: completionHandler)
          }
        }
      }
    
  }
  
  func enumerateServicesInServiceGroup(serviceGroup: HMServiceGroup){
    print("Discovering all the services in this service group...")
    for service in serviceGroup.services{
      print(service)
    }
  }
  
  func discoverServicesInServiceGroup(serviceGroup: HMServiceGroup){
    
    addAllSwitchesToServiceGroup(serviceGroup, completionHandler: {
      error in

      if error != nil{
        print("Failed to add the switch to the service group")
      } else {
        self.enumerateServicesInServiceGroup(serviceGroup)
      }
      
      })
    
    enumerateServicesInServiceGroup(serviceGroup)
    
  }
  
  func findOrCreateSwitchServiceGroup(){
    
    /* Find out if we already have our switch service group or not */
    for serviceGroup in home.serviceGroups{
      if serviceGroup.name == switchServiceGroupName{
        switchServiceGroup = serviceGroup
      }
    }
    
    if switchServiceGroup == nil{
      print("Could not find the switch service group. Creating it...")
      home.addServiceGroupWithName(switchServiceGroupName,
        completionHandler: {group, error in
          
          guard let group = group else {
            print("Failed to create the switch service group")
            return
          }
          print("The switch service group was created successfully")
          self.switchServiceGroup = group
          self.discoverServicesInServiceGroup(group)
          
        })
    } else {
      print("Found an existing switch service group")
      discoverServicesInServiceGroup(switchServiceGroup)
      
    }
    
    /* First, start finding new accessories */
    print("Finding new accessories...")
    accessoryBrowser.startSearchingForNewAccessories()
    
  }
  
  
  override func viewDidLoad() {
    
    homeManager = HMHomeManager()
    homeManager.delegate = self
    
  }
  
}

