//
//  ViewController.swift
//  Defining and Processing iBeacons - Source
//
//  Created by Vandad Nahavandipoor on 7/8/14.
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
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
  
  var peripheralManager : CBPeripheralManager?
  
  /* A newly-generated UUID for our beacon */
  let uuid = NSUUID()
  
  /* The identifier of our beacon is the identifier of our bundle here */
  let identifier = NSBundle.mainBundle().bundleIdentifier!
  
  /* Made up major and minor versions of our beacon region */
  let major: CLBeaconMajorValue = 1
  let minor: CLBeaconMinorValue = 0

  func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!,
    error: NSError!){
      
      if error == nil{
        println("Successfully started advertising our beacon data")
        
        let message = "Successfully set up your beacon. " +
        "The unique identifier of our service is: \(uuid.UUIDString)"
        
        println(message)
        
        let controller = UIAlertController(title: "iBeacon",
          message: message,
          preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
          style: .Default,
          handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
      } else {
        println("Failed to advertise our beacon. Error = \(error)")
      }
      
  }
  
  func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!){
    
    peripheral.stopAdvertising()
    
    print("The peripheral state is ")
    switch peripheral.state{
    case .PoweredOff:
      println("Powered off")
    case .PoweredOn:
      println("Powered on")
    case .Resetting:
      println("Resetting")
    case .Unauthorized:
      println("Unauthorized")
    case .Unknown:
      println("Unknown")
    case .Unsupported:
      println("Unsupported")
    }
    
    /* Bluetooth is now powered on */
    if peripheral.state != .PoweredOn{
      
      let controller = UIAlertController(title: "Bluetooth",
        message: "Please turn Bluetooth on",
        preferredStyle: .Alert)
      
      controller.addAction(UIAlertAction(title: "OK",
        style: .Default,
        handler: nil))
      
      presentViewController(controller, animated: true, completion: nil)
      
    } else {
      
      let region = CLBeaconRegion(proximityUUID: uuid,
        major: major,
        minor: minor,
        identifier: identifier)
      
      let manufacturerData = identifier.dataUsingEncoding(
        NSUTF8StringEncoding,
        allowLossyConversion: false)
      
      let theUUid = CBUUID.UUIDWithNSUUID(uuid)
      
      let dataToBeAdvertised:[String: AnyObject!] = [
        CBAdvertisementDataLocalNameKey : "Sample peripheral",
        CBAdvertisementDataManufacturerDataKey : manufacturerData,
        CBAdvertisementDataServiceUUIDsKey : [theUUid],
      ]
      
      peripheral.startAdvertising(dataToBeAdvertised)
      
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
    if let manager = peripheralManager{
      manager.delegate = self
    }
    
  }
  
  
}

