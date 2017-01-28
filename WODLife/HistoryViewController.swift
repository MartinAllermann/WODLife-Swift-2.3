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
    var gradientLayer: CAGradientLayer!

    
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
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.cellBackground.bounds
        gradientLayer.colors = [colorPicker(colorName: workout.name, secondColor: true).cgColor as Any, colorPicker(colorName: workout.name, secondColor: false).cgColor as Any]
        cell.cellBackground.layer.insertSublayer(gradientLayer, at: 0)
        
        if (workout.rounds != 0) {
            
            cell.value.text = "\(workout.rounds!)" // Fix this
            cell.wodType.text = "Rounds"
            
        }
        if (workout.weight != 0) {
            
            cell.value.text = "\(workout.weight!)" // Fix this
            cell.wodType.text = "Weight"
            
        }
        if (workout.time != 0){
            
            cell.value.text = "\(secondsToHoursMinutesSeconds(workout.time!))"
            cell.wodType.text = "Time"
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
    
    func colorPicker(colorName: String?, secondColor: Bool) -> UIColor {
        
        var orange = UIColor()
        var blue = UIColor()
        var green = UIColor()
        
        if secondColor == false {
        
           blue = UIColor(red:0.23, green:0.64, blue:0.89, alpha:1.0)
            
           orange = UIColor(red:0.92, green:0.30, blue:0.36, alpha:1.0)
            
           green = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
            
        
        } else {
        
            blue = UIColor(red:0.45, green:0.64, blue:0.79, alpha:1.0)
            
            orange = UIColor(red:0.86, green:0.33, blue:0.33, alpha:1.0)
            
            green = UIColor(red:0.22, green:0.69, blue:0.54, alpha:1.0)
        
        }
        
        switch(colorName!){
            
        case "Amanda":
            return orange
        case "Angie":
            return orange
        case "Annie":
            return orange
        case "Barbara":
            return orange
        case "Candy":
            return orange
        case "Chelsea":
            return orange
        case "Cindy":
            return orange
        case "Diane":
            return orange
        case "Elizabeth":
            return orange
        case "Eva":
            return orange
        case "Fran":
            return orange
        case "Grace":
            return orange
        case "Helen":
            return orange
        case "Isabel":
            return orange
        case "Jackie":
            return orange
        case "Karen":
            return orange
        case "Kelly":
            return orange
        case "Linda":
            return orange
        case "Lynne":
            return orange
        case "Maggie":
            return orange
        case "Mary":
            return orange
        case "Nancy":
            return orange
        case "Nicole":
            return orange
        //Heros
        case "Arnie":
            return blue
        case "Adambrown":
            return blue
        case "Badger":
            return blue
        case "Blake":
            return blue
        case "Bradshaw":
            return blue
        case "Bulger":
            return blue
        case "Bull":
            return blue
        case "Cameron":
            return blue
        case "Coe":
            return blue
        case "Collin":
            return blue
        case "Danny":
            return blue
        case "Daniel":
            return blue
        case "Desforges":
            return blue
        case "DT":
            return blue
        case "Erin":
            return blue
        case "Forrest":
            return blue
        case "Gator":
            return blue
        case "Garrett":
            return blue
        case "Gaza":
            return blue
        case "Hammer":
            return blue
        case "Hansen":
            return blue
        case "Helton":
            return blue
        case "Holbrook":
            return blue
        case "Jack":
            return blue
        case "Jason":
            return blue
        case "JBO":
            return blue
        case "Jerry":
            return blue
        case "Josh":
            return blue
        case "Johnson":
            return blue
        case "Joshie":
            return blue
        case "JT":
            return blue
        case "Justin":
            return blue
        case "Klepto":
            return blue
        case "Luce":
            return blue
        case "Manion":
            return blue
        case "McGhee":
            return blue
        case "Mccluskey":
            return blue
        case "Michael":
            return blue
        case "Moore":
            return blue
        case "Morrison":
            return blue
        case "Mr. Joshua":
            return blue
        case "Murph":
            return blue
        case "Nate":
            return blue
        case "Nutts":
            return blue
        case "Paul":
            return blue
        case "Rahoi":
            return blue
        case "Randy":
            return blue
        case "Rankel":
            return blue
        case "Ricky":
            return blue
        case "RJ":
            return blue
        case "Roy":
            return blue
        case "Ryan":
            return blue
        case "Pheezy":
            return blue
        case "Pike":
            return blue
        case "Santiago":
            return blue
        case "Severin":
            return blue
        case "Small":
            return blue
        case "Stephen":
            return blue
        case "The Seven":
            return blue
        case "Thompson":
            return blue
        case "Tommy":
            return blue
        case "War Frank":
            return blue
        case "Weaver":
            return blue
        case "White":
            return blue
        case "Wilmot":
            return blue
        case "Wittman":
            return blue
        case "ZEUS":
            return blue
        case "Zimmerman":
            return blue
            
        default:
            return green
            
        }
    }
    
}
