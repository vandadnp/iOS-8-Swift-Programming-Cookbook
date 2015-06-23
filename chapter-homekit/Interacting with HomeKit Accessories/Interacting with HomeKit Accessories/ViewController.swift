//
//  ViewController.swift
//  Interacting with HomeKit Accessories
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
    for property in self.properties{
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
  var projectorAccessory: HMAccessory!
  
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
  
  let roomName = "Bedroom"
  let accessoryName = "Cinema Room Projector"
  
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
      self.findCinemaRoomProjectorAccessory()
      
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
            findCinemaRoomProjectorAccessory()
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
      
      if accessory.name == accessoryName{
        print("Discovered the projector accessory")
        print("Adding it to the home")
        home.addAccessory(accessory, completionHandler: {
          error in
          
          if error != nil{
            print("Failed to add it to the home")
          } else {
            print("Successfully added it to home")
            print("Assigning the projector to the room...")
            self.home.assignAccessory(accessory,
              toRoom: self.room,
              completionHandler: {error in
                
                if error != nil{
                  print("Failed to assign the projector to the room")
                } else {
                  self.projectorAccessory = accessory
                  print("Successfully assigned the projector to the room")
                  self.lowerBrightnessOfProjector()
                }
                
              })
            
          }
          
          })
      }
      
  }
  
  func lowerBrightnessOfProjector(){
    
    var brightnessCharacteristic: HMCharacteristic!
    
    print("Finding the brightness characteristic of the projector...")
    
    for service in projectorAccessory.services as [HMService]{
      for characteristic in service.characteristics as [HMCharacteristic]{
        if characteristic.characteristicType == HMCharacteristicTypeBrightness{
          print("Found it")
          brightnessCharacteristic = characteristic
        }
      }
    }
    
    if brightnessCharacteristic == nil{
      print("Could not find it")
    } else {
      
      if brightnessCharacteristic.isReadable() == false{
        print("Cannot read the value of the brightness characteristic")
        return
      }
      
      print("Reading the value of the brightness characteristic...")
      
      brightnessCharacteristic.readValueWithCompletionHandler{error in
        
        if error != nil{
          print("Could not read the brightness value")
        } else {
          print("Read the brightness value. Setting it now...")
          
          if brightnessCharacteristic.isWritable(){
            let newValue = (brightnessCharacteristic.value as! Float) - 1.0
            brightnessCharacteristic.writeValue(newValue,
              completionHandler: {error in
                
                if error != nil{
                  print("Failed to set the brightness value")
                } else {
                  print("Successfully set the brightness value")
                }
                
              })
          } else {
            print("The brightness characteristic is not writable")
          }
          
        }
        
      }
      
      if brightnessCharacteristic.value is Float{
        
      } else {
        print("The value of the brightness is not Float. Cannot set it")
      }
      
    }
    
  }
  
  func findCinemaRoomProjectorAccessory(){
    
    for accessory in room.accessories{
      if accessory.name == accessoryName{
        print("Found the projector accessory in the room")
        self.projectorAccessory = accessory
      }
    }
    
    /* Start searching for accessories */
    if self.projectorAccessory == nil{
      print("Could not find the projector accessory in the room")
      print("Starting to search for all available accessories")
      accessoryBrowser.startSearchingForNewAccessories()
    } else {
      lowerBrightnessOfProjector()
    }
    
  }
  
  override func viewDidLoad() {
    
    homeManager = HMHomeManager()
    homeManager.delegate = self
    
  }
  
}

