//
//  Wod+CoreDataProperties.swift
//  WODLife
//
//  Created by Martin on 28/12/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import Foundation
import CoreData


extension Wod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wod> {
        return NSFetchRequest<Wod>(entityName: "Wod");
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var color: String?
    @NSManaged public var type: String?
    @NSManaged public var typeDescription: String?
    @NSManaged public var wodDescription: String?

}
