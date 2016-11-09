//
//  WodDescriptionViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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
    var dateArray: [Date] = []
    var dateArrayReverse: [[Date]] = []
    var date: Date?
    let dateFormatter = DateFormatter()
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
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        setBackgroundColor()
        setWod()
        
        timeComponentCheck()
        
        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reversed())
        dateArrayReverse.append(dateArray.reversed())
        deleteHistoryReverse.append(deleteHistory.reversed())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        titles.removeAll()
        history.removeAll()
        dateArray.removeAll()
        dateArrayReverse.removeAll()
        deleteHistory.removeAll()
        deleteHistoryReverse.removeAll()
        
        timeComponentCheck()
        titles.append(wodLogTitle)
        titles.append(timerTitle)
        titles.append(history.reversed())
        dateArrayReverse.append(dateArray.reversed())
        deleteHistoryReverse.append(deleteHistory.reversed())
        tableView.reloadData()
        
    }
    
    func setBackgroundColor(){
        
        backgroundColor.backgroundColor = color
        
 
    }
    
    func setWod() {
        
        wodNameLabel.text = wodName?.uppercased()
        timeComponentLabel.text = timeComponent?.uppercased()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "For Time"
        {
            
            let vc = segue.destination as! WodResultTableViewController
            vc.wodName = wodName
            
        }
        if segue.identifier == "AMRAP"
        {
            
            let vc = segue.destination as! WodAMRAPResultsTableViewController
            vc.wodName = wodName
            
        }
        if segue.identifier == "For Time Timer"
        {
            
            let vc = segue.destination as! forTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.firstExercise = firstExercise
            vc.secondExercise = secondExercise
            vc.thirdExercise = thirdExercise
            vc.fourthExercise = fourthExercise
            
        }
        if segue.identifier == "AMRAP Timer"
        {
            
            let vc = segue.destination as! amrapTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.firstExercise = firstExercise
            vc.secondExercise = secondExercise
            vc.thirdExercise = thirdExercise
            vc.fourthExercise = fourthExercise
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WodDescriptionTableViewCell
        
        // Configure Cell
        
        switch (indexPath.section) {
            
        case 0:
            cell.titleLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.text = ""
            cell.detailLabel?.backgroundColor = UIColor.clear
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.leftIcon.image = UIImage(named: "Compose")
            
        case 1:
            cell.titleLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.text = ""
            cell.detailLabel?.backgroundColor = UIColor.clear
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.leftIcon.image = UIImage(named: "Stopwatch")
            
        case 2:
            
            cell.detailLabel?.text = titles[indexPath.section][indexPath.row]
            cell.detailLabel?.backgroundColor = color
            cell.detailLabel?.layer.masksToBounds = true
            cell.detailLabel?.layer.cornerRadius = 12
            
            let convertedDate = dateFormatter.string(from: dateArrayReverse[0][indexPath.row])
            cell.titleLabel?.text = convertedDate
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.leftIcon.image = UIImage(named: "Calendar")
            
            
        default:
            cell.titleLabel.text = titles[indexPath.section][indexPath.row]
            cell.leftIcon.image = UIImage(named: "Calendar")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if timeComponentType?.range(of: "For") != nil  {
            
            if indexPath.section == 0 {
                self.performSegue(withIdentifier: "For Time", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegue(withIdentifier: "For Time Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.range(of: "AMRAP") != nil {
            
            if indexPath.section == 0 {
                self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegue(withIdentifier: "AMRAP Timer", sender: indexPath);
            }
            
        }
        
        if timeComponentType?.range(of: "EMON") != nil {
            
            if indexPath.section == 0 {
                self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
            } else if indexPath.section == 1 {
                self.performSegue(withIdentifier: "AMRAP Timer", sender: indexPath);
            }
            
        }
        
    }
    
    func timeComponentCheck() {
        
        if timeComponentType?.range(of: "For") != nil {
            
            getWodResult()
            
        }
        
        if timeComponentType?.range(of: "AMRAP") != nil {
            
            getWodAmrapResult()
            
        }
        
        if timeComponentType?.range(of: "EMON") != nil {
            
            getWodAmrapResult()
            
        }
        
    }
    
    func getWodResult() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.predicate = NSPredicate(format: "name = %@", wodName!)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                forTime = res.time
                date = res.date as Date?
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
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.predicate = NSPredicate(format: "name = %@", wodName!)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                AmrapRounds = res.rounds
                date = res.date as Date?
                history.append("\(AmrapRounds!)")
                dateArray.append(date!)
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section) {
        case 2:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let con = appDel.managedObjectContext
            let coord = appDel.persistentStoreCoordinator
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
            
            if timeComponentType?.range(of: "For") != nil {
                let predicate = NSPredicate(format: "name == %@ && time == %@ && date == %@", wodName!, deleteHistoryReverse[0][indexPath.row], dateArrayReverse[0][indexPath.row] as CVarArg)
                fetchRequest.predicate = predicate
            }
            
            if timeComponentType?.range(of: "AMRAP") != nil {
                let predicate = NSPredicate(format: "name == %@ && rounds == %@ && date == %@", wodName!, titles[indexPath.section][indexPath.row], dateArrayReverse[0][indexPath.row] as CVarArg)
                fetchRequest.predicate = predicate
            }
            
            if timeComponentType?.range(of: "EMON") != nil {
                let predicate = NSPredicate(format: "name == %@ && rounds == %@ && date == %@", wodName!, titles[indexPath.section][indexPath.row], dateArrayReverse[0][indexPath.row] as CVarArg)
                fetchRequest.predicate = predicate
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try coord.execute(deleteRequest, with: con)
            } catch let error as NSError {
                debugPrint(error)
            }
            
            viewWillAppear(true)
        }
    }
    
    func secondsToHoursMinutesSeconds (_ seconds : NSNumber) -> (String) {
        
        let min: Int?
        let sec: Int?
        
        min = (seconds.intValue % 3600) / 60
        sec = (seconds.intValue % 3600) % 60
        
        if sec <= 9 {
            
            return "\(min!)" + ":" + "0\(sec!)"
        }
            
        else {
            
            return "\(min!)" + ":" + "\(sec!)"
            
        }
    }
    
    
}
