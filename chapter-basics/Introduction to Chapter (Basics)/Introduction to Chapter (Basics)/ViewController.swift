//
//  ViewController.swift
//  Introduction to Chapter (Basics)
//
//  Created by Vandad NP on 10/18/14.
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

class ViewController: UIViewController {
  
  func example1(){
    let integerValue = 10
    let stringValue = "Swift"
    let doubleValue = 10.0
    print(integerValue)
    print(stringValue)
    print(doubleValue)
  }
  
  func example2(){
    let integerFromDouble = 10.7 as Int
    /* The value of this variable is 10
    because the compiler truncated the value to an integer*/
    print(integerFromDouble)
  }
  
  func example3(){
    var myString = "Swi"
    myString += "ft"
    /* myString is now "Swift" */
  }
  
  func example4(){
    let allStrings = ["Swift", "Objective-C"]
    print(allStrings)
  }
  
  func example5(){
    var allStrings = [String]()
    allStrings.append("Swift")
    allStrings.append("Objective-C")
    /* Our array is now ["Swift", "Objective-C" */
  }
  
  func example6(){
    var allStrings = [String]()
    allStrings.append("Swift")
    allStrings.append("Objective-C")
    
    print(allStrings[0]) /* Prints out "Swift" */
    
    allStrings.insert("C++", atIndex: 0)
    
    print(allStrings[0]) /* Prints out "C++" */
  }
  
  func example7(){
    let allFullNames = [
      "Vandad"  : "Nahavandipoor",
      "Andy"    : "Oram",
      "Molly"   : "Lindstedt"
    ]
    print(allFullNames["Vandad"]) /* Prints out "Nahavandipoor" */
  }

  func example8(){
    var allFullNames = [
      "Vandad"  : "Nahavandipoor",
      "Andy"    : "Oram",
      "Molly"   : "Lindstedt"
    ]
    
    allFullNames["Rachel"] = "Roumeliotis"
  }
  
  func example9(){
    let personInformation = [
      "numberOfChildren"  : 2,
      "age"               : 32,
      "name"              : "Random person",
      "job"               : "Something cool",
      ] as [String : AnyObject]
    print(personInformation)
  }
  
  func example10(){
    struct Person{
      var firstName, lastName: String
      
      mutating func setFirstNameTo(firstName: String){
        self.firstName = firstName
      }
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

