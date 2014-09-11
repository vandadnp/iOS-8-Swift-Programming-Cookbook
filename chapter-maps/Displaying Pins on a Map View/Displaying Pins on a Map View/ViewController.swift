//
//  ViewController.swift
//  Displaying Pins on a Map View
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

class ViewController: UIViewController, MKMapViewDelegate {
  var mapView: MKMapView!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    mapView = MKMapView()
  }
  
  /* We have a pin on the map, now zoom into it and make that pin
  the center of the map */
  func setCenterOfMapToLocation(location: CLLocationCoordinate2D){
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func addPinToMapView(){
    
    /* This is just a sample location */
    let location = CLLocationCoordinate2D(latitude: 58.592737,
      longitude: 16.185898)
    
    /* Create the annotation using the location */
    let annotation = MyAnnotation(coordinate: location,
      title: "My Title",
      subtitle: "My Sub Title")
    
    /* And eventually add it to the map */
    mapView.addAnnotation(annotation)
    
    /* And now center the map around the point */
    setCenterOfMapToLocation(location)
    
  }
  
  /* Set up the map and add it to our view */
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.mapType = .Standard
    mapView.frame = view.frame
    mapView.delegate = self
    view.addSubview(mapView)
  }
  
  /* Add the pin to the map and center the map around the pin */
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    addPinToMapView()
  }
  
}

