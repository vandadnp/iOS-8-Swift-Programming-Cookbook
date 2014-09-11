//
//  ViewController.swift
//  Defining and Processing iBeacons - Destination
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
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  var locationManager: CLLocationManager!
  
  /* Place your beacon UUID here. This is the UUID of the source
  application that we have already written. I have now run that app
  on a device and copied and pasted the UUID here in the destination
  application */
  let uuid = NSUUID(UUIDString: "1FBF369D-6E55-4F3C-A4DA-CDE6155920A1")
  /* This is the identifier of the beacon that we just wrote. The identifier
  of the beacon was chosen by us to be the same as the bundle id of
  that app */
  let identifier = "com.pixolity.ios.Defining-and-Processing-iBeacons---Source"
  
/* This will let us know when we are exiting the region of the beacon */
func locationManager(manager: CLLocationManager!,
  didExitRegion region: CLRegion!){
    
    println("You are exiting the region of a beacon " +
      "with an identifier of \(region.identifier)")
    
}
  
  /* We will know when we have made contact with a beacon here */
  func locationManager(manager: CLLocationManager!,
    didRangeBeacons beacons: [AnyObject]!,
    inRegion region: CLBeaconRegion!){
      
      print("Found a beacon with the proximity of = ")
      
      /* How close are we to the beacon? */
      for beacon in beacons as [CLBeacon]{
        switch beacon.proximity{
        case .Far:
          println("Far")
        case .Immediate:
          println("Immediate")
        case .Near:
          println("Near")
        default:
          println("Unknown")
        }
      }
      
  }
  
  required init(coder aDecoder: NSCoder) {
    locationManager = CLLocationManager()
    super.init(coder: aDecoder)
    locationManager.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let region = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
    locationManager.startRangingBeaconsInRegion(region)
    
  }
  
}

