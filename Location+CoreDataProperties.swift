//
//  Location+CoreDataProperties.swift
//  Bus_Napp
//
//  Created by Raven Anderson on 9/28/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var activated: Bool
    @NSManaged var distance: Double
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var song: String?

}
