//
//  WodResult+CoreDataProperties.swift
//  WODLife
//
//  Created by Martin  on 29/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WodResult {

    @NSManaged var name: String?
    @NSManaged var time: NSNumber?
    @NSManaged var rounds: NSNumber?
    @NSManaged var reps: NSNumber?
    @NSManaged var date: Date?

}
