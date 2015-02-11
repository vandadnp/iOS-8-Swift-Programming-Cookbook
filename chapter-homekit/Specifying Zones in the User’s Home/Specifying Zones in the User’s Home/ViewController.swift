//
//  ViewController.swift
//  Specifying Zones in the User’s Home
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

class ViewController: UIViewController, HMHomeManagerDelegate{
  
  /* We use this name to search in the list of rooms added to the home
  and read their names and find this string in them. If we
  find this string, we are sure that the room is a bedroom indeed */
  let bedroomKeyword = "bedroom"
  var numberOfBedroomsAddedSoFar = 0
  let numberOfBedroomsToAdd = 2
  var home: HMHome!
  var bedroomZone: HMZone!
  
  var randomHomeName: String = {
    return "Home \(arc4random_uniform(UInt32.max))"
    }()
  
  var homeManager: HMHomeManager!
  
  func roomAddedToZoneCompletionHandler(error: NSError!){
    
    if error != nil{
      println("Failed to add room to zone. Error = \(error)")
    } else {
      println("Successfully added a bedroom to the bedroom zone")
      numberOfBedroomsAddedSoFar++
    }
    
    if numberOfBedroomsAddedSoFar == numberOfBedroomsToAdd{
      home.removeZone(bedroomZone, completionHandler: {[weak self]
        (error: NSError!) in
        
        let strongSelf = self!
        
        if error != nil{
          println("Failed to remove the zone")
        } else {
          println("Successfully removed the zone")
          println("Removing the home now...")
          
          strongSelf.homeManager.removeHome(strongSelf.home,
            completionHandler: {(error: NSError!) in
              
              if error != nil{
                println("Failed to remove the home")
              } else {
                println("Removed the home")
              }
              
            })
          
        }
        
        })
    }
    
  }
  
  func roomAddedToHomeCompletionHandler(room: HMRoom!, error: NSError!){
    
    if error != nil{
      println("Failed to add room to home. Error = \(error)")
    } else {
      if (room.name as NSString).rangeOfString(bedroomKeyword,
        options: .CaseInsensitiveSearch).location != NSNotFound{
          println("A bedroom is added to the home")
          println("Adding it to the zone...")
          bedroomZone.addRoom(room, completionHandler:
            self.roomAddedToZoneCompletionHandler)
      } else {
        println("The room that is added is not a bedroom")
      }
    }
    
  }
  
  func addZoneCompletionHandler(zone: HMZone!, error: NSError!){
    
    if error != nil{
      println("Failed to add the zone. Error = \(error)")
      return
    } else {
      println("Successfully added the zone")
      println("Adding bedrooms to the home now...")
    }
    
    bedroomZone = zone
    
    /* Now add rooms to this home */
    home.addRoomWithName("Master bedroom",
      completionHandler: self.roomAddedToHomeCompletionHandler)
    
    home.addRoomWithName("Kids' bedroom",
      completionHandler: self.roomAddedToHomeCompletionHandler)
    
    home.addRoomWithName("Gaming room",
      completionHandler: self.roomAddedToHomeCompletionHandler)
  }
  
  func homeManagerDidUpdateHomes(manager: HMHomeManager) {
    
    manager.addHomeWithName(randomHomeName, completionHandler: {
      [weak self](home: HMHome!, error :NSError!) in
      
      let strongSelf = self!
      
      if error != nil{
        println("Failed to add the home. Error = \(error)")
        return
      }
      
      strongSelf.home = home
      
      /* Now let's add the "bedrooms" zone to the home */
      home.addZoneWithName("Bedrooms", completionHandler:
        strongSelf.addZoneCompletionHandler)
      
      })
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    homeManager = HMHomeManager()
    homeManager.delegate = self
    
  }
  
  
}

