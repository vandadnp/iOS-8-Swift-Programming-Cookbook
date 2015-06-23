//
//  ViewController.swift
//  Pinpointing the Location of a Device
//
//  Created by Vandad Nahavandipoor on 7/7/14.
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
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager?
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    
    if locations.count == 0{
      //handle error here
      return
    }
    
    let newLocation = locations[0] as! CLLocation
    
    print("Latitude = \(newLocation.coordinate.latitude)")
    print("Longitude = \(newLocation.coordinate.longitude)")
    
  }
  
  func locationManager(manager: CLLocationManager,
    didFailWithError error: NSError){
      print("Location manager failed with error = \(error)")
  }
  
  func locationManager(manager: CLLocationManager,
    didChangeAuthorizationStatus status: CLAuthorizationStatus){
      
      print("The authorization status of location services is changed to: ", appendNewline: false)
      
      switch CLLocationManager.authorizationStatus(){
      case .AuthorizedAlways:
        print("Authorized")
      case .AuthorizedWhenInUse:
        print("Authorized when in use")
      case .Denied:
        print("Denied")
      case .NotDetermined:
        print("Not determined")
      case .Restricted:
        print("Restricted")
      }
      
  }
  
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
  func createLocationManager(startImmediately startImmediately: Bool){
    locationManager = CLLocationManager()
    if let manager = locationManager{
      print("Successfully created the location manager")
      manager.delegate = self
      if startImmediately{
        manager.startUpdatingLocation()
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Are location services available on this device? */
    if CLLocationManager.locationServicesEnabled(){
      
      /* Do we have authorization to access location services? */
      switch CLLocationManager.authorizationStatus(){
      case .AuthorizedAlways:
        /* Yes, always */
        createLocationManager(startImmediately: true)
      case .AuthorizedWhenInUse:
        /* Yes, only when our app is in use */
        createLocationManager(startImmediately: true)
      case .Denied:
        /* No */
        displayAlertWithTitle("Not Determined",
          message: "Location services are not allowed for this app")
      case .NotDetermined:
        /* We don't know yet, we have to ask */
        createLocationManager(startImmediately: false)
        if let manager = self.locationManager{
          manager.requestWhenInUseAuthorization()
        }
      case .Restricted:
        /* Restrictions have been applied, we have no access
        to location services */
        displayAlertWithTitle("Restricted",
          message: "Location services are not allowed for this app")
      }
      
      
    } else {
      /* Location services are not enabled.
      Take appropriate action: for instance, prompt the
      user to enable the location services */
      print("Location services are not enabled")
    }
  }
  
}

