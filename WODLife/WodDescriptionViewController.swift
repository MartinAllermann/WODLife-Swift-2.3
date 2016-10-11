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
    var forTime: String?
    var AmrapTime: String?
    var AmrapRounds: String?
    var AmrapReps: String?
    var timeComponent: String?
    var firstExercise: String?
    var secondExercise: String?
    var thirdExercise: String?
    var fourthExercise: String?
    var timeComponentType: String?
    var wodLogTitle = ["Add Result"]
    var timerTitle = ["Timer"]
    var history: [String] = []
    var titles = [[String]]()
    var details = [[String]]()
    var dateArray: [String] = []
    var date: String?
    
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
        
        setWod()
        
        timeComponentCheck()
        backgroundColor.backgroundColor = color

        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reverse())
        details.append(dateArray.reverse())
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        titles.removeAll()
        details.removeAll()
        history.removeAll()
        dateArray.removeAll()
        
        timeComponentCheck()
        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reverse())
        details.append(dateArray.reverse())
        tableView.reloadData()
        
    }

    func setWod() {
        
        wodNameLabel.text = wodName
        timeComponentLabel.text = timeComponent
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
            
        }
        if segue.identifier == "AMRAP Timer"
        {
            
            let vc = segue.destinationViewController as! amrapTimeViewController
            vc.wodName = wodName
            
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure Cell
        
        switch (indexPath.section) {
            
        case 0:
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        case 1:
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        case 2:
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = details[0][indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            
        default:
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if timeComponentType?.rangeOfString("For") != nil  {
            
            print("For Time")
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("For Time", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("For Time Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.rangeOfString("AMRAP") != nil {
            
            print("AMRAP")
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("AMRAP", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("AMRAP Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.rangeOfString("EMON") != nil {
            
            print("EMON")
            if indexPath.section == 0 {
                self.performSegueWithIdentifier("For Time", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegueWithIdentifier("For Time Timer", sender: indexPath);
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
            
            getWodResult()
            
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
                history.append(forTime!)
                dateArray.append(date!)
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func getWodAmrapResult() {
        
        print("Get Previous Time")
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
                history.append(AmrapRounds!)
                dateArray.append(date!)
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    
}
