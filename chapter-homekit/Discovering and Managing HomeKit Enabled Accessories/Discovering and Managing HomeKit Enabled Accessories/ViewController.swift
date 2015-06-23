//
//  ViewController.swift
//  Discovering and Managing HomeKit Enabled Accessories
//
//  Created by Vandad Nahavandipoor on 7/25/14.
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

class ViewController: UIViewController, HMHomeManagerDelegate,
HMAccessoryBrowserDelegate {
  
  var accessories = [HMAccessory]()
  var home: HMHome!
  var room: HMRoom!
  
  lazy var accessoryBrowser: HMAccessoryBrowser = {
    let browser = HMAccessoryBrowser()
    browser.delegate = self
    return browser
    }()
  
  var randomHomeName: String = {
    return "Home \(arc4random_uniform(UInt32.max))"
    }()
  
  let roomName = "Bedroom 1"
  
  var homeManager: HMHomeManager!
  
  func homeManagerDidUpdateHomes(manager: HMHomeManager) {
    
    manager.addHomeWithName(randomHomeName, completionHandler: {home, error in
      
      guard let home = home else {
        print("Could not add the home")
        return
      }
      
      self.home = home
      print("Successfully added a home")
      print("Adding a room to the home...")
      home.addRoomWithName(self.roomName, completionHandler: {
        room, error in
        
        if error != nil{
          print("Failed to add a room...")
        } else {
          self.room = room
          print("Successfully added a room.")
          print("Discovering accessories now...")
          self.accessoryBrowser.startSearchingForNewAccessories()
        }
        
      })
      
      })
    
  }
  
  func findCharacteristicsOfService(service: HMService){
    for characteristic in service.characteristics as [HMCharacteristic]{
      print("   Characteristic type = " +
        "\(characteristic.characteristicType)")
    }
  }
  
  func findServicesForAccessory(accessory: HMAccessory){
    print("Finding services for this accessory...")
    for service in accessory.services as [HMService]{
      print(" Service name = \(service.name)")
      print(" Service type = \(service.serviceType)")
      
      print(" Finding the characteristics for this service...")
      findCharacteristicsOfService(service)
    }
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didFindNewAccessory accessory: HMAccessory) {
      
      print("Found a new accessory")
      print("Adding it to the home...")
      home.addAccessory(accessory, completionHandler: {error in
        
        if error != nil{
          print("Failed to add the accessory to the home")
          print("Error = \(error)")
        } else {
          print("Successfully added the accessory to the home")
          print("Assigning the accessory to the room...")
          self.home.assignAccessory(accessory,
            toRoom: self.room,
            completionHandler: {error in
              
              if error != nil{
                print("Failed to assign the accessory to the room")
                print("Error = \(error)")
              } else {
                print("Successfully assigned the accessory to the room")
                
                self.findServicesForAccessory(accessory)
                
              }
              
            })
        }
        
        })
      
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didRemoveNewAccessory accessory: HMAccessory){
      
      print("An accessory has been removed")
      
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    homeManager = HMHomeManager()
    homeManager.delegate = self
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    accessoryBrowser.stopSearchingForNewAccessories()
  }
  
}

