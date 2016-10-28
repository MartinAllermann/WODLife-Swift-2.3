//
//  WodDescriptionViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodDescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    
    var wodName: String?
    var forTime: NSNumber?
    var AmrapTime: String?
    var AmrapRounds: NSNumber?
    var AmrapReps: NSNumber?
    var timeComponent: String?
    var firstExercise: String?
    var secondExercise: String?
    var thirdExercise: String?
    var fourthExercise: String?
    var timeComponentType: String?
    var wodLogTitle = ["Add Score"]
    var timerTitle = ["Timer"]
    var history: [String] = []
    var titles = [[String]]()
    var details = [[String]]()
    var dateArray: [NSDate] = []
    var dateArrayReverse: [[NSDate]] = []
    var date: NSDate?
    let dateFormatter = NSDateFormatter()
    var deleteHistory: [String] = []
    var deleteHistoryReverse: [[String]] = []
    
    var color: UIColor?
    var test: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!
    @IBOutlet weak var firstExerciseLabel: UILabel!
    @IBOutlet weak var secondExerciseLabel: UILabel!
    @IBOutlet weak var thirdExerciseLabel: UILabel!
    @IBOutlet weak var fourthExerciseLabel: UILabel!
    @IBOutlet weak var backgroundColor: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        setBackgroundColor()
        setWod()
        
        timeComponentCheck()
        
        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reverse())
        dateArrayReverse.append(dateArray.reverse())
        deleteHistoryReverse.append(deleteHistory.reverse())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        titles.removeAll()
        history.removeAll()
        dateArray.removeAll()
        dateArrayReverse.removeAll()
        deleteHistory.removeAll()
        deleteHistoryReverse.removeAll()
        
        timeComponentCheck()
        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reverse())
        dateArrayReverse.append(dateArray.reverse())
        deleteHistoryReverse.append(deleteHistory.reverse())
        tableView.reloadData()
        
    }
    
    func setBackgroundColor(){
        
        backgroundColor.backgroundColor = color
        
 
    }
    
    func setWod() {
        
        wodNameLabel.text = wodName?.uppercaseString
        timeComponentLabel.text = timeComponent?.uppercaseString
        firstExerciseLabel.text = firstExercise
        secondExerciseLabel.text = secondExercise
        thirdExerciseLabel.text = thirdExercise
        fourthExerciseLabel.text = fourthExercise

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "For Time"
        {
            
            let vc = segue.destinationViewController as! WodResultTableViewController
            vc.wodName = wodName
            
        }
        if segue.identifier == "AMRAP"
        {
            
            let vc = segue.destinationViewController as! WodAMRAPResultsTableViewController
            vc.wodName = wodName
            
        }
        if segue.identifier == "For Time Timer"
        {
            
            let vc = segue.destinationViewController as! forTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.firstExercise = firstExercise
            vc.secondExercise = secondExercise
            vc.thirdExercise = thirdExercise
            vc.fourthExercise = fourthExercise
            
        }
        if segue.identifier == "AMRAP Timer"
        {
            
            let vc = segue.destinationViewController as! amrapTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.firstExercise = firstExercise
            vc.secondExercise = secondExercise
            vc.thirdExercise = thirdExercise
            vc.fourthExercise = fourthExercise
            
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch(section){
            
        case 2:
            
            if (history.isEmpty == true) {
                
                return ""
                
            } else {
                
                return "HISTORY"
                
            }
            
        default:
            
            return ""
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WodDescriptionTableViewCell
        
        // Configure Cell
        
        switch (indexPath.section) {
            
        case 0:
            cell.titleLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.text = ""
            cell.detailLabel?.backgroundColor = UIColor.clearColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.leftIcon.image = UIImage(named: "Compose")
            
        case 1:
            cell.titleLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.text = ""
            cell.detailLabel?.backgroundColor = UIColor.clearColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.leftIcon.image = UIImage(named: "Stopwatch")
            
        case 2:
            
            cell.detailLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.backgroundColor = color
            cell.detailLabel?.layer.masksToBounds = true
            cell.detailLabel?.layer.cornerRadius = 12
            
            let convertedDate = dateFormatter.stringFromDate(dateArrayReverse[0][indexPath.row])
            cell.titleLabel?.text = convertedDate
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.leftIcon.image = UIImage(named: "Calendar")
            
            
        default:
            cell.titleLabel.text = titles[indexPath.section][indexPath.row]
            cell.leftIcon.image = UIImage(named: "Calendar")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if timeComponentType?.rangeOfString("For") != nil  {
            
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("For Time", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("For Time Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.rangeOfString("AMRAP") != nil {
            
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("AMRAP", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("AMRAP Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.rangeOfString("EMON") != nil {
            
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("AMRAP", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("AMRAP Timer", sender: indexPath);
            }
            
        }
        
    }
    
    func timeComponentCheck() {
        
        if timeComponentType?.rangeOfString("For") != nil {
            
            getWodResult()
            
        }
        
        if timeComponentType?.rangeOfString("AMRAP") != nil {
            
            getWodAmrapResult()
            
        }
        
        if timeComponentType?.rangeOfString("EMON") != nil {
            
            getWodAmrapResult()
            
        }
        
    }
    
    func getWodResult() {
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "WodResult")
        request.predicate = NSPredicate(format: "name = %@", wodName!)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.executeFetchRequest(request) as! [WodResult]
            for res in results {
                forTime = res.time
                date = res.date
                history.append(secondsToHoursMinutesSeconds(forTime!))
                dateArray.append(date!)
                deleteHistory.append("\(forTime!)")
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func getWodAmrapResult() {
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "WodResult")
        request.predicate = NSPredicate(format: "name = %@", wodName!)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.executeFetchRequest(request) as! [WodResult]
            for res in results {
                AmrapRounds = res.rounds
                date = res.date
                history.append("\(AmrapRounds!)")
                dateArray.append(date!)
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch (indexPath.section) {
        case 2:
            return true
        default:
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let con = appDel.managedObjectContext
            let coord = appDel.persistentStoreCoordinator
            
            let fetchRequest = NSFetchRequest(entityName: "WodResult")
            
            if timeComponentType?.rangeOfString("For") != nil {
                let predicate = NSPredicate(format: "name == %@ && time == %@ && date == %@", wodName!, deleteHistoryReverse[0][indexPath.row], dateArrayReverse[0][indexPath.row])
                fetchRequest.predicate = predicate
            }
            
            if timeComponentType?.rangeOfString("AMRAP") != nil {
                let predicate = NSPredicate(format: "name == %@ && rounds == %@ && date == %@", wodName!, titles[indexPath.section][indexPath.row], dateArrayReverse[0][indexPath.row])
                fetchRequest.predicate = predicate
            }
            
            if timeComponentType?.rangeOfString("EMON") != nil {
                let predicate = NSPredicate(format: "name == %@ && rounds == %@ && date == %@", wodName!, titles[indexPath.section][indexPath.row], dateArrayReverse[0][indexPath.row])
                fetchRequest.predicate = predicate
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try coord.executeRequest(deleteRequest, withContext: con)
            } catch let error as NSError {
                debugPrint(error)
            }
            
            viewWillAppear(true)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : NSNumber) -> (String) {
        
        let min: Int?
        let sec: Int?
        
        min = (seconds.integerValue % 3600) / 60
        sec = (seconds.integerValue % 3600) % 60
        
        if sec <= 9 {
            
            return "\(min!)" + ":" + "0\(sec!)"
        }
            
        else {
            
            return "\(min!)" + ":" + "\(sec!)"
            
        }
    }
    
    
}
