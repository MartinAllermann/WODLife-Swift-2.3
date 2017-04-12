//
//  HistoryModalViewController.swift
//  WODLife
//
//  Created by Martin on 12/04/2017.
//  Copyright © 2017 Martin. All rights reserved.
//

import UIKit

class HistoryModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
