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
    var timeComponent: String?
    var wodDescription: String = ""
    var timeComponentType: String?
    var color: UIColor?
    var titles = [["Add Score"],["Timer"]]
    
    let dateFormatter = DateFormatter()
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var editMode: Bool = false
    var roundsToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    var timeToEdit: Int?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!
    @IBOutlet weak var wodDescriptionView: UITextView!
    
    @IBOutlet weak var backgroundColor: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setWodInstructions()
        getWodResults()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWodInstructions() {
        
            wodNameLabel.text = wodName?.uppercased()
            timeComponentLabel.text = timeComponent?.uppercased()
            wodDescriptionView.text = wodDescription
            wodDescriptionView.isUserInteractionEnabled = false
            wodDescriptionView.backgroundColor = color
            backgroundColor.backgroundColor = color
        
    }
    
    func getWodResults() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.predicate = NSPredicate(format: "name = %@", wodName!)
        request.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: con, sectionNameKeyPath: nil , cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let error = error as NSError
            print("Fetch error:\(error.localizedDescription)")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return titles.count
        default:
            return (fetchedResultsController.sections?[0].numberOfObjects)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WodDescriptionTableViewCell
        
        switch (indexPath.section) {
            
        case 0:
            
            cell.titleLabel.text = titles[indexPath.row][0]
            cell.detailLabel?.text = ""
            cell.detailLabel?.backgroundColor = UIColor.clear
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            if (indexPath.row == 0){
                cell.leftIcon.image = UIImage(named: "Compose")
            } else {
                cell.leftIcon.image = UIImage(named: "Stopwatch")
            }

        case 1:
        
            let idx = IndexPath(row: indexPath.row, section: 0)
            let workout = fetchedResultsController.object(at: idx) as! WodResult
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let convertedDate = dateFormatter.string(from: workout.date!)
            cell.titleLabel.text = convertedDate
            
            cell.detailLabel?.backgroundColor = color
            cell.detailLabel?.layer.masksToBounds = true
            cell.detailLabel?.layer.cornerRadius = 10
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.leftIcon.image = UIImage(named: "Calendar")
            
            if (workout.time == 0) {
                
                cell.detailLabel.text = "\(workout.rounds!)" // Fix this
                
            } else {
                
                cell.detailLabel.text = "\(secondsToHoursMinutesSeconds(workout.time!))"
                
            }
            
        default:
            
            cell.titleLabel.text = "test3"
        }
        
        return cell
    }
    
    
    func secondsToHoursMinutesSeconds (_ seconds : NSNumber) -> (String) {
        
        let min: Int?
        let sec: Int?
        
        min = (seconds.intValue % 3600) / 60
        sec = (seconds.intValue % 3600) % 60
        
        if sec! <= 9 {
            
            return "\(min!)" + ":" + "0\(sec!)"
        }
            
        else {
            
            return "\(min!)" + ":" + "\(sec!)"
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            if fetchedResultsController.fetchedObjects?.isEmpty == true {
                return nil
            } else {
                return "History"
            }
        default:
            return nil
        }
    }
    
    //
    // NAVIGATION
    //
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "For Time"
        {
            let vc = segue.destination as! WodResultTableViewController
            vc.wodName = wodName
            
            if editMode == true {
            vc.editMode = true
            vc.timeToEdit = timeToEdit
            vc.notesToEdit = notesToEdit
            vc.dateToEdit = dateToEdit
                
            }
            
        }
        if segue.identifier == "AMRAP"
        {
            
            let vc = segue.destination as! WodAMRAPResultsTableViewController
            vc.wodName = wodName
            
            if editMode == true {
                vc.editMode = true
                vc.roundsToEdit = roundsToEdit
                vc.notesToEdit = notesToEdit
                vc.dateToEdit = dateToEdit
            }
            
        }
        if segue.identifier == "For Time Timer"
        {
            
            let vc = segue.destination as! forTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.wodDescription = wodDescription

        }
        if segue.identifier == "AMRAP Timer"
        {
            
            let vc = segue.destination as! amrapTimeViewController
            vc.wodName = wodName
            vc.timeComponent = timeComponent
            vc.wodDescription = wodDescription
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            editMode = false
        
            if timeComponentType?.range(of: "For") != nil  {
                
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "For Time", sender: indexPath);
                } else if indexPath.row == 1 {
                    self.performSegue(withIdentifier: "For Time Timer", sender: indexPath);
                }
                
            }
            
            if timeComponentType?.range(of: "AMRAP") != nil {
                
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
                } else if indexPath.row == 1 {
                    self.performSegue(withIdentifier: "AMRAP Timer", sender: indexPath);
                }
                
            }
            
            if timeComponentType?.range(of: "EMON") != nil {
                
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
                } else if indexPath.row == 1 {
                    self.performSegue(withIdentifier: "AMRAP Timer", sender: indexPath);
                }
                
            }
        }
        
        if indexPath.section == 1 {
            
            let idx = IndexPath(row: indexPath.row, section: 0)
            let workout = fetchedResultsController.object(at: idx) as! WodResult
            
            editMode = true
            
            if timeComponentType?.range(of: "For") != nil  {
                timeToEdit = workout.time as Int?
                notesToEdit = workout.notes
                dateToEdit = workout.date
                self.performSegue(withIdentifier: "For Time", sender: indexPath);
            }
            if timeComponentType?.range(of: "AMRAP") != nil  {
                roundsToEdit = workout.rounds as Int?
                notesToEdit = workout.notes
                dateToEdit = workout.date
                self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
            }
            if timeComponentType?.range(of: "EMON") != nil  {
                roundsToEdit = workout.rounds as Int?
                notesToEdit = workout.notes
                dateToEdit = workout.date
                self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
            }
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section) {
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let con: NSManagedObjectContext = appDel.managedObjectContext
            
            let idx = IndexPath(row: indexPath.row, section: 0)
            let workout = fetchedResultsController.object(at: idx) as! WodResult
            con.delete(workout)
            
            do {
                try con.save()
            } catch {
                return
            }
        }
    }
    
}
