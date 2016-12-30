//
//  WodTableViewCell.swift
//  WODLife
//
//  Created by Martin on 29/12/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit

class WodTableViewCell: UITableViewCell, UITextViewDelegate{

    @IBOutlet weak var wodName: UILabel!

    @IBOutlet weak var wodType: UILabel!
    
    @IBOutlet weak var wodDescOne: UITextView!

    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var disclosureIndicator: UIImageView!
    
    
}


