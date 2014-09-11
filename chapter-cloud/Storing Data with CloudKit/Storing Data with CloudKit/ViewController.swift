//
//  ViewController.swift
//  Storing Data with CloudKit
//
//  Created by vandad on 187//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
  
  let database = CKContainer.defaultContainer().privateCloudDatabase
  
  /* An enumeration of car types (Hatchback, Estate) */
  enum CarType: String{
    case Hatchback = "Hatchback"
    case Estate = "Estate"
    
    func zoneId() -> CKRecordZoneID{
      let zoneId = CKRecordZoneID(zoneName: self.toRaw(),
        ownerName: CKOwnerDefaultName)
      return zoneId
    }
    
    func zone() -> CKRecordZone{
      return CKRecordZone(zoneID: self.zoneId())
    }
    
  }
  
  /* Methods that allow us to create cars */
  func carWithType(type: CarType) -> CKRecord{
    let uuid = NSUUID().UUIDString
    let recordId = CKRecordID(recordName: uuid, zoneID: type.zoneId())
    let car = CKRecord(recordType: "MyCar", recordID: recordId)
    return car
  }
  
  func carWithType(type: CarType,
    maker: String,
    model: String,
    numberOfDoors: Int,
    year: Int) -> CKRecord{
      
      let record = carWithType(type)
      
      record.setValue(maker, forKey: "maker")
      record.setValue(model, forKey: "model")
      record.setValue(numberOfDoors, forKey: "numberOfDoors")
      record.setValue(year, forKey: "year")
      
      return record
      
  }
  
  func hatchbackCarWithMaker(maker: String,
    model: String,
    numberOfDoors: Int,
    year: Int) -> CKRecord{
      return carWithType(.Hatchback,
        maker: maker,
        model: model,
        numberOfDoors: numberOfDoors,
        year: year)
  }
  
  func estateCarWithMaker(maker: String,
    model: String,
    numberOfDoors: Int,
    year: Int) -> CKRecord{
      return carWithType(.Estate,
        maker: maker,
        model: model,
        numberOfDoors: numberOfDoors,
        year: year)
  }
  
  /* Methods that allow us to save the cars into the database */
  func saveCarClosure(record: CKRecord!, error: NSError!){
    
    /* Be careful, we might be on a non-UI thread */
    
    if error != nil{
      println("Failed to save the car. Error = \(error)")
    } else {
      println("Successfully saved the car with type \(record.recordType)")
    }
    
  }
  
  func saveCars(cars: [CKRecord]){
    for car in cars{
      database.saveRecord(car, completionHandler: saveCarClosure)
    }
  }
  
  func saveEstateCars(){
    
    let volvoV50 = estateCarWithMaker("Volvo",
      model: "V50",
      numberOfDoors: 5,
      year: 2016)
    
    let audiA6 = estateCarWithMaker("Audi",
      model: "A6",
      numberOfDoors: 5,
      year: 2018)
    
    let skodaOctavia = estateCarWithMaker("Skoda",
      model: "Octavia",
      numberOfDoors: 5,
      year: 2016)
    
    println("Saving estate cars...")
    saveCars([volvoV50, audiA6, skodaOctavia])
    
  }
  
  func saveHatchbackCars(){
    
    let fordFocus = hatchbackCarWithMaker("Ford",
      model: "Focus",
      numberOfDoors: 6,
      year: 2018)
    
    println("Saving hatchback cars...")
    saveCars([fordFocus])
    
  }
  
  func saveCarsForType(type: CarType){
    switch type{
    case .Hatchback:
      saveHatchbackCars()
    case .Estate:
      saveEstateCars()
    default:
      println("Unknown car state is given")
    }
  }
  
  func performOnMainThread(block: dispatch_block_t){
    dispatch_async(dispatch_get_main_queue(), block)
  }
  
  /* Use or save a zone */
  func useOrSaveZone(#zoneIsCreatedAlready: Bool, forCarType: CarType){
    
    if zoneIsCreatedAlready{
      println("Found the \(forCarType.toRaw()) zone. " +
        "It's been created already")
      saveCarsForType(forCarType)
    } else {
      database.saveRecordZone(forCarType.zone(),
        completionHandler: {[weak self]
          (zone: CKRecordZone!, error: NSError!) in
          if error != nil{
            println("Could not save the hatchback zone. Error = \(error)")
          } else {
            println("Successfully saved the hatchback zone")
            self!.performOnMainThread{self!.saveCarsForType(forCarType)}
          }
      })
    }
    
  }
  
  func isIcloudAvailable() -> Bool{
    if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
      return true
    } else {
      return false
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Begin the whole process */
    if isIcloudAvailable(){
      displayAlertWithTitle("iCloud", message: "iCloud is not available." +
        " Please sign into your iCloud account and restart this app")
      return
    }
    
    database.fetchAllRecordZonesWithCompletionHandler{[weak self]
      (zones:[AnyObject]!, error: NSError!) in
      
      if error != nil{
        println("Could not retrieve the zones")
      } else {
        
        var foundEstateZone = false
        var foundHatchbackZone = false
        
        for zone in zones as [CKRecordZone]{
          
          if zone.zoneID.zoneName == CarType.Hatchback.toRaw(){
            foundHatchbackZone = true
          }
          else if zone.zoneID.zoneName == CarType.Estate.toRaw(){
            foundEstateZone = true
          }
        }
        
        self!.useOrSaveZone(zoneIsCreatedAlready: foundEstateZone,
          forCarType: .Estate)
        
        self!.useOrSaveZone(zoneIsCreatedAlready: foundHatchbackZone,
          forCarType: .Hatchback)
        
      }
      
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

  
}