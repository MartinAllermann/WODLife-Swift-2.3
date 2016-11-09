//
//  WodAMRAPResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodAMRAPResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate{
    
   
    @IBOutlet weak var roundsTextField: UITextField!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    
    var wodName: String?
    var roundsFromTimer: Int?
    var newDate = Date()
    var timerUsed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wodNameLabel.text = wodName
        textFieldPlaceholder()
        roundsTextField.delegate = self
        
        if timerUsed == true {
        
            roundsTextField.text = "\(roundsFromTimer!)"
        
        }
        self.roundsTextField.becomeFirstResponder()
    }
    
    @IBAction func saveB(_ sender: AnyObject) {
        
        if roundsTextField.text!.isEmpty {
        roundsTextField.text = "0"
        }
        
        saveResult()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    func saveResult(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let ent = NSEntityDescription.entity(forEntityName: "WodResult", in: context)
        let Wod = WodResult(entity: ent!, insertInto: context)
        
        let currentDate = Date()
      
        Wod.name = wodName
        
        let roundsInt:NSNumber? = Int(roundsTextField.text!) as NSNumber?
        Wod.rounds = roundsInt!
        Wod.date = currentDate
 
        
        do {
            
            try context.save()
            dismissVC()
        } catch {
            return
        }
        
    }
    
    
    func dismissVC(){
        let controller = navigationController?.viewControllers[1] // it is at index 1. index start from 0, 1 .. N
        let _ = navigationController?.popToViewController(controller!, animated: true)
    }
    
    func textFieldPlaceholder(){
        
        roundsTextField.placeholder = "0"
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
