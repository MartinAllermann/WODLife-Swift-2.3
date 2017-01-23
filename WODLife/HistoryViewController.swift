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
    var totalForTimeWods: Int?
    var currentMonth: String?
    var previousMonth: String?

    
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
        
        if (workout.rounds != 0) {
            
            cell.value.text = "\(workout.rounds!)" // Fix this
            cell.wodType.text = "Rounds"
            cell.cellBackground.backgroundColor = colorPicker(colorName: workout.name)
            
        }
        if (workout.weight != 0) {
            
            cell.value.text = "\(workout.weight!)" // Fix this
            cell.wodType.text = "Weight"
            cell.cellBackground.backgroundColor = colorPicker(colorName: workout.name)
            
        }
        if (workout.time != 0){
            
            cell.value.text = "\(secondsToHoursMinutesSeconds(workout.time!))"
            cell.wodType.text = "Time"
            cell.cellBackground.backgroundColor = colorPicker(colorName: workout.name)
        }
        cell.cellBackground?.layer.masksToBounds = true
        cell.cellBackground?.layer.cornerRadius = 10
        
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
        
        getMonths()
        getCompletedWodsThisMonth()
        
    }
    
    func getMonths(){
    
        let currentDate = NSDate()
        let currentDateDateFormatter = DateFormatter()
        currentDateDateFormatter.dateFormat = "MM-yyyy"
        currentMonth = currentDateDateFormatter.string(from: currentDate as Date)
        
        let previousDate = NSCalendar.current.date(byAdding: .month, value: -1, to: Date())
        let previousDateFormatter = DateFormatter()
        previousDateFormatter.dateFormat = "MM-yyyy"
        previousMonth = currentDateDateFormatter.string(from: previousDate! as Date)
    
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
    
    func colorPicker(colorName: String?) -> UIColor {
        
        switch(colorName!){
            
        case "Amanda":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Angie":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Annie":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Barbara":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Candy":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Chelsea":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Cindy":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Diane":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Elizabeth":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Eva":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Fran":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Grace":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Helen":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Isabel":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Jackie":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Karen":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Kelly":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Linda":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Lynne":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Maggie":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Mary":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Nancy":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        case "Nicole":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
        //Heros
        case "Arnie":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Adambrown":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Badger":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Blake":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Bradshaw":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Bulger":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Bull":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Cameron":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Coe":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Collin":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Danny":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Daniel":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Desforges":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "DT":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Erin":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Forrest":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Gator":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Garrett":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Gaza":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Hammer":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Hansen":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Helton":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Holbrook":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Jack":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Jason":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "JBO":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Jerry":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Josh":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Johnson":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Joshie":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "JT":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Justin":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Klepto":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Luce":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Manion":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "McGhee":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Mccluskey":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Michael":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Moore":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Morrison":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Mr. Joshua":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Murph":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Nate":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Nutts":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Paul":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Rahoi":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Randy":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Rankel":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Ricky":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "RJ":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Roy":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Ryan":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Pheezy":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Pike":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Santiago":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Severin":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Small":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Stephen":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "The Seven":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Thompson":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Tommy":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "War Frank":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Weaver":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "White":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Wilmot":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Wittman":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "ZEUS":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
        case "Zimmerman":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
  
        default:
            return UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0) // Green
            
        }
    }
    
}
