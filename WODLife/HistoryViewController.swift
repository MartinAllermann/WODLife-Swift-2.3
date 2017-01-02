//
//  HistoryViewController.swift
//  WODLife
//
//  Created by Martin on 16/11/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var completedThisMonth: UILabel!
    @IBOutlet weak var completedLastMonth: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    let dateFormatter = DateFormatter()
    var completedWodsThisMonth: Int?
    var completedWodsLastMonth: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        getWodResult()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
         getCompletedWods()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let currSection = fetchedResultsController.sections?[section] {
            return currSection.name
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
        let workout = fetchedResultsController.object(at: indexPath) as! WodResult
        
        // Configure the cell...
        
        cell.title.text = workout.name?.uppercased()
        
        let convertedDate = dateFormatter.string(from: workout.date!)
        cell.subtitle.text = convertedDate
        
        if (workout.time == 0) {
        
         cell.value.text = "\(workout.rounds!)" // Fix this
            
        } else {
        
         cell.value.text = "\(secondsToHoursMinutesSeconds(workout.time!))"
            
        }
        
        
        return cell
    }
    
    func getWodResult() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: con, sectionNameKeyPath: "formattedDateDue" , cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let error = error as NSError
            print("Fetch error:\(error.localizedDescription)")
        }
    
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
    
    func getCompletedWods() {

        completedWodsThisMonth = 0
        completedWodsLastMonth = 0
        
        getCompletedWodsThisMonth()
        
    }
    
    
    func getCompletedWodsThisMonth() {
        
        var monthArray: [String] = []
    
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
            let dates = res.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-yyyy"
            monthArray.append(dateFormatter.string(from: dates! as Date))
                
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
        
        let currentDate = NSDate()
        let currentDateDateFormatter = DateFormatter()
        currentDateDateFormatter.dateFormat = "MM-yyyy"
        let currentMonth = currentDateDateFormatter.string(from: currentDate as Date)
    
        let previousDate = NSCalendar.current.date(byAdding: .month, value: -1, to: Date())
        let previousDateFormatter = DateFormatter()
        previousDateFormatter.dateFormat = "MM-yyyy"
        let previousMonth = currentDateDateFormatter.string(from: previousDate! as Date)
        
        completedWodsThisMonth = monthArray.filter{$0 == currentMonth}.count
        completedWodsLastMonth = monthArray.filter{$0 == previousMonth}.count
        
        switch completedWodsThisMonth! {
        case 0:
             completedThisMonth.text = "\(completedWodsThisMonth!)" + " WODs"
        case 1:
             completedThisMonth.text = "\(completedWodsThisMonth!)" + " WOD"
        default:
             completedThisMonth.text = "\(completedWodsThisMonth!)" + " WODs"
        }
        completedLastMonth.text = "\(completedWodsLastMonth!)" + " completed last month"
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica", size: 12)!
        header.textLabel?.textColor = UIColor.groupTableViewBackground
    }
}
