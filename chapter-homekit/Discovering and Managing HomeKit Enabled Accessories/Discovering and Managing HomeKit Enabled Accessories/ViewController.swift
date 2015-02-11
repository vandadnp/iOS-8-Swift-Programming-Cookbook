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
    
    manager.addHomeWithName(randomHomeName, completionHandler: {[weak self]
      (home: HMHome!, error: NSError!) in
      
      if error != nil{
        println("Could not add the home")
      } else {
        let strongSelf = self!
        strongSelf.home = home
        println("Successfully added a home")
        println("Adding a room to the home...")
        home.addRoomWithName(strongSelf.roomName, completionHandler: {
          (room: HMRoom!, error: NSError!) in
          
          if error != nil{
            println("Failed to add a room...")
          } else {
            strongSelf.room = room
            println("Successfully added a room.")
            println("Discovering accessories now...")
            strongSelf.accessoryBrowser.startSearchingForNewAccessories()
          }
          
          })
        
      }
      
      })
    
  }
  
  func findCharacteristicsOfService(service: HMService){
    for characteristic in service.characteristics as! [HMCharacteristic]{
      println("   Characteristic type = " +
        "\(characteristic.characteristicType)")
    }
  }
  
  func findServicesForAccessory(accessory: HMAccessory){
    println("Finding services for this accessory...")
    for service in accessory.services as! [HMService]{
      println(" Service name = \(service.name)")
      println(" Service type = \(service.serviceType)")
      
      println(" Finding the characteristics for this service...")
      findCharacteristicsOfService(service)
    }
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didFindNewAccessory accessory: HMAccessory!) {
      
      println("Found a new accessory")
      println("Adding it to the home...")
      home.addAccessory(accessory, completionHandler: {[weak self]
        (error: NSError!) in
        
        let strongSelf = self!
        
        if error != nil{
          println("Failed to add the accessory to the home")
          println("Error = \(error)")
        } else {
          println("Successfully added the accessory to the home")
          println("Assigning the accessory to the room...")
          strongSelf.home.assignAccessory(accessory,
            toRoom: strongSelf.room,
            completionHandler: {(error: NSError!) in
              
              if error != nil{
                println("Failed to assign the accessory to the room")
                println("Error = \(error)")
              } else {
                println("Successfully assigned the accessory to the room")
                
                strongSelf.findServicesForAccessory(accessory)
                
              }
              
            })
        }
        
        })
      
  }
  
  func accessoryBrowser(browser: HMAccessoryBrowser,
    didRemoveNewAccessory accessory: HMAccessory!){
      
      println("An accessory has been removed")
      
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

