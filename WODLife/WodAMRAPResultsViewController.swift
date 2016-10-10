//
//  WodAMRAPResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodAMRAPResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
   
    @IBOutlet weak var roundsTextField: UITextField!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    
    var wodName: String?
    var roundsFromTimer: Int?
    var newDate = NSDate()
    var timerUsed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wodNameLabel.text = wodName
        textFieldPlaceholder()
        
        if timerUsed == true {
        
            roundsTextField.text = "\(roundsFromTimer!)"
        
        }
        
    }
    
    @IBAction func saveB(sender: AnyObject) {
        
        if roundsTextField.text!.isEmpty {
        roundsTextField.text = "0"
        }
        
        saveResult()
        
    }
    
    
    func saveResult(){
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let ent = NSEntityDescription.entityForName("WodResult", inManagedObjectContext: context)
        let Wod = WodResult(entity: ent!, insertIntoManagedObjectContext: context)
        
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
        
        let components = NSDateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        
        newDate = calendar.dateFromComponents(components)!
        let timeString = String(format:"%02d-%02d-%02d",components.day,components.month,components.year)
        print(timeString)
        
        Wod.name = wodName
        Wod.rounds = roundsTextField.text!
        Wod.date = timeString
 
        
        do {
            
            try context.save()
            dismissVC()
        } catch {
            return
        }
        
    }
    
    
    func dismissVC(){
        let controller = self.navigationController?.viewControllers[1] // it is at index 1. index start from 0, 1 .. N
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    func textFieldPlaceholder(){
        
        roundsTextField.placeholder = "0"
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
