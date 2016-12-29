//
//  WodViewController.swift
//  WODLife
//
//  Created by Martin on 29/12/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var wodCollectionOne = "GIRLS"
    var wodCollectionTwo = "HERO"
    var wodCollectionThree = "My WODs"
    var segmentSelected: String?
    var wodsWithDataArray: [String] = []
    var theGirlsWodsCollection:[[String]] = [
        
        ["Amanda","9-7-5 reps for time","Muscle-ups\nSnatches (135 lbs)","For time","orange"],
        
        ["Angie","For time","100 pull-ups\n100 push-ups\n100 sit-ups\n100 squats","For time","blue"],
        
        ["Annie","50-40-30-20-10 reps for time","Double-unders\nSit-ups","For time","blue"],
        
        ["Barbara","5 rounds for time","20 pull-ups\n30 push-ups\n40 sit-ups\n50 squats","For time","blue"],
        
        ["Candy","5 rounds for time","20 pull-ups\n40 push-ups\n60 squats","For time","blue"],
        
        ["Chelsea","Every minute on the minute for 30 min","5 pull-ups\n10 push-ups\n15 squats","EMON","blue"],
        
        ["Cindy","As many rounds as possible in 20 min","5 pull-ups\n10 push-ups\n15 squats","AMRAP","blue"],
        
        ["Diane","21-15-9 reps for time","Deadlifts (225 lbs)\nHandstand push-ups","For time","orange"],
        
        ["Elizabeth","21-15-9 reps for time","Cleans (135 lbs)\nRing dips","For time","orange"],
        
        ["Eva","5 rounds for time","Run 800 meters\n30 kettlebell swings\n30 pull-ups","For time","purple"],
        
        ["Fran","21-15-9 reps for time","Thrusters (95 lbs)\nPull-ups","For time","orange"],
        
        ["Grace","30 reps for time","Clean-and-Jerks (135 lbs)","For time","yellow"],
        
        ["Helen","3 rounds for time","Run 400 meters\n21 kettlebell swings\n12 pull-ups","For time","purple"],
        
        ["Isabel","30 reps for time","Snatches (135 lbs)","For time","yellow"],
        
        ["Jackie","For time","Row 1,000 meters\n50 Thrusters (45 lbs)\n30 pull-ups","For time","orange"],
        
        ["Karen","For time","150 wall-ball shots","For time","purple"],
        
        ["Kelly","5 rounds for time","Run 400 meters\n30 box jumps\n30 wall-ball shots","For time","purple"],
        
        ["Linda","10-9-8-7-6-5-4-3-2-1 reps for time","Deadlifts (1.5 BW)\nBench presses (BW)\nCleans (3/4 BW)","For time","yellow"],
        
        ["Lynne","5 rounds for max reps","Bench press (BW)\npull-ups","For time","orange"],
        
        ["Maggie","5 rounds for time","20 handstand push-ups\n40 pull-ups\n60 one-legged squats","For time","blue"],
        
        ["Mary","As many rounds as possible in 20 min","5 handstand push-ups\n10 1-legged squats\n15 pull-ups","AMRAP","blue"],
        
        ["Nancy","5 rounds for time","Run 400 meters\n15 Overhead squats (95 lbs)","For time","purple"],
        
        ["Nicole","As many rounds as possible in 20 min","Run 400 meters\nMax-reps pull-ups","AMRAP","blue"],
        ]
    
    var heroWodsCollection:[[String]] = [
        
        ["Badger","3 Rounds for time","30 squats cleans (95 lbs)\n30 pull-ups\nRun 800 meters","For time"],
        
        ["Bradshaw","10 rounds for time","3 handstand push-ups\n6 deadlifts (225 lbs)\n12 pull-ups\n24 double-unders","For time"],
        
        ["Bulger","10 rounds for time","Run 150 meters\n7 chest-to-bar pull-ups\n7 front squats (135 lbs)\n7 handstand push-ups","For time"],
        
        ["Bull","2 Rounds for time","200 double-unders\n50 overhead Squat\n50 pull-ups\nRun 1 mile","For time"],
        
        ["Coe","10 rounds for time","10 thrusters (95 lbs)\n10 ring push-ups","For time"],
        
        ["Collin","6 rounds for time","Carry sandbag 400 meters\n12 push presses\n12 box jumps\n12 sumo deadlift high pulls (95 lbs)","For time"],
        
        ["Danny","As many rounds as possible in 20 min","30 box jumps\n20 push presses (115 lbs)\n30 pull-ups","AMRAP"],
        
        ["Desforges","5 rounds for time","12 deadlift (225 lbs)\n20 pull-ups\n12 clean and jerks (135 lbs)\n20 knees-to-elbows","For time"],
        
        ["Die han","3 rounds for time","Run 800 meters with barbell (45 lbs)\n3 Rope climbs\n12 Thrusters","For time"],
        
        ["DT","5 Rounds For Time","12 Deadlift\n9 Hang Power Clean\n6 Push Jerk","For time"],
        
        ["Erin","5 rounds for time","15 dumbbell split cleans (40 lbs)\n21 pull-ups","For time"],
        
        ["Forrest","3 rounds for time","20 L-pull-ups\n30 toes-to-bars\n40 burpess\nRun 800 meters","For time"],
        
        ["Gator","8 rounds for time","5 front squats (185 lbs)\n26 ring push-ups","For time"],
        
        ["Garrett","3 rounds for time","75 squat\n25 ring handstand push-ups\n25 L-pull-ups","For time"],
        
        ["Hammer","5 rounds for time","5 power cleans (135 lbs)\n10 front squats (135 lbs)\n5 jerks (135 lbs)\n20 pull-ups","For time"],
        
        ["Hansen","5 rounds for time","30 kettlebell swings\n30 burpess\n30 GHD sit-ups","For time"],
        
        ["Helton","3 rounds for time","Run 800 meters\n30 dumbbell squat cleans (50 lbs)\n30 burpees","For time"],
        
        ["Holbrook","10 rounds for time","5 thrusters (115 lbs)\n10 pull-ups\n100-meter sprint\nRest 1 minute","For time"],
        
        ["Jack","As many rounds as possible in 20 min","10 push presses (115 lbs)\n10 kettlebell swings\n10 box jumps","AMRAP"],
        
        ["JBO","As many rounds as possible in 28 min","9 overhead squats (115 lbs)\n1 legless rope climb\n12 Bench presses (115 lbs)","AMRAP"],
        
        ["Jerry","For time","Run 1 mile\nRow 2.000 meters\nRun 1 mile","For time"],
        
        ["JT","21, 15, 9 reps for time","Handstand push-ups\nRing dips\nPush-ups","For time"],
        
        ["Johnson","As many rounds as possible in 20 min","9 deadlifts (245 lbs)\n8 muscle-ups\n9 squat cleans (155 lbs)","AMRAP"],
        
        ["Joshie","3 Rounds For Time","21 dumbbell snatches (40 lbs)\n21 L-pull-ups\n21 dumbbell snatches (40 lbs)\n21 L-pull-ups","For time"],
        
        ["Justin","30-20-10 rounds","Back squats (BW)\nBench press (BW)\nStrict pull-ups","For time"],
        
        ["Klepto","4 rounds for time","27 box jumps\n20 burpess\n11 squat cleans (145 lbs)","For time"],
        
        ["Luce","3 Rounds For Time","1k Run\n10 Muscle Ups\n100 Squats","For time"],
        
        ["Manion","7 rounds for time","Run 400 meters\n29 back squats (135 lbs)","For time"],
        
        ["McGhee","As many rounds as possible in 30 min","5 deadlifts (275 lbs)\n13 push-ups\n9 box jumps (24 inch)","AMRAP"],
        
        ["Mccluskey","3 rounds for time","9 muscle-ups\n15 burpee pull-ups\n21 pull ups\nRun 800 meters","For time"],
        
        ["Michael","3 Rounds For Time","Run 800 meters\n50 back extensions\n50 sit-ups","For time"],
            
            ["Moore","As many rounds as possible in 20 min","Rope climb\nRun 400 meters\nMax-reps handstand push-ups","AMRAP"],
            
            ["Morrison","50-40-30-20-10 reps","Wall-ball shots\nBox jumps\nKettlebell swings","For time"],
            
            ["Mr. Joshua","5 Rounds For Time","Run 400 meters\n30 GHD sit-ups\n15 Deadlifts (250 lbs)","For time"],
            
            ["Murph","For Time","1 mile Run\n100 pull-ups\n200 push-ups\n300 Squats\n1 mile Run","For time"],
            
            ["Nate","As many rounds as possible in 20 min","2 muscle-ups\n4 handstand push-ups\n8 kettlebell swings","AMRAP"],
            
            ["Paul","5 rounds for time","50 double-unders\n35 knees-to-elbows\noverhead walk (20 yards)","For time"],
            
            ["Rahoi","As many rounds as possible in 12 min","12 box jumps\n6 thrusters (95 lbs)\n6 burpees","AMRAP"],
            
            ["Randy","AMRAP","75 power Snatch","AMRAP"],
            
            ["Rankel","As many rounds as possible in 20 min","6 deadlifts (225 lbs)\n7 burpee pull-ups\n10 kettlebell swings\nRun 200 meters","AMRAP"],
            
            ["Ricky","As many rounds as possible in 20 min","10 pull-ups\n5 dumbbell deadlifts (75 lbs)\n8 push press (135 lbs)","AMRAP"],
            
            ["RJ","5 rounds for time","Run 800 meters\n5 ropeclimbs\n50 push-ups","For time"],
            
            ["Roy","5 rounds for time","15 deadlifts (225 lbs)\n20 box jumps\n25 pull-ups","For time"],
            
            ["Ryan","For Time","75 power snatches (75 lbs)","For time"],
            
            ["Santiago","7 rounds for time","18 dumbell squat cleans\n18 pull-ups\n10 power cleans (135 lbs)\n10 handstand push-ups","For time"],
            
            ["Severin","For time","50 strict pull-ups\n100 push-ups\nRun 5.000 meters","For time"],
            
            ["Small","3 rounds for time","Row 1.000 meters\n50 burpess\n50 box jumps\nRun 800 meters","For time"],
            
            ["Stephen","30-25-20-15-10-5 reps for time","GHD sit-ups\nBack extensions\nKnees-to-elbows\nStiff-legged deadlifts (95 lbs)","For time"],
            
            ["Thompson","10 rounds for time","Rope climb\n29 back squat (95 lbs)\nFarmers carry 10 meters","For time"],
            
            ["Tyler","5 rounds for time","7 muscle-ups\n21 sumo deadlift high pulls (95 lbs)","For time"],
            
            ["War Frank","3 rounds for time","25 muscle-ups\n100 squats\n35 GHD sit-ups","For time"],
            
            ["White","5 rounds For Time","3 rope climb\n10 toes to bar\n21 lunges\nRun 400 meters","For time"],
            
            ["Wilmot","6 rounds for time","50 squats\n25 ring dips","For time"],
            
            ["Wittman","7 rounds for time","15 kettlebell swings\n15 power cleans (95 lbs)\n15 box jumps","For time"],
            
            ["Zimmerman","As many rounds as possible in 25 min","11 chest-to-bar pull-ups\n2 deadlifts (315 lbs)\n10 handstand push-ups","AMRAP"],
            
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentSelected = wodCollectionOne // The first segmentSelected should be wodCollectionOne
        getWodResults()
        segmentedControl.setTitle(wodCollectionOne, forSegmentAt: 0)
        segmentedControl.setTitle(wodCollectionTwo, forSegmentAt: 1)
        segmentedControl.setTitle(wodCollectionThree, forSegmentAt: 2)
        
        getWod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        wodsWithDataArray.removeAll()
        getWod()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        self.tableView.reloadData()
        
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
            return self.theGirlsWodsCollection.count
            
        }
        if segmentSelected == wodCollectionTwo {
            
            return self.heroWodsCollection.count
            
        } else {
            
            return (fetchedResultsController.sections?[0].numberOfObjects)!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WodTableViewCell
        
        cell.wodDescOne.isUserInteractionEnabled = false
        
        if segmentSelected == wodCollectionOne {
            
            let name = theGirlsWodsCollection[indexPath.row][0]
            cell.wodName.text = name.uppercased()
            let timeComponent = theGirlsWodsCollection[indexPath.row][1]
            cell.wodType.text = timeComponent.uppercased()
            cell.wodDescOne.text = theGirlsWodsCollection[indexPath.row][2]
            
            if (wodsWithDataArray.contains(name)) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
        }
        if segmentSelected == wodCollectionTwo {
            
            let name = heroWodsCollection[indexPath.row][0]
            cell.wodName.text = name.uppercased()
            let timeComponent = heroWodsCollection[indexPath.row][1]
            cell.wodType.text = timeComponent.uppercased()
            cell.wodDescOne.text = heroWodsCollection[indexPath.row][2]
            
            if (wodsWithDataArray.contains(name)) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
        }
        if segmentSelected == wodCollectionThree {
            
            let wod = fetchedResultsController.object(at: indexPath) as! Wod
            cell.wodName.text = wod.name
            cell.wodType.text = wod.typeDescription
            cell.wodDescOne.text = wod.wodDescription
            
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
            
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if segmentSelected == wodCollectionOne {
                
                vc.wodName = theGirlsWodsCollection[(indexPath?.row)!][0]
                vc.timeComponent = theGirlsWodsCollection[(indexPath?.row)!][1]
                vc.wodDescription = theGirlsWodsCollection[(indexPath?.row)!][2]
                vc.timeComponentType = theGirlsWodsCollection[(indexPath?.row)!][3]
                vc.color = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
                
            }
            if segmentSelected == wodCollectionTwo {
                
                vc.wodName = heroWodsCollection[(indexPath?.row)!][0]
                vc.timeComponent = heroWodsCollection[(indexPath?.row)!][1]
                vc.wodDescription = heroWodsCollection[(indexPath?.row)!][2]
                vc.timeComponentType = heroWodsCollection[(indexPath?.row)!][3]
                vc.color = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
                
            }
            if segmentSelected == wodCollectionThree {
                
                let wod = fetchedResultsController.object(at: indexPath!) as! Wod
                vc.wodName = wod.name
                vc.timeComponent = wod.typeDescription
                vc.wodDescription = wod.wodDescription!
                vc.timeComponentType = wod.type
                vc.color = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
                
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
    
    

}
