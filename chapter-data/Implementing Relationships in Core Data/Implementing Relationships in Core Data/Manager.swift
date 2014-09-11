//
//  Manager.swift
//  Implementing Relationships in Core Data
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation
import CoreData

class Manager: NSManagedObject {

    @NSManaged var age: NSNumber
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var employees: NSSet

}
