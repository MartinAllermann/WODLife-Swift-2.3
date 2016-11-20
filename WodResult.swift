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
            // Apple suggested locale-aware technique:
            // dateFormatter.dateStyle = .ShortStyle
            // dateFormatter.timeStyle = .NoStyle
            // ..or to stick to your original question:
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: self.date!)
        }
    }
    
    func getColor() -> UIColor {
        
        return UIColor(hue: 0, saturation: 0, brightness: 0.1, alpha: 1.0)
    }

}
