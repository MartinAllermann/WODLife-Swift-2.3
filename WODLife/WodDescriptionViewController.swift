//
//  WodDescriptionViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodDescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate{
    
    var wodName: String?
    var wodId: String?
    var timeComponent: String?
    var wodDescription: String = ""
    var timeComponentType: String?
    var color: UIColor?
    var secondColor: UIColor?
    var titles = [["Add Score"],["Timer"]]
    var videoUrlString: String?
    var content: String?
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoView: UIWebView!
    
    let dateFormatter = DateFormatter()
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var editMode: Bool = false
    var roundsToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    var timeToEdit: Int?
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!
    @IBOutlet weak var wodDescriptionView: UITextView!
    @IBOutlet weak var backgroundColor: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWodInstructions()
        getWodResults()
        styleVideoView()
        getVideoUrl()
 
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 50 {
            showNavigation()
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.11, green:0.12, blue:0.15, alpha:1.0) //
        }
        else {
            hideNavigation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigation()
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showNavigation()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWodInstructions() {
        
            wodNameLabel.text = wodName?.uppercased()
            timeComponentLabel.text = timeComponent?.uppercased()
            wodDescriptionView.text = wodDescription
            wodDescriptionView.isEditable = false
            wodDescriptionView.backgroundColor = UIColor.clear
        
        let contentSize = wodDescriptionView.sizeThatFits(wodDescriptionView.bounds.size)
    
        var frame = wodDescriptionView.frame
        frame.size.height = contentSize.height + 175
        wodDescriptionView.frame = frame
        
        var frame2 = backgroundColor.frame
        frame2.size.height = contentSize.height + 225
        
        backgroundColor.frame = frame2
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundColor.bounds
        gradientLayer.colors = [secondColor?.cgColor as Any, color?.cgColor as Any]
        self.backgroundColor.layer.insertSublayer(gradientLayer, at: 0)
        
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
        case 1:
            return (fetchedResultsController.sections?[0].numberOfObjects)!
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
            
            if (workout.rounds != 0) {
                
                cell.detailLabel.text = "\(workout.rounds!)" // Fix this
                
            }
            if (workout.weight != 0) {
                
                cell.detailLabel.text = "\(workout.weight!)" // Fix this
                
            }
            if (workout.time != 0){
                
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
            vc.wodType = timeComponentType
            
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
            vc.wodType = timeComponentType
            vc.wodDescription = wodDescription
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            editMode = false
        
            if timeComponentType?.range(of: "For time") != nil || timeComponentType?.range(of: "For Time") != nil  {
                
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "For Time", sender: indexPath);
                } else if indexPath.row == 1 {
                    self.performSegue(withIdentifier: "For Time Timer", sender: indexPath);
                }
                
            }
            
            if timeComponentType?.range(of: "AMRAP") != nil  || timeComponentType?.range(of: "EMOM") != nil  {
                
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
                } else if indexPath.row == 1 {
                    self.performSegue(withIdentifier: "AMRAP Timer", sender: indexPath);
                }
                
            }
            
            if timeComponentType?.range(of: "For load") != nil {
                
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
            
            if timeComponentType?.range(of: "For time") != nil || timeComponentType?.range(of: "For Time") != nil  {
                timeToEdit = workout.time as Int?
                notesToEdit = workout.notes
                dateToEdit = workout.date
                self.performSegue(withIdentifier: "For Time", sender: indexPath);
            }
            if timeComponentType?.range(of: "AMRAP") != nil  || timeComponentType?.range(of: "EMOM") != nil  {
                roundsToEdit = workout.rounds as Int?
                notesToEdit = workout.notes
                dateToEdit = workout.date
                self.performSegue(withIdentifier: "AMRAP", sender: indexPath);
            }
            if timeComponentType?.range(of: "For load") != nil  {
                roundsToEdit = workout.weight as Int?
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        header.textLabel?.textColor = UIColor.white
    }
    
    func hideNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func showNavigation(){

        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.17, green:0.18, blue:0.20, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
        

    }
    
    func getVideoUrl() {
        
        if wodId == "0" {
            print("No Post ID")
        } else {
            
            let url = URL(string: "http://34.206.174.67/wp-json/wp/v2/posts/" + wodId!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("ERROR")
                } else {
                    
                    if let myContent = data {
                        
                        do {
                            //Array
                            let myJson = try JSONSerialization.jsonObject(with: myContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            if let content = myJson["content"] as? NSDictionary {
                                if let rentered = content["rendered"] {
                                    self.videoUrlString = rentered as? String
                                    self.loadVideo()
                                }
                            }
                        }
                        catch {
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func loadVideo() {
        
        if videoUrlString == nil || (videoUrlString?.contains("No video"))!{
            print("No connection or video")
        } else {
            
            print("show video")
            DispatchQueue.global(qos: .background).async {
                // Background Thread
                let removeLastTag = self.videoUrlString?.replacingOccurrences(of: "</p>", with: "", options: .regularExpression)
                let removeFirstTag = removeLastTag?.replacingOccurrences(of: "<p>", with: "", options: .regularExpression)
                let cleanURL = removeFirstTag?.replacingOccurrences(of: "\n", with: "", options: .regularExpression)
                self.content = "https://" + cleanURL!
                
                let url = URL(string: self.content!)
                self.videoView.loadRequest(URLRequest(url: url!))
                
                DispatchQueue.main.async {
                    // Run UI Updates
                    self.videoLabel.isHidden = false
                    self.videoView.isHidden = false
                }
            }
        }
    }
    
    func styleVideoView(){
    videoView.layer.cornerRadius = 10
    videoView.layer.masksToBounds = true
        videoLabel.isHidden = true
        videoView.isHidden = true
    }
    
    
    
}
