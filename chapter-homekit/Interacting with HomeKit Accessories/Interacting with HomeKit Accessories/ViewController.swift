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
    if let propeties = self.properties{
      for property in properties as [String]{
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
      if countElements(name) > 0 {
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
      [weak self](room: HMRoom!, error: NSError!) in
      
      if error != nil{
        println("Failed to create the room")
      } else {
        println("Successuflly created the room")
        let strongSelf = self!
        strongSelf.room = room
        strongSelf.findCinemaRoomProjectorAccessory()
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
  
  func homeManagerDidUpdateHomes(manager: HMHomeManager!) {
    
    for home in manager.homes as [HMHome]{
      if home.name == homeName{
        
        println("Found the home")
        self.home = home
        
        for room in home.rooms as [HMRoom]{
          if room.name == roomName{
            println("Found the room")
            self.room = room
            findCinemaRoomProjectorAccessory()
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
  
  func accessoryBrowser(browser: HMAccessoryBrowser!,
    didFindNewAccessory accessory: HMAccessory!) {
      
      println("Found an accessory...")
      
      if accessory.name == accessoryName{
        println("Discovered the projector accessory")
        println("Adding it to the home")
        home.addAccessory(accessory, completionHandler: {
          [weak self](error: NSError!) in
          
          if error != nil{
            println("Failed to add it to the home")
          } else {
            println("Successfully added it to home")
            println("Assigning the projector to the room...")
            let strongSelf = self!
            strongSelf.home.assignAccessory(accessory,
              toRoom: strongSelf.room,
              completionHandler: {(error: NSError!) in
                
                if error != nil{
                  println("Failed to assign the projector to the room")
                } else {
                  strongSelf.projectorAccessory = accessory
                  println("Successfully assigned the projector to the room")
                  strongSelf.lowerBrightnessOfProjector()
                }
                
              })
            
          }
          
          })
      }
      
  }
  
  func lowerBrightnessOfProjector(){
    
    var brightnessCharacteristic: HMCharacteristic!
    
    println("Finding the brightness characteristic of the projector...")
    
    for service in projectorAccessory.services as [HMService]{
      for characteristic in service.characteristics as [HMCharacteristic]{
        if characteristic.characteristicType == HMCharacteristicTypeBrightness{
          println("Found it")
          brightnessCharacteristic = characteristic
        }
      }
    }
    
    if brightnessCharacteristic == nil{
      println("Could not find it")
    } else {
      
      if brightnessCharacteristic.isReadable() == false{
        println("Cannot read the value of the brightness characteristic")
        return
      }
      
      println("Reading the value of the brightness characteristic...")
      
      brightnessCharacteristic.readValueWithCompletionHandler{[weak self]
        (error: NSError!) in
        
        if error != nil{
          println("Could not read the brightness value")
        } else {
          println("Read the brightness value. Setting it now...")
          
          if brightnessCharacteristic.isWritable(){
            let newValue = (brightnessCharacteristic.value as Float) - 1.0
            brightnessCharacteristic.writeValue(newValue,
              completionHandler: {(error: NSError!) in
                
                if error != nil{
                  println("Failed to set the brightness value")
                } else {
                  println("Successfully set the brightness value")
                }
                
              })
          } else {
            println("The brightness characteristic is not writable")
          }
          
        }
        
      }
      
      if brightnessCharacteristic.value is Float{
        
      } else {
        println("The value of the brightness is not Float. Cannot set it")
      }
      
    }
    
  }
  
  func findCinemaRoomProjectorAccessory(){
    
    if let accessories = room.accessories{
      for accessory in accessories as [HMAccessory]{
        if accessory.name == accessoryName{
          println("Found the projector accessory in the room")
          self.projectorAccessory = accessory
        }
      }
    }
    
    /* Start searching for accessories */
    if self.projectorAccessory == nil{
      println("Could not find the projector accessory in the room")
      println("Starting to search for all available accessories")
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

