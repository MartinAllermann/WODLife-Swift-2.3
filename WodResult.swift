//
//  WodResult.swift
//  WODLife
//
//  Created by Martin  on 29/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class WodResult: NSManagedObject {
    
    var formattedDateDue: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: self.date!)
        }
    }
    
}
