//
//  ViewController.swift
//  Serializing and Deserializing JSON Objects
//
//  Created by Vandad Nahavandipoor on 7/9/14.
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

/* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//                            
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let dictionary:[NSString : AnyObject] =
//    [
//      "First Name" : "Anthony",
//      "Last Name" : "Robbins",
//      "Age" : 51,
//      "children" : [
//        "Anthony's Son 1",
//        "Anthony's Daughter 1",
//        "Anthony's Son 2",
//        "Anthony's Son 3",
//        "Anthony's Daughter 2"
//      ],
//    ]
//    
//    var error: NSError?
//    let jsonData = NSJSONSerialization.dataWithJSONObject(dictionary,
//      options: .PrettyPrinted,
//      error: &error)
//    
//    if let data = jsonData{
//      if data.length > 0 && error == nil{
//        println("Successfully serialized the dictionary into data \(jsonData)")
//      }
//      else if data.length == 0 && error == nil{
//        println("No data was returned after serialization.")
//      }
//      else if error != nil{
//        println("An error happened = \(error)")
//      }
//    }
//    
//  }
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    let dictionary:[NSString : AnyObject] =
//    [
//      "First Name" : "Anthony",
//      "Last Name" : "Robbins",
//      "Age" : 51,
//      "children" : [
//        "Anthony's Son 1",
//        "Anthony's Daughter 1",
//        "Anthony's Son 2",
//        "Anthony's Son 3",
//        "Anthony's Daughter 2"
//      ],
//    ]
//    
//    /* Convert the dictionary into a data structure */
//    var error: NSError?
//    let jsonData = NSJSONSerialization.dataWithJSONObject(dictionary,
//      options: .PrettyPrinted,
//      error: &error)
//    
//    if let data = jsonData{
//      if data.length > 0 && error == nil{
//        println("Successfully serialized the dictionary into data")
//        
//        /* Then convert the data into a string */
//        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
//        println("JSON String = \(jsonString)")
//        
//      }
//      else if data.length == 0 && error == nil{
//        println("No data was returned after serialization.")
//      }
//      else if error != nil{
//        println("An error happened = \(error)")
//      }
//    }
//    
//  }
//  
//}

/* 3 */
import UIKit

class ViewController: UIViewController {
  
  func retrieveJsonFromData(data: NSData){
    
    /* Now try to deserialize the JSON object into a dictionary */
    var error: NSError?
    
    let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
      options: .AllowFragments,
      error: &error)
    
    if  error == nil{
      
      println("Successfully deserialized...")
      
      if jsonObject is NSDictionary{
        let deserializedDictionary = jsonObject as! NSDictionary
        println("Deserialized JSON Dictionary = \(deserializedDictionary)")
      }
      else if jsonObject is NSArray{
        let deserializedArray = jsonObject as! NSArray
        println("Deserialized JSON Array = \(deserializedArray)")
      }
      else {
        /* Some other object was returned. We don't know how to
        deal with this situation as the deserializer only
        returns dictionaries or arrays */
      }
    }
    else if error != nil{
      println("An error happened while deserializing the JSON data.")
    }
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let dictionary = [1, 2, 3]
    [
      "First Name" : "Anthony",
      "Last Name" : "Robbins",
      "Age" : 51,
      "children" : [
        "Anthony's Son 1",
        "Anthony's Daughter 1",
        "Anthony's Son 2",
        "Anthony's Son 3",
        "Anthony's Daughter 2"
      ],
    ]

    /* Convert the dictionary into a data structure */
    var error: NSError?
    let jsonData = NSJSONSerialization.dataWithJSONObject(dictionary,
      options: .PrettyPrinted,
      error: &error)
    
    if let data = jsonData{
      if data.length > 0 && error == nil{
        println("Successfully serialized the dictionary into data")
        
        retrieveJsonFromData(data)
        
      }
      else if data.length == 0 && error == nil{
        println("No data was returned after serialization.")
      }
      else if error != nil{
        println("An error happened = \(error)")
      }
    }

    
  }

}
