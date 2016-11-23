//
//  WodsCollectionViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodsCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var segmentedControlBar: UISegmentedControl!
    
    var wodCollectionOne = "GIRLS"
    var wodCollectionTwo = "HERO"
    var segmentSelected: String?
    var wodsWithDataArray: [String] = []
    var theGirlsWodsCollection:[[String]] = [
        
        ["Amanda","9-7-5 reps for time","Muscle-ups","Snatches (135 lbs)","","","For time","orange"],
        
        ["Angie","For time","100 pull-ups","100 push-ups","100 sit-ups","100 squats","For time","blue"],
        
        ["Annie","50-40-30-20-10 reps for time","Double-unders","Sit-ups","","","For time","blue"],
        
        ["Barbara","5 rounds for time","20 pull-ups","30 push-ups","40 sit-ups","50 squats","For time","blue"],
        
        ["Candy","5 rounds for time","20 pull-ups","40 push-ups","60 squats","","For time","blue"],
        
        ["Chelsea","Every minute on the minute for 30 min","5 pull-ups","10 push-ups","15 squats","","EMON","blue"],
        
        ["Cindy","As many rounds as possible in 20 min","5 pull-ups","10 push-ups","15 squats","","AMRAP","blue"],
        
        ["Diane","21-15-9 reps for time","Deadlifts (225 lbs)","Handstand push-ups","","","For time","orange"],
        
        ["Elizabeth","21-15-9 reps for time","Cleans (135 lbs)","Ring dips","","","For time","orange"],
        
        ["Eva","5 rounds for time","Run 800 meters","30 kettlebell swings","30 pull-ups","","For time","purple"],
        
        ["Fran","21-15-9 reps for time","Thrusters (95 lbs)","Pull-ups","","","For time","orange"],
        
        ["Grace","30 reps for time","Clean-and-Jerks (135 lbs)","","","","For time","yellow"],
        
        ["Helen","3 rounds for time","Run 400 meters","21 kettlebell swings","12 pull-ups","","For time","purple"],
        
        ["Isabel","30 reps for time","Snatches (135 lbs)","","","","For time","yellow"],
        
        ["Jackie","For time","Row 1,000 meters","50 Thrusters (45 lbs)","30 pull-ups","","For time","orange"],
        
        ["Karen","For time","150 wall-ball shots","","","","For time","purple"],
        
        ["Kelly","5 rounds for time","Run 400 meters","30 box jumps","30 wall-ball shots","","For time","purple"],
        
        ["Linda","10-9-8-7-6-5-4-3-2-1 reps for time","Deadlifts (1.5 BW)","Bench presses (BW)","Cleans (3/4 BW)","","For time","yellow"],
        
        ["Lynne","5 rounds for max reps","Bench press (BW)","pull-ups","","","For time","orange"],
        
        ["Maggie","5 rounds for time","20 handstand push-ups","40 pull-ups","60 one-legged squats","","For time","blue"],
        
        ["Mary","As many rounds as possible in 20 min","5 handstand push-ups","10 1-legged squats","15 pull-ups","","AMRAP","blue"],
        
        ["Nancy","5 rounds for time","Run 400 meters","15 Overhead squats (95 lbs)","","","For time","purple"],
    
        ["Nicole","As many rounds as possible in 20 min","Run 400 meters","Max-reps pull-ups","","","AMRAP","blue"],
        ]
    
    var heroWodsCollection:[[String]] = [
        
        ["Badger","3 Rounds for time","30 squats cleans (95 lbs)","30 pull-ups","Run 800 meters","","For time"],
        
        ["Bradshaw","10 rounds for time","3 handstand push-ups","6 deadlifts (225 lbs)","12 pull-ups","24 double-unders","For time"],
        
        ["Bulger","10 rounds for time","Run 150 meters","7 chest-to-bar pull-ups","7 front squats (135 lbs)","7 handstand push-ups","For time"],
        
        ["Bull","2 Rounds for time","200 double-unders","50 overhead Squat","50 pull-ups","Run 1 mile","For time"],
        
        ["Coe","10 rounds for time","10 thrusters (95 lbs)","10 ring push-ups","","","For time"],
        
        ["Collin","6 rounds for time","Carry sandbag 400 meters","12 push presses","12 box jumps","12 sumo deadlift high pulls (95 lbs)","For time"],
        
        ["Danny","As many rounds as possible in 20 min","30 box jumps","20 push presses (115 lbs)","30 pull-ups","","AMRAP"],
        
        ["Desforges","5 rounds for time","12 deadlift (225 lbs)","20 pull-ups","12 clean and jerks (135 lbs)","20 knees-to-elbows","For time"],
        
        ["Die han","3 rounds for time","Run 800 meters with barbell (45 lbs)","3 Rope climbs","12 Thrusters","","For time"],
        
        ["DT","5 Rounds For Time","12 Deadlift","9 Hang Power Clean","6 Push Jerk","","For time"],
        
        ["Erin","5 rounds for time","15 dumbbell split cleans (40 lbs)","21 pull-ups","","","For time"],
        
        ["Forrest","3 rounds for time","20 L-pull-ups","30 toes-to-bars","40 burpess","Run 800 meters","For time"],
        
        ["Gator","8 rounds for time","5 front squats (185 lbs)","26 ring push-ups","","","For time"],
        
        ["Garrett","3 rounds for time","75 squat","25 ring handstand push-ups","25 L-pull-ups","","For time"],
        
        ["Hammer","5 rounds for time","5 power cleans (135 lbs)","10 front squats (135 lbs)","5 jerks (135 lbs)","20 pull-ups","For time"],
        
        ["Hansen","5 rounds for time","30 kettlebell swings","30 burpess","30 GHD sit-ups","","For time"],
        
        ["Helton","3 rounds for time","Run 800 meters","30 dumbbell squat cleans (50 lbs)","30 burpees","","For time"],
        
        ["Holbrook","10 rounds for time","5 thrusters (115 lbs)","10 pull-ups","100-meter sprint","Rest 1 minute","For time"],
        
        ["Jack","As many rounds as possible in 20 min","10 push presses (115 lbs)","10 kettlebell swings","10 box jumps","","AMRAP"],
        
        ["JBO","As many rounds as possible in 28 min","9 overhead squats (115 lbs)","1 legless rope climb","12 Bench presses (115 lbs)","","AMRAP"],
        
        ["Jerry","For time","Run 1 mile","Row 2.000 meters","Run 1 mile","","For time"],
        
        ["JT","21, 15, 9 reps for time","Handstand push-ups","Ring dips","Push-ups","","For time"],
        
        ["Johnson","As many rounds as possible in 20 min","9 deadlifts (245 lbs)","8 muscle-ups","9 squat cleans (155 lbs)","","AMRAP"],
        
        ["Joshie","3 Rounds For Time","21 dumbbell snatches (40 lbs)","21 L-pull-ups","21 dumbbell snatches (40 lbs)","21 L-pull-ups","For time"],
        
        ["Justin","30-20-10 rounds","Back squats (BW)","Bench press (BW)","Strict pull-ups","","For time"],
        
        ["Klepto","4 rounds for time","27 box jumps","20 burpess","11 squat cleans (145 lbs)","","For time"],
        
        ["Luce","3 Rounds For Time","1k Run","10 Muscle Ups","100 Squats","","For time"],
        
        ["Manion","7 rounds for time","Run 400 meters","29 back squats (135 lbs)","","","For time"],
        
        ["McGhee","As many rounds as possible in 30 min","5 deadlifts (275 lbs)","13 push-ups","9 box jumps (24 inch)","","AMRAP"],
        
        ["Mccluskey","3 rounds for time","9 muscle-ups","15 burpee pull-ups","21 pull ups","Run 800 meters","For time"],
        
        ["Michael","3 Rounds For Time","Run 800 meters","50 back extensions","50 sit-ups","","For time"],
        
        ["Moore","As many rounds as possible in 20 min","Rope climb","Run 400 meters","Max-reps handstand push-ups","","AMRAP"],
        
        ["Morrison","50-40-30-20-10 reps","Wall-ball shots","Box jumps","Kettlebell swings","","For time"],
        
        ["Mr. Joshua","5 Rounds For Time","Run 400 meters","30 GHD sit-ups","15 Deadlifts (250 lbs)","","For time"],
        
        ["Murph","For Time","2x1 mile Run","100 pull-ups","200 push-ups","300 Squats","For time"],
        
        ["Nate","As many rounds as possible in 20 min","2 muscle-ups","4 handstand push-ups","8 kettlebell swings","","AMRAP"],
        
        ["Paul","5 rounds for time","50 double-unders","35 knees-to-elbows","overhead walk (20 yards)","","For time"],
        
        ["Rahoi","As many rounds as possible in 12 min","12 box jumps","6 thrusters (95 lbs)","6 burpees","","AMRAP"],
        
        ["Randy","AMRAP","75 power Snatch","","","","AMRAP"],
        
        ["Rankel","As many rounds as possible in 20 min","6 deadlifts (225 lbs)","7 burpee pull-ups","10 kettlebell swings","Run 200 meters","AMRAP"],
        
        ["Ricky","As many rounds as possible in 20 min","10 pull-ups","5 dumbbell deadlifts (75 lbs)","8 push press (135 lbs)","","AMRAP"],
        
        ["RJ","5 rounds for time","Run 800 meters","5 ropeclimbs","50 push-ups","","For time"],
        
        ["Roy","5 rounds for time","15 deadlifts (225 lbs)","20 box jumps","25 pull-ups","","For time"],
        
        ["Ryan","For Time","75 power snatches (75 lbs)","","","","For time"],
        
        ["Santiago","7 rounds for time","18 dumbell squat cleans","18 pull-ups","10 power cleans (135 lbs)","10 handstand push-ups","For time"],
        
        ["Severin","For time","50 strict pull-ups","100 push-ups","Run 5.000 meters","","For time"],
        
        ["Small","3 rounds for time","Row 1.000 meters","50 burpess","50 box jumps","Run 800 meters","For time"],
        
        ["Stephen","30-25-20-15-10-5 reps for time","GHD sit-ups","Back extensions","Knees-to-elbows","Stiff-legged deadlifts (95 lbs)","For time"],
        
        ["Thompson","10 rounds for time","Rope climb","29 back squat (95 lbs)","Farmers carry 10 meters","","For time"],
        
        ["Tyler","5 rounds for time","7 muscle-ups","21 sumo deadlift high pulls (95 lbs)","","","For time"],
        
        ["War Frank","3 rounds for time","25 muscle-ups","100 squats","35 GHD sit-ups","","For time"],
        
        ["White","5 rounds For Time","3 rope climb","10 toes to bar","21 lunges","Run 400 meters","For time"],
        
        ["Wilmot","6 rounds for time","50 squats","25 ring dips","","","For time"],
        
        ["Wittman","7 rounds for time","15 kettlebell swings","15 power cleans (95 lbs)","15 box jumps","","For time"],
        
        ["Zimmerman","As many rounds as possible in 25 min","11 chest-to-bar pull-ups","2 deadlifts (315 lbs)","10 handstand push-ups","","AMRAP"],
    
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlBar.setTitle(wodCollectionOne, forSegmentAt: 0)
        segmentedControlBar.setTitle(wodCollectionTwo, forSegmentAt: 1)
        segmentSelected = wodCollectionOne // The first segmentSelected should be wodCollectionOne
        
        navigationbarcolor()
        
        getWod()
        
        self.collectionView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.09, alpha: 1.0) /* #191919 */
        
    }
    
    func navigationbarcolor() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0) /* #333333 */
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        transparentNavigationBarFalse()
        wodsWithDataArray.removeAll()
        getWod()
        collectionView?.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        transparentNavigationBar()
    }
    
    
    func transparentNavigationBar(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func transparentNavigationBarFalse(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0) /* #333333 */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWodDescription"
        {
            
            let indexPaths = self.collectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as IndexPath
            
            let vc = segue.destination as! WodDescriptionViewController
            
            if segmentSelected == wodCollectionOne {
                
                vc.wodName = theGirlsWodsCollection[indexPath.row][0]
                vc.timeComponent = theGirlsWodsCollection[indexPath.row][1]
                vc.firstExercise = theGirlsWodsCollection[indexPath.row][2]
                vc.secondExercise = theGirlsWodsCollection[indexPath.row][3]
                vc.thirdExercise = theGirlsWodsCollection[indexPath.row][4]
                vc.fourthExercise = theGirlsWodsCollection[indexPath.row][5]
                vc.timeComponentType = theGirlsWodsCollection[indexPath.row][6]
                vc.color = UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // Orange
                
                switch(theGirlsWodsCollection[indexPath.row][7]){
                
                case "blue":
                    vc.color = UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
                    
                case "purple":
                    vc.color = UIColor(red:0.25, green:0.51, blue:0.84, alpha:1.0) // purple
                    
                case "yellow":
                    vc.color = UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // yellow
                    
                case "orange":
                    vc.color = UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
                    
                default:
                    vc.color = UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // Orange
                    
                }
            }
            
            if segmentSelected == wodCollectionTwo {
                
                vc.wodName = heroWodsCollection[indexPath.row][0]
                vc.timeComponent = heroWodsCollection[indexPath.row][1]
                vc.firstExercise = heroWodsCollection[indexPath.row][2]
                vc.secondExercise = heroWodsCollection[indexPath.row][3]
                vc.thirdExercise = heroWodsCollection[indexPath.row][4]
                vc.fourthExercise = heroWodsCollection[indexPath.row][5]
                vc.timeComponentType = heroWodsCollection[indexPath.row][6]
                vc.color = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            }
            
        }
        
    }
    
    @IBAction func segmentedControl(_ sender: AnyObject) {
        
        if(segmentedControlBar.selectedSegmentIndex == 0)
        {
            segmentSelected = wodCollectionOne
        }
        else if(segmentedControlBar.selectedSegmentIndex == 1)
        {
            segmentSelected = wodCollectionTwo
        }
        
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentSelected == wodCollectionOne {
            return self.theGirlsWodsCollection.count
            
        }
        if segmentSelected == wodCollectionTwo {
            
            return self.heroWodsCollection.count
            
        } else {
            
            return 1
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WodsResumeCollectionViewCell
        
        if segmentSelected == wodCollectionOne {
            let name = theGirlsWodsCollection[indexPath.row][0]
            cell.name.text = name.uppercased()
            let timeComponent = theGirlsWodsCollection[indexPath.row][1]
            cell.timeComponent.text = timeComponent.uppercased()
            cell.firstExercise.text = theGirlsWodsCollection[indexPath.row][2]
            cell.secondExercise.text = theGirlsWodsCollection[indexPath.row][3]
            cell.thirdExercise.text = theGirlsWodsCollection[indexPath.row][4]
            cell.fourthExercise.text = theGirlsWodsCollection[indexPath.row][5]
            
            if (wodsWithDataArray.contains(theGirlsWodsCollection[indexPath.row][0])) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
            switch(theGirlsWodsCollection[indexPath.row][7]){
                
            case "blue":
                cell.backgroundColor = UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0) // blue
                
            case "purple":
                cell.backgroundColor = UIColor(red:0.25, green:0.51, blue:0.84, alpha:1.0) // purple
                
            case "yellow":
                cell.backgroundColor = UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // yellow
                
            case "orange":
                cell.backgroundColor = UIColor(red:0.95, green:0.47, blue:0.29, alpha:1.0) // orange
                
            default:
                cell.backgroundColor = UIColor(hue: 0.0222, saturation: 0.72, brightness: 0.91, alpha: 1.0) // Orange
                
            }
            
            
            
            return cell
            
        }
        
        if segmentSelected == wodCollectionTwo {
            let name = heroWodsCollection[indexPath.row][0]
            cell.name.text = name.uppercased()
            let timeComponent = heroWodsCollection[indexPath.row][1]
            cell.timeComponent.text = timeComponent.uppercased()
            cell.firstExercise.text = heroWodsCollection[indexPath.row][2]
            cell.secondExercise.text = heroWodsCollection[indexPath.row][3]
            cell.thirdExercise.text = heroWodsCollection[indexPath.row][4]
            cell.fourthExercise.text = heroWodsCollection[indexPath.row][5]
            cell.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            
            if (wodsWithDataArray.contains(heroWodsCollection[indexPath.row][0])) {
                cell.imageIcon.isHidden = false
            } else {
                cell.imageIcon.isHidden = true
            }
            
            
            return cell
            
        }
            
        else {
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width

        if (size <= 320) {
            return CGSize(width: (300), height: (175))
            
        }
        if (size <= 375) {
            return CGSize(width: (350), height: (175))
        }
        if (size <= 414) {
            return CGSize(width: (400), height: (175))
        }
        
        
        return CGSize(width: 300, height: 175)
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
    
}
