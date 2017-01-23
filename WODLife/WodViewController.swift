//
//  WodViewController.swift
//  WODLife
//
//  Created by Martin on 29/12/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var wodCollectionOne = "GIRLS"
    var wodCollectionTwo = "HERO"
    var wodCollectionThree = "My WODs"
    var numberOfCustomWods = 0
    var createdNewWod = false
    let emptyLabel = UILabel()
    var segmentSelected: String?
    var wodsWithDataArray: [String] = []
    var girlWods = [Workout]()
    var heroWods = [Workout]()
    var filteredWorkouts = [Workout]()
    var filteredWods = [Wod]()
    var searchPredicate: NSPredicate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWodData()
    
        segmentSelected = wodCollectionOne // The first segmentSelected should be wodCollectionOne
        segmentedControl.setTitle(wodCollectionOne, forSegmentAt: 0)
        segmentedControl.setTitle(wodCollectionTwo, forSegmentAt: 1)
        segmentedControl.setTitle(wodCollectionThree, forSegmentAt: 2)
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        wodsWithDataArray.removeAll()
        getWod()
        
        if (numberOfCustomWods < (fetchedResultsController.sections?[0].numberOfObjects)!) {
            if  createdNewWod == true {
                 segmentedControl.selectedSegmentIndex = 2
                 segmentSelected = wodCollectionThree
 
                createdNewWod = false
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func createWodBtn(_ sender: Any) {
        performSegue(withIdentifier: "createNewWod", sender: sender)
        createdNewWod = true
        numberOfCustomWods = (fetchedResultsController.sections?[0].numberOfObjects)!
    }
    
    
    // MARK: - Table view data source
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            segmentSelected = wodCollectionOne
        }
        if(segmentedControl.selectedSegmentIndex == 1)
        {
            segmentSelected = wodCollectionTwo
        }
        if(segmentedControl.selectedSegmentIndex == 2)
        {
            segmentSelected = wodCollectionThree
        }
        
        self.tableView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if segmentSelected == wodCollectionOne {
            if searchBar.text?.isEmpty == false {
                return filteredWorkouts.count
            }
            return self.girlWods.count
        }
        
        if segmentSelected == wodCollectionTwo {
            if searchBar.text?.isEmpty == false {
                return filteredWorkouts.count
            }
            return self.heroWods.count
            
        }
        else {
            
            if (fetchedResultsController.sections?[0].numberOfObjects == 0){
            
                emptyLabel.text = "No WODs"
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                tableView.backgroundView = emptyLabel
                
                return (fetchedResultsController.sections?[0].numberOfObjects)!
                
                
            }
            else {
                
                emptyLabel.text = ""
                if searchBar.text?.isEmpty == false {
                    return filteredWods.count
                }
                return (fetchedResultsController.sections?[0].numberOfObjects)!
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WodTableViewCell
        
        cell.wodDescOne.isUserInteractionEnabled = false
        
        if segmentSelected == wodCollectionOne {
            
            var wod = girlWods[indexPath.row]
            
            if searchBar.text?.isEmpty == false {
                wod = filteredWorkouts[indexPath.row]
            }
            
            cell.wodName.text = wod.name.uppercased()
            cell.wodType.text = wod.typeDescription.uppercased()
            cell.wodDescOne.text = wod.description
            cell.wodDescOne.backgroundColor = colorPicker(colorName: wod.color)
            cell.backgroundColor = colorPicker(colorName: wod.color)
            
            if (wodsWithDataArray.contains(wod.name)) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
        }
        if segmentSelected == wodCollectionTwo {
            
            var wod = heroWods[indexPath.row]
            
            if searchBar.text?.isEmpty == false {
                wod = filteredWorkouts[indexPath.row]
            }
            
            cell.wodName.text = wod.name.uppercased()
            cell.wodType.text = wod.typeDescription.uppercased()
            cell.wodDescOne.text = wod.description
            cell.wodDescOne.backgroundColor = colorPicker(colorName: wod.color)
            cell.backgroundColor = colorPicker(colorName: wod.color)
            
            if (wodsWithDataArray.contains(wod.name)) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
        }
        if segmentSelected == wodCollectionThree {
            
            var wod = fetchedResultsController.object(at: indexPath) as! Wod
            
            if searchBar.text?.isEmpty == false {
                wod = filteredWods[indexPath.row]
            }
            
            cell.wodName.text = wod.name?.uppercased()
            cell.wodType.text = wod.type?.uppercased()
            cell.wodDescOne.text = wod.wodDescription
            cell.wodDescOne.backgroundColor = colorPicker(colorName: "green")
            cell.backgroundColor = colorPicker(colorName: "green")
            
            if (wodsWithDataArray.contains(wod.name!)) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
        }
        
        return cell
        
    }
    
    
    func getWodResults() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Wod")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
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
    
    func getWod() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                wodsWithDataArray.append(res.name!)
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWodDescription" {
        let vc = segue.destination as! WodDescriptionViewController
            self.searchBar.resignFirstResponder()
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if segmentSelected == wodCollectionOne {
                
                var wod = girlWods[(indexPath?.row)!]
                
                if searchBar.text?.isEmpty == false {
                    wod = filteredWorkouts[(indexPath?.row)!]
                }
                
                vc.wodName = wod.name
                vc.timeComponent = wod.typeDescription
                vc.wodDescription = wod.description
                vc.timeComponentType = wod.type
                vc.color = colorPicker(colorName: wod.color)
                
            }
            if segmentSelected == wodCollectionTwo {
                
                var wod = heroWods[(indexPath?.row)!]
                
                if searchBar.text?.isEmpty == false {
                    wod = filteredWorkouts[(indexPath?.row)!]
                }
                
                vc.wodName = wod.name
                vc.timeComponent = wod.typeDescription
                vc.wodDescription = wod.description
                vc.timeComponentType = wod.type
                vc.color = colorPicker(colorName: wod.color)
                
            }
            if segmentSelected == wodCollectionThree {
                
                var wod = fetchedResultsController.object(at: indexPath!) as! Wod
            
                if searchBar.text?.isEmpty == false {
                    wod = filteredWods[(indexPath?.row)!]
                }
                
                vc.wodName = wod.name
               
                vc.timeComponent = wod.type
                vc.wodDescription = wod.wodDescription!
                vc.timeComponentType = wod.type
                vc.color = colorPicker(colorName: "green")
                
            }
        
        
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if segmentSelected == wodCollectionThree {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let con: NSManagedObjectContext = appDel.managedObjectContext
            
            let idx = IndexPath(row: indexPath.row, section: 0)
            let workout = fetchedResultsController.object(at: idx) as! Wod
            con.delete(workout)
            
            do {
                try con.save()
            } catch {
                return
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if segmentSelected == wodCollectionOne {
           
            
            filteredWorkouts  = searchText.isEmpty ? girlWods : girlWods.filter({(dataString: Workout) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return dataString.description.range(of: searchText, options: .caseInsensitive) != nil || dataString.name.range(of: searchText, options: .caseInsensitive) != nil
                
            })
            
        }
        if segmentSelected == wodCollectionTwo {
            
            
            filteredWorkouts  = searchText.isEmpty ? heroWods : heroWods.filter({(dataString: Workout) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return dataString.description.range(of: searchText, options: .caseInsensitive) != nil || dataString.name.range(of: searchText, options: .caseInsensitive) != nil
                
            })
            
        }
        
        if segmentSelected == wodCollectionThree {

            if searchText.isEmpty == false {
            
                searchPredicate = NSPredicate(format: "name CONTAINS[c] %@ OR wodDescription CONTAINS[c] %@ ", searchText, searchText)
                filteredWods = (self.fetchedResultsController.fetchedObjects?.filter() {
                return self.searchPredicate!.evaluate(with: $0)
                } as! [Wod]?)!
                
            }

        }
        tableView.reloadData()
    }
    
    func colorPicker(colorName: String?) -> UIColor {
        
        switch(colorName!){
            
        case "blue":
            return UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
            
        case "purple":
            return UIColor(red:0.25, green:0.51, blue:0.84, alpha:1.0) // purple
            
        case "yellow":
            return UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // yellow
            
        case "orange":
            return UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
            
        case "green":
            return UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0) // green // #37ba99
            
        default:
            return UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // Orange
            
        }
    }
    
    func getWodData(){
    
        getWodResults()
        
        getWod()
        
        girlWods = [
            Workout(name:"Amanda", typeDescription:"9-7-5 reps for time", description:"Muscle-ups\nSnatches (135 lbs)", type: "For time", color: "orange"),
            Workout(name:"Angie", typeDescription:"For time", description:"100 pull-ups\n100 push-ups\n100 sit-ups\n100 squats", type: "For time", color: "orange"),
            Workout(name:"Annie", typeDescription:"50-40-30-20-10 reps for time", description:"Double-unders\nSit-ups", type: "For time", color: "orange"),
            Workout(name:"Barbara", typeDescription:"5 rounds for time", description:"20 pull-ups\n30 push-ups\n40 sit-ups\n50 squats", type: "For time", color: "orange"),
            Workout(name:"Candy", typeDescription:"5 rounds for time", description:"20 pull-ups\n40 push-ups\n60 squats", type: "For time", color: "orange"),
            Workout(name:"Chelsea", typeDescription:"Every minute on the minute for 30 min", description:"5 pull-ups\n10 push-ups\n15 squats", type: "EMOM", color: "orange"),
            Workout(name:"Cindy", typeDescription:"As many rounds as possible in 20 min", description:"5 pull-ups\n10 push-ups\n15 squats", type: "AMRAP", color: "orange"),
            Workout(name:"Diane", typeDescription:"21-15-9 reps for time", description:"Deadlifts (225 lbs)\nHandstand push-ups", type: "For time", color: "orange"),
            Workout(name:"Elizabeth", typeDescription:"21-15-9 reps for time", description:"Cleans (135 lbs)\nRing dips", type: "For time", color: "orange"),
            Workout(name:"Eva", typeDescription:"5 rounds for time", description:"Run 800 meters\n30 kettlebell swings\n30 pull-ups", type: "For time", color: "orange"),
            Workout(name:"Fran", typeDescription:"21-15-9 reps for time", description:"Thrusters (95 lbs)\nPull-ups", type: "For time", color: "orange"),
            Workout(name:"Grace", typeDescription:"30 reps for time", description:"Clean-and-Jerks (135 lbs)", type: "For time", color: "orange"),
            Workout(name:"Helen", typeDescription:"3 rounds for time", description:"Run 400 meters\n21 kettlebell swings\n12 pull-ups", type: "For time", color: "orange"),
            Workout(name:"Isabel", typeDescription:"30 reps for time", description:"Snatches (135 lbs)", type: "For time", color: "orange"),
            Workout(name:"Jackie", typeDescription:"For time", description:"Row 1,000 meters\n50 Thrusters (45 lbs)\n30 pull-ups", type: "For time", color: "orange"),
            Workout(name:"Karen", typeDescription:"For time", description:"150 wall-ball shots", type: "For time", color: "orange"),
            Workout(name:"Kelly", typeDescription:"5 rounds for time", description:"Run 400 meters\n30 box jumps\n30 wall-ball shots", type: "For time", color: "orange"),
            Workout(name:"Linda", typeDescription:"10-9-8-7-6-5-4-3-2-1 reps for time", description:"Deadlifts (1.5 BW)\nBench presses (BW)\nCleans (3/4 BW)", type: "For time", color: "orange"),
            Workout(name:"Lynne", typeDescription:"5 rounds for max reps", description:"Bench press (BW)\npull-ups", type: "For time", color: "orange"),
            Workout(name:"Maggie", typeDescription:"5 rounds for time", description:"20 handstand push-ups\n40 pull-ups\n60 one-legged squats", type: "For time", color: "orange"),
            Workout(name:"Mary", typeDescription:"As many rounds as possible in 20 min", description:"20 handstand push-ups\n40 pull-ups\n60 one-legged squats", type: "AMRAP", color: "orange"),
            Workout(name:"Nancy", typeDescription:"5 rounds for time", description:"Run 400 meters\n15 Overhead squats (95 lbs)", type: "For time", color: "orange"),
            Workout(name:"Nicole", typeDescription:"As many rounds as possible in 20 min", description:"Run 400 meters\nMax-reps pull-ups", type: "AMRAP", color: "orange"),
        ]
        
        heroWods  = [
            Workout(name:"Arnie", typeDescription:"For time", description:"21 Turkish get-ups, right arm\n50 kettlebell swings\n21 overhead squats, left arm\n50 kettlebell swings\n21 overhead squats, right arm\n50 kettlebell swings\n21 Turkish get-ups, left arm", type: "For time", color: "blue"),
            Workout(name:"Adambrown", typeDescription:"2 Rounds for time", description:"295-lb. deadlifts, 24 reps\n24 box jumps, 24-inch box\n24 wall-ball shots, 20-lb. ball\n195-lb. bench presses, 24 reps\n24 box jumps, 24-inch box\n24 wall-ball shots, 20-lb. ball\n145-lb. cleans, 24 reps", type: "For time", color: "blue"),
            Workout(name:"Badger", typeDescription:"3 Rounds for time", description:"30 squats cleans (95 lbs)\n30 pull-ups\nRun 800 meters", type: "For time", color: "blue"),
            Workout(name:"Blake", typeDescription:"4 rounds for time", description:"100-ft. walking lunge with 45-lb. plate held overhead\n30 box jumps, 24-inch box\n20 wall-ball shots, 20-lb. ball\n10 handstand push-ups", type: "For time", color: "blue"),
            Workout(name:"Bradshaw", typeDescription:"10 rounds for time", description:"3 handstand push-ups\n6 deadlifts (225 lbs)\n12 pull-ups\n24 double-unders", type: "For time", color: "blue"),
            Workout(name:"Bulger", typeDescription:"10 rounds for time", description:"Run 150 meters\n7 chest-to-bar pull-ups\n7 front squats (135 lbs)\n7 handstand push-ups", type: "For time", color: "blue"),
            Workout(name:"Bull", typeDescription:"2 Rounds for time", description:"200 double-unders\n50 overhead Squat\n50 pull-ups\nRun 1 mile", type: "For time", color: "blue"),
            Workout(name:"Cameron", typeDescription:"For time", description:"50 walking-lunge steps\n25 chest-to-bar pull-ups\n50 box jumps, 24-inch box\n25 triple-unders\n50 back extensions\n25 ring dips\n50 knees-to-elbows\n25 wall-ball\n50 sit-ups\n15-ft. rope climbs, 5 ascents", type: "For time", color: "blue"),
            Workout(name:"Coe", typeDescription:"10 rounds for time", description:"10 thrusters (95 lbs)\n10 ring push-ups", type: "For time", color: "blue"),
            Workout(name:"Collin", typeDescription:"6 rounds for time", description:"Carry sandbag 400 meters\n12 push presses\n12 box jumps\n12 sumo deadlift high pulls (95 lbs)", type: "For time", color: "blue"),
            Workout(name:"Danny", typeDescription:"As many rounds as possible in 20 min", description:"30 box jumps\n20 push presses (115 lbs)\n30 pull-ups", type: "AMRAP", color: "blue"),
            Workout(name:"Daniel", typeDescription:"For time", description:"50 pull-ups\n400-meter run\n95-lb. thrusters, 21 reps\n800-meter run\n95-lb. thrusters, 21 reps\n400-meter run\n50 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Desforges", typeDescription:"5 rounds for time", description:"12 deadlift (225 lbs)\n20 pull-ups\n12 clean and jerks (135 lbs)\n20 knees-to-elbows", type: "For time", color: "blue"),
            Workout(name:"Die han", typeDescription:"3 rounds for time", description:"Run 800 meters with barbell (45 lbs)\n3 Rope climbs\n12 Thrusters", type: "For time", color: "blue"),
            Workout(name:"DT", typeDescription:"5 Rounds For Time", description:"12 Deadlift\n9 Hang Power Clean\n6 Push Jerk", type: "For time", color: "blue"),
            Workout(name:"Erin", typeDescription:"5 rounds for time", description:"15 dumbbell split cleans (40 lbs)\n21 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Forrest", typeDescription:"3 rounds for time", description:"20 L-pull-ups\n30 toes-to-bars\n40 burpess\nRun 800 meters", type: "For time", color: "blue"),
            Workout(name:"Gator", typeDescription:"8 rounds for time", description:"5 front squats (185 lbs)\n26 ring push-ups", type: "For time", color: "blue"),
            Workout(name:"Garrett", typeDescription:"3 rounds for time", description:"75 squat\n25 ring handstand push-ups\n25 L-pull-ups", type: "For time", color: "blue"),
            Workout(name:"Gaza", typeDescription:"5 rounds for time", description:"35 kettlebell swings, 1.5 pood\n30 push-ups\n25 pull-ups\n20 box jumps, 30-inch box\n1-mile run", type: "For time", color: "blue"),
            Workout(name:"Hammer", typeDescription:"5 rounds for time", description:"5 power cleans (135 lbs)\n10 front squats (135 lbs)\n5 jerks (135 lbs)\n20 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Hansen", typeDescription:"5 rounds for time", description:"30 kettlebell swings\n30 burpess\n30 GHD sit-ups", type: "For time", color: "blue"),
            Workout(name:"Helton", typeDescription:"3 rounds for time", description:"Run 800 meters\n30 dumbbell squat cleans (50 lbs)\n30 burpees", type: "For time", color: "blue"),
            Workout(name:"Holbrook", typeDescription:"10 rounds for time", description:"5 thrusters (115 lbs)\n10 pull-ups\n100-meter sprint\nRest 1 minute", type: "For time", color: "blue"),
            Workout(name:"Jack", typeDescription:"As many rounds as possible in 20 min", description:"10 push presses (115 lbs)\n10 kettlebell swings\n10 box jumps", type: "AMRAP", color: "blue"),
            Workout(name:"Jason", typeDescription:"For time", description:"100 squats\n5 muscle-ups\n75 squats\n10 muscle-ups\n50 squats\n15 muscle-ups\n25 squats\n20 muscle-ups", type: "AMRAP", color: "blue"),
            Workout(name:"JBO", typeDescription:"As many rounds as possible in 28 min", description:"9 overhead squats (115 lbs)\n1 legless rope climb\n12 Bench presses (115 lbs)", type: "AMRAP", color: "blue"),
            Workout(name:"Jerry", typeDescription:"For time", description:"Run 1 mile\nRow 2.000 meters\nRun 1 mile", type: "For time", color: "blue"),
            Workout(name:"Josh", typeDescription:"For time", description:"95-lb. overhead squats, 21 reps\n42 pull-ups\n95-lb. overhead squats, 15 reps\n30 pull-ups\n95-lb. overhead squats, 9 reps\n18 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Johnson", typeDescription:"As many rounds as possible in 20 min", description:"9 deadlifts (245 lbs)\n8 muscle-ups\n9 squat cleans (155 lbs)", type: "AMRAP", color: "blue"),
            Workout(name:"Joshie", typeDescription:"3 Rounds For Time", description:"21 dumbbell snatches (40 lbs)\n21 L-pull-ups\n21 dumbbell snatches (40 lbs)\n21 L-pull-ups", type: "For time", color: "blue"),
            Workout(name:"JT", typeDescription:"21, 15, 9 reps for time", description:"Handstand push-ups\nRing dips\nPush-ups", type: "For time", color: "blue"),
            Workout(name:"Justin", typeDescription:"30-20-10 rounds", description:"Back squats (BW)\nBench press (BW)\nStrict pull-ups", type: "For time", color: "blue"),
            Workout(name:"Klepto", typeDescription:"4 rounds for time", description:"27 box jumps\n20 burpess\n11 squat cleans (145 lbs)", type: "For time", color: "blue"),
            Workout(name:"Luce", typeDescription:"3 Rounds For Time", description:"1k Run\n10 Muscle Ups\n100 Squats", type: "For time", color: "blue"),
            Workout(name:"Manion", typeDescription:"7 rounds for time", description:"Run 400 meters\n29 back squats (135 lbs)", type: "For time", color: "blue"),
            Workout(name:"McGhee", typeDescription:"As many rounds as possible in 30 min", description:"5 deadlifts (275 lbs)\n13 push-ups\n9 box jumps (24 inch)", type: "AMRAP", color: "blue"),
            Workout(name:"Mccluskey", typeDescription:"3 rounds for time", description:"9 muscle-ups\n15 burpee pull-ups\n21 pull ups\nRun 800 meters", type: "For time", color: "blue"),
            Workout(name:"Michael", typeDescription:"3 Rounds For Time", description:"Run 800 meters\n50 back extensions\n50 sit-ups", type: "For time", color: "blue"),
            Workout(name:"Moore", typeDescription:"As many rounds as possible in 20 min", description:"Rope climb\nRun 400 meters\nMax-reps handstand push-ups", type: "AMRAP", color: "blue"),
            Workout(name:"Morrison", typeDescription:"50-40-30-20-10 reps", description:"Wall-ball shots\nBox jumps\nKettlebell swings", type: "For time", color: "blue"),
            Workout(name:"Mr. Joshua", typeDescription:"5 Rounds For Time", description:"Run 400 meters\n30 GHD sit-ups\n15 Deadlifts (250 lbs)", type: "For time", color: "blue"),
            Workout(name:"Murph", typeDescription:"For Time", description:"1 mile Run\n100 pull-ups\n200 push-ups\n300 Squats\n1 mile Run", type: "For time", color: "blue"),
            Workout(name:"Nate", typeDescription:"As many rounds as possible in 20 min", description:"2 muscle-ups\n4 handstand push-ups\n8 kettlebell swings", type: "AMRAP", color: "blue"),
            Workout(name:"Nutts", typeDescription:"For time", description:"10 handstand push-ups\n250-lb. deadlifts, 15 reps\n25 box jumps, 30-inch box\n50 pull-ups\n100 wall-ball shots, 20-lb. ball\n200 double-unders\nRun 400 meters with a 45-lb. plate", type: "For time", color: "blue"),
            Workout(name:"Paul", typeDescription:"5 rounds for time", description:"50 double-unders\n35 knees-to-elbows\noverhead walk (20 yards)", type: "For time", color: "blue"),
            Workout(name:"Rahoi", typeDescription:"As many rounds as possible in 12 min", description:"12 box jumps\n6 thrusters (95 lbs)\n6 burpees", type: "AMRAP", color: "blue"),
            Workout(name:"Randy", typeDescription:"AMRAP", description:"75 power Snatch", type: "AMRAP", color: "blue"),
            Workout(name:"Rankel", typeDescription:"As many rounds as possible in 20 min", description:"6 deadlifts (225 lbs)\n7 burpee pull-ups\n10 kettlebell swings\nRun 200 meters", type: "AMRAP", color: "blue"),
            Workout(name:"Ricky", typeDescription:"As many rounds as possible in 20 min", description:"10 pull-ups\n5 dumbbell deadlifts (75 lbs)\n8 push press (135 lbs)", type: "AMRAP", color: "blue"),
            Workout(name:"RJ", typeDescription:"5 rounds for time", description:"Run 800 meters\n5 ropeclimbs\n50 push-ups", type: "For time", color: "blue"),
            Workout(name:"Roy", typeDescription:"5 rounds for time", description:"15 deadlifts (225 lbs)\n20 box jumps\n25 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Ryan", typeDescription:"For Time", description:"75 power snatches (75 lbs)", type: "For time", color: "blue"),
            Workout(name:"Pheezy", typeDescription:"3 rounds for Time", description:"165-lb. front squats, 5 reps\n18 pull-ups\n225-lb. deadlifts, 5 reps\n18 toes-to-bars\n165-lb. push jerks, 5 reps\n18 hand-release push-ups", type: "For time", color: "blue"),
            Workout(name:"Pike", typeDescription:"5 rounds for Time", description:"75-lb. thrusters, 20 reps\n10 strict ring dips\n20 push-ups\n10 strict handstand push-ups\n50-meter bear crawl", type: "For time", color: "blue"),
            Workout(name:"Santiago", typeDescription:"7 rounds for time", description:"18 dumbell squat cleans\n18 pull-ups\n10 power cleans (135 lbs)\n10 handstand push-ups", type: "For time", color: "blue"),
            Workout(name:"Severin", typeDescription:"For time", description:"50 strict pull-ups\n100 push-ups\nRun 5.000 meters", type: "For time", color: "blue"),
            Workout(name:"Small", typeDescription:"3 rounds for time", description:"Row 1.000 meters\n50 burpess\n50 box jumps\nRun 800 meters", type: "For time", color: "blue"),
            Workout(name:"Stephen", typeDescription:"30-25-20-15-10-5 reps for time", description:"GHD sit-ups\nBack extensions\nKnees-to-elbows\nStiff-legged deadlifts (95 lbs)", type: "For time", color: "blue"),
            Workout(name:"The Seven", typeDescription:"7 rounds for time", description:"7 handstand push-ups\n135-lb. thrusters, 7 reps\n7 knees-to-elbows\n245-lb. deadlifts, 7 reps\n7 burpees\n2-pood kettlebell swings, 7 reps\n7 pull-ups", type: "For time", color: "blue"),
            Workout(name:"Thompson", typeDescription:"10 rounds for time", description:"Rope climb\n29 back squat (95 lbs)\nFarmers carry 10 meters", type: "For time", color: "blue"),
            Workout(name:"Tommy", typeDescription:"For time", description:"115-lb. thrusters, 21 reps\n15-ft. rope climbs, 12 ascents\n115-lb. thrusters, 15 reps\n15-ft. rope climbs, 9 ascents\n115-lb. thrusters, 9 reps\n15-ft. rope climbs, 6 ascents", type: "For time", color: "blue"),
            Workout(name:"Tyler", typeDescription:"5 rounds for time", description:"7 muscle-ups\n21 sumo deadlift high pulls (95 lbs)", type: "For time", color: "blue"),
            Workout(name:"War Frank", typeDescription:"3 rounds for time", description:"25 muscle-ups\n100 squats\n35 GHD sit-ups", type: "For time", color: "blue"),
            Workout(name:"Weaver", typeDescription:"4 rounds for time", description:"10 L-pull-ups\n15 push-ups\n15 chest-to-bar pull-ups\n15 push-ups\n20 pull-ups\n15 push-ups", type: "For time", color: "blue"),
            Workout(name:"White", typeDescription:"5 rounds For Time", description:"3 rope climb\n10 toes to bar\n21 lunges\nRun 400 meters", type: "For time", color: "blue"),
            Workout(name:"Wilmot", typeDescription:"6 rounds for time", description:"50 squats\n25 ring dips", type: "For time", color: "blue"),
            Workout(name:"Wittman", typeDescription:"7 rounds for time", description:"15 kettlebell swings\n15 power cleans (95 lbs)\n15 box jumps", type: "For time", color: "blue"),
            Workout(name:"ZEUS", typeDescription:"3 rounds for time", description:"30 wall-ball shots, 20-lb. ball\n75-lb. sumo deadlift high pulls, 30 reps\n30 box jumps, 20-inch box\n75-lb. push presses, 30 reps\nRow 30 calories\n30 push-ups\nBody-weight back squats, 10 reps", type: "For time", color: "blue"),
            Workout(name:"Zimmerman", typeDescription:"As many rounds as possible in 25 min", description:"11 chest-to-bar pull-ups\n2 deadlifts (315 lbs)\n10 handstand push-ups", type: "AMRAP", color: "blue"),
        ]
    }
    
}
