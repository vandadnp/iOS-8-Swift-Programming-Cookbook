//
//  AppDelegate.swift
//  Jumping Right Into Swift
//
//  Created by Vandad Nahavandipoor on 8/8/14.
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

//enum CarClassification: String{
//  case Estate = "Estate"
//  case Hatchback = "Hatchback"
//  case Saloon = "Saloon"
//}
//
//struct Car{
//  let classification: CarClassification
//  let year: Int
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func classifyCar(car: Car){
//    switch car.classification{
//    case .Estate where car.year >= 2013:
//      print("This is a good and usable estate car")
//    case .Hatchback where car.year >= 2010:
//      print("This is an okay hatchback car")
//    default:
//      print("Unhandled case")
//    }
//  }
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      let oldEstate = Car(classification: .Estate, year: 1980)
//      let estate = Car(classification: .Estate, year: 2010)
//      let newEstate = Car(classification: .Estate, year: 2015)
//      let hatchback = Car(classification: .Hatchback, year: 2013)
//      let newSaloon = Car(classification: .Saloon, year: 2015)
//      
//      classifyCar(oldEstate)  /* Will go to the default case */
//      classifyCar(estate)     /* Will go to the default case */
//      classifyCar(newEstate)  /* Will be picked up in the function */
//      classifyCar(hatchback)  /* Will be picked up in the function */
//      classifyCar(newSaloon)  /* Will go to the default case */
//      
//      return true
//  }
//  
//}
//
//enum CarClassification: String{
//  case Estate = "Estate"
//  case Hatchback = "Hatchback"
//  case Saloon = "Saloon"
//}
//
//struct Car{
//  let classification: CarClassification
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      if let classification = CarClassification(rawValue: "Estate"){
//        let volvoV50 = Car(classification: classification)
//      }
//      
//      return true
//  }
//  
//}
//
//class Person{
//  var age: Int
//  var fullName: String
//  init(fullName: String, age: Int){
//    self.fullName = fullName
//    self.age = age
//  }
//}
//
//postfix func ++ (inout person: Person) -> Person{
//  let newPerson = Person(fullName: person.fullName, age: person.age)
//  person.age++
//  return newPerson
//}
//
//prefix func ++ (inout person: Person) -> Person{
//  person.age++
//  let newPerson = Person(fullName: person.fullName, age: person.age)
//  return newPerson
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      var vandad = Person(fullName: "Vandad Nahavandipoor", age: 29)
//      var sameAgeVandad = vandad++
//      /*
//        vandad.age = 30
//        sameAgeVandad.age = 29
//      */
//      
//      let olderVandad = ++sameAgeVandad
//      
//      /* 
//        vandad.age = 30
//        sameAgeVandad.age = 30
//        olderVandad.age = 30
//      */
//      
//      return true
//  }
//  
//}
//
//struct Person{
//  var (firstName, lastName) = ("", "")
//  init (firstName: String, lastName: String){
//    self.firstName = firstName
//    self.lastName = lastName
//  }
//}
//
//func == (left: Person, right: Person) -> Bool{
//  if left.firstName == right.firstName &&
//    left.lastName == right.lastName{
//      return true
//  }
//  return false
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      let andy = Person(firstName: "Andy", lastName: "Oram")
//      let someoneElse = Person(firstName: "Andy", lastName: "Oram")
//      
//      if andy == someoneElse{
//        /* This will be printed */
//        print("They are the same")
//      } else {
//        /* We won't get here in this case */
//        print("They are not the same")
//      }
//      
//      return true
//  }
//  
//}
//
//typealias byte = UInt8
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      /* Bitwise OR operator */
//      let byte3 = 0b01010101 | 0b10101010 /* = 0b11111111 */
//      
//      /* plus operator */
//      let plus = 10 + 20 /* = 30 */
//      
//      /* minus operator */
//      let minus = 20 - 10 /* = 10 */
//      
//      /* multiplication operator */
//      let multiplied = 10 * 20 /* = 200 */
//      
//      /* division operator */
//      let division = 10.0 / 3.0 /* = 3.33333333333333 */
//      
//      return true
//  }
//  
//}
//
//class Person{
//  var (firstName, lastName) = ("", "")
//  init (firstName: String, lastName: String){
//    self.firstName = firstName
//    self.lastName = lastName
//  }
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//  
//  var window: UIWindow?
//  
//  func changeFirstNameOf(person: Person, to: String){
//    person.firstName = to
//  }
//  
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      var vandad = Person(firstName: "Vandad", lastName: "Nahavandipoor")
//      changeFirstNameOf(vandad, to: "VANDAD")
//      /* vandad.firstName is now VANDAD */
//      
//      return true
//  }
//  
//}
//
//struct Person{
//  var firstName, lastName: String
//  
//  mutating func setFirstNameTo(firstName: String){
//    self.firstName = firstName
//  }
//  
//}
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//                            
//  var window: UIWindow?
//  
//  func changeFirstNameOf(var person: Person, to: String){
//    person.setFirstNameTo(to)
//    /* person.firstName is VANDAD now and only in this function */
//  }
//
//  func application(application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//      
//      let vandad = Person(firstName: "Vandad", lastName: "Nahavandipoor")
//      changeFirstNameOf(vandad, to: "VANDAD")
//      /* vandad.firstName is still Vandad */
//      print(vandad.firstName)
//      
//    return true
//  }
//
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      let integerValue = 10
      let stringValue = "Swift"
      let doubleValue = 10.0
      let integerFromDouble = 10.7 as Int
      
      print(integerValue, stringValue, doubleValue, integerFromDouble)
      /* The value of this variable is 10 
      since the compiler truncated the value to an integer*/


      var myString = "Swi"
      myString += "ft"
    /* myString is now "Swift" */
    
      let allStringsConst = ["Swift", "Objective-C"]
      print(allStringsConst)
    
      var allStrings = [String]()
      allStrings.append("Swift")
      allStrings.append("Objective-C")
      /* Our array is now ["Swift", "Objective-C"] */
    

      var myStrings = [String]()
      myStrings.append("Swift")
      myStrings.append("Objective-C")
      
      print(myStrings[0]) /* Prints out "Swift" */
      
      myStrings.insert("C++", atIndex: 0)
      
      print(myStrings[0]) /* Prints out "C++" */
      
      let allFullNames = [
        "Vandad"  : "Nahavandipoor",
        "Andy"    : "Oram",
        "Molly"   : "Lindstedt"
      ]
      
      print(allFullNames["Vandad"]) /* Prints out "Nahavandipoor" */
    
    
      var myFullNames = [
        "Vandad"  : "Nahavandipoor",
        "Andy"    : "Oram",
        "Molly"   : "Lindstedt"
      ]
      
      myFullNames["Rachel"] = "Roumeliotis"
      
      let personInformation = [
        "numberOfChildren"  : 2,
        "age"               : 32,
        "name"              : "Random person",
        "job"               : "Something cool",
        ] as [String : AnyObject]
      
      print(personInformation)
      
    return true
  }

}

