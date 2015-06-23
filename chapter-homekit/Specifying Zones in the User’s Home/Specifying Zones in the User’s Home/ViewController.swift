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
  
  func roomAddedToZoneCompletionHandler(error: NSError?){
    
    if error != nil{
      print("Failed to add room to zone. Error = \(error)")
    } else {
      print("Successfully added a bedroom to the bedroom zone")
      numberOfBedroomsAddedSoFar++
    }
    
    if numberOfBedroomsAddedSoFar == numberOfBedroomsToAdd{
      home.removeZone(bedroomZone, completionHandler: {error in
        
        if error != nil{
          print("Failed to remove the zone")
        } else {
          print("Successfully removed the zone")
          print("Removing the home now...")
          
          self.homeManager.removeHome(self.home,
            completionHandler: {error in
              
              if error != nil{
                print("Failed to remove the home")
              } else {
                print("Removed the home")
              }
              
            })
          
        }
        
        })
    }
    
  }
  
  func roomAddedToHomeCompletionHandler(room: HMRoom?, error: NSError?){
    
    guard let room = room else {
      print("Failed to add room to home. Error = \(error)")
      return
    }
    
    if (room.name as NSString).rangeOfString(bedroomKeyword,
      options: .CaseInsensitiveSearch).location != NSNotFound{
        print("A bedroom is added to the home")
        print("Adding it to the zone...")
        bedroomZone.addRoom(room, completionHandler:
          self.roomAddedToZoneCompletionHandler)
    } else {
      print("The room that is added is not a bedroom")
    }
    
  }
  
  func addZoneCompletionHandler(zone: HMZone?, error: NSError?){
    
    if error != nil{
      print("Failed to add the zone. Error = \(error)")
      return
    } else {
      print("Successfully added the zone")
      print("Adding bedrooms to the home now...")
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
      home, error in
      
      guard let home = home else {
        print("Failed to add the home")
        return
      }
      
      /* Now let's add the "bedrooms" zone to the home */
      home.addZoneWithName("Bedrooms", completionHandler:
        self.addZoneCompletionHandler)
      
      })
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    homeManager = HMHomeManager()
    homeManager.delegate = self
    
  }
  
  
}

