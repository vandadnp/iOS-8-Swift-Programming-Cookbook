//
//  Laptop.swift
//  Using Custom Data Types in Your Core Data Model
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Laptop) class Laptop: NSManagedObject {

    @NSManaged var model: String
    @NSManaged var color: UIColor

}
