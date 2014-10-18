//
//  ViewController.swift
//  Displaying Directions on The Map
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
import MapKit

class ViewController: UIViewController,
MKMapViewDelegate, CLLocationManagerDelegate {
  
  var mapView: MKMapView!
  var locationManager: CLLocationManager?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    mapView = MKMapView()
    
  }
  
  /* Set up the map and add it to our view */
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.mapType = .Standard
    mapView.frame = view.frame
    mapView.delegate = self
    view.addSubview(mapView)
  }
  
  func provideDirections(){
    let destination = "Godsgatan, Norrköping, Sweden"
    CLGeocoder().geocodeAddressString(destination,
      completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
        
        if error != nil{
          /* Handle the error here perhaps by displaying an alert */
        } else {
          let request = MKDirectionsRequest()
          request.setSource(MKMapItem.mapItemForCurrentLocation())
          
          /* Convert the CoreLocation destination
          placemark to a MapKit placemark */
          let placemark = placemarks[0] as CLPlacemark
          let destinationCoordinates =
          placemark.location.coordinate
          /* Get the placemark of the destination address */
          let destination = MKPlacemark(coordinate: destinationCoordinates,
            addressDictionary: nil)
          
          request.setDestination(MKMapItem(placemark: destination))
          
          /* Set the transportation method to automobile */
          request.transportType = .Automobile
          
          /* Get the directions */
          let directions = MKDirections(request: request)
          directions.calculateDirectionsWithCompletionHandler{
            (response: MKDirectionsResponse!, error: NSError!) in
            
            /* You can manually parse the response, but in here we will take
            a shortcut and use the Maps app to display our source and
            destination. We didn't have to make this API call at all,
            as we already had the map items before, but this is to
            demonstrate that the directions response contains more
            information than just the source and the destination. */
            
            /* Display the directions on the Maps app */
            let launchOptions = [
              MKLaunchOptionsDirectionsModeKey:
              MKLaunchOptionsDirectionsModeDriving]
            
            MKMapItem.openMapsWithItems([response.source, response.destination],
              launchOptions: launchOptions)
          }
          
        }
        
      })
  }
  
  func locationManager(manager: CLLocationManager!,
    didChangeAuthorizationStatus status: CLAuthorizationStatus){
      
      print("The authorization status of location services is changed to: ")
      
      switch CLLocationManager.authorizationStatus(){
      case .Denied:
        println("Denied")
      case .NotDetermined:
        println("Not determined")
      case .Restricted:
        println("Restricted")
      default:
        println("Authorized")
        provideDirections()
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
  
  /* Add the pin to the map and center the map around the pin */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Are location services available on this device? */
    if CLLocationManager.locationServicesEnabled(){
      
      /* Do we have authorization to access location services? */
      switch CLLocationManager.authorizationStatus(){
      case .Denied:
        /* No */
        displayAlertWithTitle("Not Determined",
          message: "Location services are not allowed for this app")
      case .NotDetermined:
        /* We don't know yet, we have to ask */
        locationManager = CLLocationManager()
        if let manager = self.locationManager{
          manager.delegate = self
          manager.requestWhenInUseAuthorization()
        }
      case .Restricted:
        /* Restrictions have been applied, we have no access
        to location services */
        displayAlertWithTitle("Restricted",
          message: "Location services are not allowed for this app")
      default:
        provideDirections()
      }
      
      
    } else {
      /* Location services are not enabled.
      Take appropriate action: for instance, prompt the
      user to enable the location services */
      println("Location services are not enabled")
    }
    
  }
  
}

