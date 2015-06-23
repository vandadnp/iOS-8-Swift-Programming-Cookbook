//
//  ViewController.swift
//  Searching on a Map View
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
  
  func mapView(mapView: MKMapView,
    didFailToLocateUserWithError error: NSError) {
    displayAlertWithTitle("Failed",
      message: "Could not get the user's location")
  }
  
  func mapView(mapView: MKMapView,
    didUpdateUserLocation userLocation: MKUserLocation) {
      
      let request = MKLocalSearchRequest()
      request.naturalLanguageQuery = "restaurants";
      
      let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
      
      request.region = MKCoordinateRegion(
        center: userLocation.location!.coordinate,
        span: span)
      
      let search = MKLocalSearch(request: request)
      
      search.startWithCompletionHandler{
        response, error in
        
        guard let response = response else {
          return
        }
        
        for item in response.mapItems{
          
          print("Item name = \(item.name)")
          print("Item phone number = \(item.phoneNumber)")
          print("Item url = \(item.url)")
          print("Item location = \(item.placemark.location)")
          
        }
        
      }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    
    if locations.count == 0{
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
  
  /* The authorization status of the user has changed, we need to react
  to that so that if she has authorized our app to to view her location,
  we will accordingly attempt to do so */
  func locationManager(manager: CLLocationManager,
    didChangeAuthorizationStatus status: CLAuthorizationStatus){
      
      print("The authorization status of location services is changed to: ", appendNewline: false)
      
      switch CLLocationManager.authorizationStatus(){
      case .Denied:
        print("Denied")
      case .NotDetermined:
        print("Not determined")
      case .Restricted:
        print("Restricted")
      default:
        showUserLocationOnMapView()
      }
      
  }
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
  /* We will call this method when we are sure that the user has given 
  us access to her location */
  func showUserLocationOnMapView(){
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .Follow
  }
  
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
        if let manager = locationManager{
          manager.delegate = self
          manager.requestWhenInUseAuthorization()
        }
      case .Restricted:
        /* Restrictions have been applied, we have no access
        to location services */
        displayAlertWithTitle("Restricted",
          message: "Location services are not allowed for this app")
      default:
        showUserLocationOnMapView()
      }
      
      
    } else {
      /* Location services are not enabled.
      Take appropriate action: for instance, prompt the
      user to enable the location services */
      print("Location services are not enabled")
    }
  }
  
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
  
}

