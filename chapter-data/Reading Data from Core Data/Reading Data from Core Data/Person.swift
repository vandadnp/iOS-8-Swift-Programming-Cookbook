//
//  Person.swift
//  Reading Data from Core Data
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(Person) class Person: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var age: NSNumber

}
