//
//  AddRoomViewController.swift
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

class AddRoomViewController: UIViewController{

  @IBOutlet weak var textField: UITextField!
  var homeManager: HMHomeManager!
  var home: HMHome!
  
  @IBAction func addRoom(){
    
    guard let text = textField.text where text.characters.count > 0 else {
      UIAlertController.showAlertControllerOnHostController(self,
        title: "Room name", message: "Please enter the room name",
        buttonTitle: "OK")
      return
    }
    
    home.addRoomWithName(textField.text!, completionHandler: {room, error in
      
      if error != nil{
        UIAlertController.showAlertControllerOnHostController(self,
          title: "Error happened", message: "\(error)",
          buttonTitle: "OK")
      } else {
        self.navigationController!.popViewControllerAnimated(true)
      }
      
      })

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    textField.becomeFirstResponder()
    
  }

}
