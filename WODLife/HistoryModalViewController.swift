//
//  HistoryModalViewController.swift
//  WODLife
//
//  Created by Martin on 12/04/2017.
//  Copyright © 2017 Martin. All rights reserved.
//

import UIKit

class HistoryModalViewController: UIViewController {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerValue: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerSubtitle: UILabel!
    @IBOutlet weak var headerType: UILabel!
    @IBOutlet weak var bodyview: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var footView: UIView!
    @IBOutlet weak var footerButton: UIButton!
    
    var wodName: String?
    var wodDate: String?
    var wodResult: String?
    var wodType: String?
    var wodNotes: String?
    var wodColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designModal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func designModal() {
        
    headerLabel.text = wodName
    headerSubtitle.text = wodDate
    headerType.text = wodType
    headerValue.text = wodResult
    bodyTextView.text = wodNotes
    headerView.backgroundColor = wodColor
    
    modalView.layer.masksToBounds = true
    modalView.layer.cornerRadius = 10
        
    }
    

}
