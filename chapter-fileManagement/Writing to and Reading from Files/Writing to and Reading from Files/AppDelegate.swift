//
//  AppDelegate.swift
//  Writing to and Reading from Files
//
//  Created by Vandad Nahavandipoor on 6/20/14.
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func example1(){
    let someText = NSString(string: "Put some string here")
    let destinationPath = NSTemporaryDirectory() + "MyFile.txt"
    do {
      try someText.writeToFile(destinationPath,
            atomically: true,
            encoding: NSUTF8StringEncoding)
      print("Successfully stored the file at path \(destinationPath)")
    } catch let error as NSError {
      print("An error occurred: \(error)")
    }
    
  }
  
  func example2(){
    
    let path = NSTemporaryDirectory() + "MyFile.txt"
    
    do {
      try "Hello, World!".writeToFile(path,
            atomically: true,
            encoding: NSUTF8StringEncoding)
      /* Now read from the same file */
      let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
      print("The read string is: \(readString)")
    } catch let error as NSError {
      print("Could not write. Error = \(error)")
    }
    
  }
  
  func example3(){
    
    let path = NSTemporaryDirectory() + "MyFile.txt"
    let arrayOfNames:NSArray = ["Steve", "John", "Edward"]
    
    if arrayOfNames.writeToFile(path, atomically: true){
      let readArray:NSArray? = NSArray(contentsOfFile: path)
      if let array = readArray{
        print("Could read the array back = \(array)")
      } else {
        print("Failed to read the array back")
      }
    }
    
  }
  
  func example4(){
    
    let path = NSTemporaryDirectory() + "MyFile.txt"
    let dict:NSDictionary = [
      "first name" : "Steven",
      "middle name" : "Paul",
      "last name" : "Jobs",
    ]
    
    if dict.writeToFile(path, atomically: true){
      
      let readDict:NSDictionary? = NSDictionary(contentsOfFile: path)
      if let dict = readDict{
        print("Read the dictionary back from disk = \(dict)")
      } else {
        print("Failed to read the dictionary back from disk")
      }
    } else {
      print("Failed to write the dictionary to disk")
    }
    
  }
  
  func example5(){
    let path = NSTemporaryDirectory() + "MyFile.txt"
    let chars = [CUnsignedChar(ascii: "a"), CUnsignedChar(ascii: "b")]
    let data = NSData(bytes: chars, length: 2)
    if data.writeToFile(path, atomically: true){
      print("Wrote the data")
      let readData = NSData(contentsOfFile: path)
      if readData!.isEqualToData(data){
        print("Read the same data")
      } else {
        print("Not the same data")
      }
    } else {
      print("Could not write the data")
    }
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    example5()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }
  
}

