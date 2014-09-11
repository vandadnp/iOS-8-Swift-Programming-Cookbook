//
//  ListRoomsTableViewController.swift
//  Adding Rooms to the User’s Home
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

class ListRoomsTableViewController: UITableViewController, HMHomeDelegate {
  
  var homeManager: HMHomeManager!
  var home: HMHome!{
  didSet{
    home.delegate = self
  }
  }
  
  struct TableViewValues{
    static let identifier = "Cell"
  }
  
  let addRoomSegueIdentifier = "addRoom"
  
  func home(home: HMHome!, didAddRoom room: HMRoom!) {
    println("Added a new room to the home")
  }
  
  func home(home: HMHome!, didRemoveRoom room: HMRoom!) {
    println("A room has been removed from the home")
  }
  
  override func tableView(tableView: UITableView!,
    numberOfRowsInSection section: Int) -> Int {
      return home.rooms.count
      
  }
  
  override func tableView(tableView: UITableView!,
    cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
      
      let cell = tableView.dequeueReusableCellWithIdentifier(
        TableViewValues.identifier, forIndexPath: indexPath)
        as UITableViewCell
      
      let room = home.rooms[indexPath.row] as HMRoom
      
      cell.textLabel.text = room.name
      
      return cell
      
  }
  
  override func tableView(tableView: UITableView!,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath!) {
      
      if editingStyle == .Delete{
        
        let room = home.rooms[indexPath.row] as HMRoom
        home.removeRoom(room, completionHandler: {[weak self]
          (error: NSError!) in
          
          let strongSelf = self!
          
          if error != nil{
            UIAlertController.showAlertControllerOnHostController(strongSelf,
              title: "Error",
              message: "An error occurred = \(error)",
              buttonTitle: "OK")
          } else {
            
            tableView.deleteRowsAtIndexPaths([indexPath],
              withRowAnimation: .Automatic)
            
          }
          
          })
        
      }
      
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue!,
    sender: AnyObject!) {
      
      if segue.identifier == addRoomSegueIdentifier{
        
        let controller = segue.destinationViewController
          as AddRoomViewController
        
        controller.homeManager = homeManager
        controller.home = home
        
      }
      
  }
  
}
