//
//  WodsCollectionViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit

class WodsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var segmentedControlBar: UISegmentedControl!
    
    var wodCollectionOne = "Girls"
    var wodCollectionTwo = "Heroes"
    var segmentSelected: String?
    var theGirlsWodsCollection:[[String]] = [
        
        ["Amanda","9-7-5 reps for time","Muscle-ups","135-lb. snatches","","","For time","orange"],
        
        ["Angie","For time","100 pull-ups","100 push-ups","100 sit-ups","100 squats","For time","blue"],
        
        ["Annie","50-40-30-20-10 reps for time","Double-unders","Sit-ups","","","For time","blue"],
        
        ["Barbara","5 rounds for time","20 pull-ups","30 push-ups","40 sit-ups","50 squats","For time","blue"],
        
        ["Candy","5 rounds for time","20 pull-ups","40 push-ups","60 squats","","For time","blue"],
        
        ["Chelsea","Every minute on the minute for 30 minutes","5 pull-ups","10 push-ups","15 squats","","EMON","blue"],
        
        ["Cindy","As many rounds as possible in 20 minutes","5 pull-ups","10 push-ups","15 squats","","AMRAP","blue"],
        
        ["Diane","21-15-9 reps for time","225-lb. deadlifts","Handstand push-ups","","","For time","orange"],
        
        ["Elizabeth","21-15-9 reps for time","135-lb. cleans","Ring dips","","","For time","orange"],
        
        ["Eva","5 rounds for time","Run 800 meters","30 kettlebell swings","30 pull-ups","","For time","purple"],
        
        ["Fran","21-15-9 reps for time","95-lb. thrusters","Pull-ups","","","For time","orange"],
        
        ["Grace","30 reps for time","21 Thrusters","pull-ups","","","For time","yellow"],
        
        ["Helen","3 rounds for time","Run 400 meters","21 kettlebell swings","12 pull-ups","","For time","purple"],
        
        ["Isabel","30 reps for time","135-lb. snatches","","","","For time","yellow"],
        
        ["Jackie","For time","Row 1,000 meters","50 45-lb. thrusters","30 pull-ups","","For time","orange"],
        
        ["Karen","For time","150 wall-ball shots","","","","For time","purple"],
        
        ["Kelly","5 rounds for time","Run 400 meters","30 box jumps","30 wall-ball shots","","For time","purple"],
        
        ["Linda","10-9-8-7-6-5-4-3-2-1 reps for time","1 1/2 BW deadlifts","BW bench presses","3/4 BW cleans","","For time","yellow"],
        
        ["Lynne","5 rounds for max reps","BW bench press","pull-ups","","","For time","orange"],
        
        ["Maggie","5 rounds for time","20 handstand push-ups","40 pull-ups","60 one-legged squats","","For time","blue"],
        
        ["Mary","As many rounds as possible in 20 minutes","5 handstand push-ups","10 1-legged squats","15 pull-ups","","AMRAP","blue"],
        
        ["Nancy","5 rounds for time","Run 400 meters","95-lb. overhead squats, 15 reps","","","For time","purple"],
    
        ["Nicole","As many rounds as possible in 20 minutes.","Run 400 meters","Max-reps pull-ups","","","AMRAP","blue"],
        
        ]
    
    var heroWodsCollection:[[String]] = [
        
        ["Bull","2 Rounds For Time","200 Double-unders","50 Overhead Squat","50 Pull-ups","Run 1 mile","For time"],
        
        ["DT","5 Rounds For Time","12 Deadlift","9 Hang Power Clean","6 Push Jerk","","For time"],
    
        ["Luce","3 Rounds For Time","1k Run","10 Muscle Ups","100 Squats","","For time"],
        
        ["Murph","For Time","1 mile Run","100 Pull-ups","200 push-ups","300 Squats","For time"],
        
        ["Randy","AMRAP","75 Power Snatch","","","","AMRAP"],
        
        ["White","5 Rounds For Time","3 Rope climb","10 Toes to bar","21 lunges","Run 400 meters","For time"],
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlBar.setTitle(wodCollectionOne, forSegmentAtIndex: 0)
        segmentedControlBar.setTitle(wodCollectionTwo, forSegmentAtIndex: 1)
        segmentSelected = wodCollectionOne // The first segmentSelected should be wodCollectionOne
        
        navigationbarcolor()
        
    }
    
    func navigationbarcolor() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0) /* #333333 */
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        transparentNavigationBarFalse()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
        transparentNavigationBar()
    }
    
    
    func transparentNavigationBar(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    func transparentNavigationBarFalse(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0) /* #333333 */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showWodDescription"
        {
            
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destinationViewController as! WodDescriptionViewController
            
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
    
    @IBAction func segmentedControl(sender: AnyObject) {
        
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentSelected == wodCollectionOne {
            return self.theGirlsWodsCollection.count
            
        }
        if segmentSelected == wodCollectionTwo {
            
            return self.heroWodsCollection.count
            
        } else {
            
            return 1
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WodsResumeCollectionViewCell
        
        if segmentSelected == wodCollectionOne {
            cell.name.text = theGirlsWodsCollection[indexPath.row][0]
            cell.timeComponent.text = theGirlsWodsCollection[indexPath.row][1]
            cell.firstExercise.text = theGirlsWodsCollection[indexPath.row][2]
            cell.secondExercise.text = theGirlsWodsCollection[indexPath.row][3]
            cell.thirdExercise.text = theGirlsWodsCollection[indexPath.row][4]
            cell.fourthExercise.text = theGirlsWodsCollection[indexPath.row][5]
            
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
            cell.name.text = heroWodsCollection[indexPath.row][0]
            cell.timeComponent.text = heroWodsCollection[indexPath.row][1]
            cell.firstExercise.text = heroWodsCollection[indexPath.row][2]
            cell.secondExercise.text = heroWodsCollection[indexPath.row][3]
            cell.thirdExercise.text = heroWodsCollection[indexPath.row][4]
            cell.fourthExercise.text = heroWodsCollection[indexPath.row][5]
            cell.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            
            return cell
            
        }
            
        else {
            
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = collectionView.frame.width
        print(size)
        
        if (size <= 320) {
            print("iPhone 5")
            return CGSize(width: (300), height: (175))
            
        }
        if (size <= 375) {
            print("iPhone 6/7")
            return CGSize(width: (350), height: (175))
        }
        if (size <= 414) {
            print("iPhone 6 plus")
            return CGSize(width: (400), height: (175))
        }
        
        
        return CGSize(width: 300, height: 175)
    }
}
