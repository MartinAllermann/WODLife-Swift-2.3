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
    
    
    @IBOutlet weak var activeDaysLast30Days: UILabel!
    @IBOutlet weak var activeDaysProgress: UILabel!
    @IBOutlet weak var wodsLast30Days: UILabel!
    @IBOutlet weak var wodsProgress: UILabel!
    @IBOutlet weak var totalWodsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    let dateFormatter = DateFormatter()
    var gradientLayer: CAGradientLayer!
    var wods = [Workout]()
    var totalActiveDaysLast30Days: String?
    var totalWodsLast30Days: String?
    var totalWodsAllTime: String?
    var wodsProgressString: String?
    var activeDaysProgressString: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        getWodResult()
        getWodData()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
         getStats()
         activeDaysLast30Days.text = totalActiveDaysLast30Days
         wodsLast30Days.text = totalWodsLast30Days
         totalWodsLabel.text = totalWodsAllTime
         wodsProgress.text = wodsProgressString
         activeDaysProgress.text = activeDaysProgressString
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Modal", sender: indexPath)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let workout = fetchedResultsController.object(at: self.tableView.indexPathForSelectedRow!) as! WodResult
        let vc = segue.destination as! HistoryModalViewController
        vc.wodName = workout.name
        let convertedDate = dateFormatter.string(from: workout.date!)
        vc.wodDate = convertedDate
        vc.wodNotes = workout.notes
        
        if (workout.rounds != 0) {
            
            vc.wodResult = "\(workout.rounds!)" // Fix this
            vc.wodType = "Rounds"
            
        }
        if (workout.weight != 0) {
            
            vc.wodResult = "\(workout.weight!)" // Fix this
            vc.wodType = "Weight"
            
        }
        if (workout.time != 0){
            
            vc.wodResult = "\(secondsToHoursMinutesSeconds(workout.time!))"
            vc.wodType = "Time"
        }
        
        vc.wodColor = colorPicker(colorName: getWorkoutColor(name: workout.name))
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
        cell.cellBackground?.backgroundColor = colorPicker(colorName: getWorkoutColor(name: workout.name))
        
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        header.textLabel?.textColor = UIColor.white
    }
    
    func colorPicker(colorName: String?) -> UIColor {
        
        switch(colorName!){
            
        case "blue":
            return UIColor(red:0.23, green:0.64, blue:0.89, alpha:1.0)
            
        case "orange":
            return UIColor(red:0.92, green:0.30, blue:0.36, alpha:1.0)
            
        case "green":
            return UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
            
        case "yellow":
            return UIColor(red:0.97, green:0.62, blue:0.40, alpha:1.0)
            
        default:
            return UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
            
        }
    }
    
    func getWorkoutColor(name: String?) -> String?{
        
        let workoutName = name
        let array = wods.filter() {($0.name as NSString).contains(workoutName!)}
        
        if array.isEmpty == true {
        return "green"
        } else {
          return array[0].color
        }
      
    }
    
    func getStats() {
        
        // last 30 days
        
        var today = Date()
        var last30Days = [String]()
        for _ in 1...30{
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "dd-MM-yyyy"
            let stringDate : String = date.string(from: today)
            today = tomorrow!
            last30Days.append(stringDate)
        }
        
        
        print(last30Days)
        print(getPrevious30Days())
        
        var allActiveDates: [String] = []
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                let dates = res.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                allActiveDates.append(dateFormatter.string(from: dates! as Date))
            }
        } catch {
            print("Unresolved error")
            abort()
        }
        print(allActiveDates.count)
        
        // LastMonth
        var activeDatesFromCurrentMonth: [String] = []
        for item in allActiveDates {
            if (last30Days.contains(item)){
                activeDatesFromCurrentMonth.append(item)
            }
        }
        print("\(activeDatesFromCurrentMonth.count)" + " Last 30 days")
        
        // PreviousMonth
        var activeDatesFromPreviousMonth: [String] = []
        for item in allActiveDates {
            if (getPrevious30Days().contains(item)){
                activeDatesFromPreviousMonth.append(item)
            }
        }
        print("\(activeDatesFromPreviousMonth.count)" + " Previous Month")
        
        // Last Month
        var dates: [String:String] = [:]
        for item in activeDatesFromCurrentMonth {
            dates[item] = (dates[item] ?? "0")
        }
        print("\(dates.count)" + "active dates")
        
        // Last Month
        var previousDates: [String:String] = [:]
        for item in activeDatesFromPreviousMonth {
            previousDates[item] = (previousDates[item] ?? "0")
        }
        print("\(previousDates.count)" + " previous active dates")
        
        if (allActiveDates.count != 0) {
            totalWodsAllTime = "\(allActiveDates.count)"
        } else {
            totalWodsAllTime = "0"
        }
        
        if (activeDatesFromCurrentMonth.count != 0) {
            totalWodsLast30Days = "\(activeDatesFromCurrentMonth.count)"
        } else {
            totalWodsLast30Days = "0"
        }
        
        if (dates.count != 0) {
            totalActiveDaysLast30Days = "\(dates.count)"
        } else {
            totalActiveDaysLast30Days = "0"
        }
        
        if (activeDatesFromPreviousMonth.count != 0) {
            let last30daysWodsProgress = ((Double(activeDatesFromCurrentMonth.count) - Double(activeDatesFromPreviousMonth.count)) / Double(activeDatesFromPreviousMonth.count)) * 100
            
            if(last30daysWodsProgress > 0) {
                wodsProgressString = "▲ "+"\(Int(last30daysWodsProgress))" + "%"
                wodsProgress.textColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
            }
            if(last30daysWodsProgress == 0) {
                wodsProgressString = "\(Int(last30daysWodsProgress))" + "%"
                wodsProgress.textColor = UIColor.white
            }
            if(last30daysWodsProgress < 0) {
                wodsProgressString = "▼ "+"\(Int(last30daysWodsProgress))" + "%"
                wodsProgress.textColor = UIColor(red:0.92, green:0.30, blue:0.36, alpha:1.0)
            }
            
        }
        
        if (previousDates.count != 0) {
                let last30ActiveDaysProgress = ((Double(dates.count) - Double(previousDates.count)) / Double(previousDates.count)) * 100
                
                if(last30ActiveDaysProgress > 0) {
                    activeDaysProgressString = "▲ " + "\(Int(last30ActiveDaysProgress))" + "%"
                    activeDaysProgress.textColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
                }
                if(last30ActiveDaysProgress == 0) {
                    activeDaysProgressString = "\(Int(last30ActiveDaysProgress))" + "%"
                    activeDaysProgress.textColor = UIColor.white
                }
                if(last30ActiveDaysProgress < 0) {
                    activeDaysProgressString = "▼ "+"\(Int(last30ActiveDaysProgress))" + "%"
                    activeDaysProgress.textColor = UIColor(red:0.92, green:0.30, blue:0.36, alpha:1.0)
                }
        }
    }
    
    func getPrevious30Days() -> [String] {
        
        let today = Date()
        var previousMonth = Calendar.current.date(byAdding: .day, value: -30, to: today)
        var last30Days = [String]()
        for _ in 1...30{
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: previousMonth!)
            let date = DateFormatter()
            date.dateFormat = "dd-MM-yyyy"
            let stringDate : String = date.string(from: previousMonth!)
            previousMonth = tomorrow!
            last30Days.append(stringDate)
        }
        
        return last30Days
    }

    func getWodData(){
        
        wods = [
            Workout(name:"Amanda", typeDescription:"9-7-5 reps for time", description:"Muscle-ups\nSnatches (135/95 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Angie", typeDescription:"For time", description:"100 pull-ups\n100 push-ups\n100 sit-ups\n100 squats", type: "For time", color: "orange", id: ""),
            Workout(name:"Annie", typeDescription:"50-40-30-20-10 reps for time", description:"Double-unders\nSit-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Barbara", typeDescription:"5 rounds for time", description:"20 pull-ups\n30 push-ups\n40 sit-ups\n50 squats", type: "For time", color: "orange", id: ""),
            Workout(name:"Betty", typeDescription:"5 rounds for time", description:"12 Push Press (135/95 lbs)\n20 Box Jumps", type: "For time", color: "orange", id: ""),
            Workout(name:"Candy", typeDescription:"5 rounds for time", description:"20 pull-ups\n40 push-ups\n60 squats", type: "For time", color: "orange", id: ""),
            Workout(name:"Charlotte", typeDescription:"21-15-9 reps for time", description:"Overhead Squats (95/65 lbs)\nSumo Deadlift High Pull (95/65 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Chelsea", typeDescription:"Every minute on the minute for 30 min", description:"5 pull-ups\n10 push-ups\n15 squats", type: "EMOM", color: "orange", id: ""),
            Workout(name:"Christine", typeDescription:"3 rounds for time", description:"500 meter Row\n12 Deadlifts (BW)\n21 Box Jumps", type: "For time", color: "orange", id: ""),
            Workout(name:"Cindy", typeDescription:"As many rounds as possible in 20 min", description:"5 pull-ups\n10 push-ups\n15 squats", type: "AMRAP", color: "orange", id: ""),
            Workout(name:"Claudia", typeDescription:"5 Rounds for time", description:"20 Dumbbell Swings (55 lbs)\n400 Meter Run", type: "For time", color: "orange", id: ""),
            Workout(name:"Diane", typeDescription:"21-15-9 reps for time", description:"Deadlift (225/155 lbs)\nHandstand push-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Elizabeth", typeDescription:"21-15-9 reps for time", description:"Cleans (135/95 lbs)\nRing dips", type: "For time", color: "orange", id: ""),
            Workout(name:"Eva", typeDescription:"5 rounds for time", description:"Run 800 meters\n30 kettlebell swings\n30 pull-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Fran", typeDescription:"21-15-9 reps for time", description:"Thrusters (95/65 lbs)\nPull-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Grace", typeDescription:"30 reps for time", description:"Clean-and-Jerks (135/95 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Heather", typeDescription:"3 Rounds for time", description:"550 meter Row\n12 Deadlifts (225/155 lbs)\n21 Rings Dips", type: "For time", color: "orange", id: ""),
            Workout(name:"Helen", typeDescription:"3 rounds for time", description:"Run 400 meters\n21 kettlebell swings\n12 pull-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Isabel", typeDescription:"30 reps for time", description:"Snatches (135/95 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Jackie", typeDescription:"For time", description:"Row 1,000 meters\n50 Thrusters (45 lbs)\n30 pull-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Karen", typeDescription:"For time", description:"150 wall-ball shots", type: "For time", color: "orange", id: ""),
            Workout(name:"Kelly", typeDescription:"5 rounds for time", description:"Run 400 meters\n30 box jumps\n30 wall-ball shots", type: "For time", color: "orange", id: ""),
            Workout(name:"Lola", typeDescription:"5 Rounds for time", description:"30 Double Unders\n20 Knees-to-Elbows\n10 Handstand Push-Ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Linda", typeDescription:"10-9-8-7-6-5-4-3-2-1 reps for time", description:"Deadlifts (1.5 BW)\nBench presses (BW)\nCleans (3/4 BW)", type: "For time", color: "orange", id: ""),
            Workout(name:"Lynne", typeDescription:"5 rounds for max reps", description:"Bench press (BW)\npull-ups", type: "For time", color: "orange", id: ""),
            Workout(name:"Maggie", typeDescription:"5 rounds for time", description:"20 handstand push-ups\n40 pull-ups\n60 one-legged squats", type: "For time", color: "orange", id: ""),
            Workout(name:"Mary", typeDescription:"As many rounds as possible in 20 min", description:"20 handstand push-ups\n40 pull-ups\n60 one-legged squats", type: "AMRAP", color: "orange", id: ""),
            Workout(name:"Nasty girls", typeDescription:"3 Rounds for time", description:"50 Air Squats\n7 Muscle-Ups\n10 Hang Power Cleans (135/95 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Nancy", typeDescription:"5 rounds for time", description:"Run 400 meters\n15 Overhead squats (95/65 lbs)", type: "For time", color: "orange", id: ""),
            Workout(name:"Nicole", typeDescription:"As many rounds as possible in 20 min", description:"Run 400 meters\nMax-reps pull-ups", type: "AMRAP", color: "orange", id: ""),
            Workout(name:"Rosa", typeDescription:"5 Rounds for time", description:"10 Handstand Push-Ups\n400 meter Run", type: "For time", color: "orange", id: ""),
            
            
            Workout(name:"Abbate", typeDescription:"For time", description:"Run 1 mile\n155-lb. clean and jerks, 21 reps\nRun 800 meters\n155-lb. clean and jerks, 21 reps\nRun 1 mile", type: "For time", color: "blue", id: ""),
            Workout(name:"Arnie", typeDescription:"For time", description:"21 Turkish get-ups, right arm\n50 kettlebell swings\n21 overhead squats, left arm\n50 kettlebell swings\n21 overhead squats, right arm\n50 kettlebell swings\n21 Turkish get-ups, left arm", type: "For time", color: "blue", id: ""),
            Workout(name:"Adambrown", typeDescription:"2 Rounds for time", description:"295-lb. deadlifts, 24 reps\n24 box jumps, 24-inch box\n24 wall-ball shots, 20-lb. ball\n195-lb. bench presses, 24 reps\n24 box jumps, 24-inch box\n24 wall-ball shots, 20-lb. ball\n145-lb. cleans, 24 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Badger", typeDescription:"3 Rounds for time", description:"30 squats cleans (95 lbs)\n30 pull-ups\nRun 800 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Barraza", typeDescription:"As many rounds as possible in 18 min", description:"Run 200 meters\n275-lb. deadlifts, 9 reps\n6 burpee bar muscle-ups", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Blake", typeDescription:"4 rounds for time", description:"100-ft. walking lunge with 45-lb. plate held overhead\n30 box jumps, 24-inch box\n20 wall-ball shots, 20-lb. ball\n10 handstand push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Bradley", typeDescription:"10 rounds for time", description:"Sprint 100 meters\n10 pull-ups\nSprint 100 meters\n10 burpees\nRest 30 seconds", type: "For time", color: "blue", id: ""),
            Workout(name:"Bradshaw", typeDescription:"10 rounds for time", description:"3 handstand push-ups\n6 deadlifts (225 lbs)\n12 pull-ups\n24 double-unders", type: "For time", color: "blue", id: ""),
            Workout(name:"Brehm", typeDescription:"For time", description:"15-ft. rope climbs, 10 ascents\n225-lb. back squats, 20 reps\n30 handstand push-ups\nRow 40 calories", type: "For time", color: "blue", id: ""),
            Workout(name:"Brian", typeDescription:"3 rounds for time", description:"15-ft. rope climbs, 5 ascents\n185-lb. back squats, 25 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Bulger", typeDescription:"10 rounds for time", description:"Run 150 meters\n7 chest-to-bar pull-ups\n7 front squats (135 lbs)\n7 handstand push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Bull", typeDescription:"2 Rounds for time", description:"200 double-unders\n50 overhead Squat\n50 pull-ups\nRun 1 mile", type: "For time", color: "blue", id: ""),
            Workout(name:"Cameron", typeDescription:"For time", description:"50 walking-lunge steps\n25 chest-to-bar pull-ups\n50 box jumps, 24-inch box\n25 triple-unders\n50 back extensions\n25 ring dips\n50 knees-to-elbows\n25 wall-ball\n50 sit-ups\n15-ft. rope climbs, 5 ascents", type: "For time", color: "blue", id: ""),
            Workout(name:"Carse", typeDescription:"21-18-15-12-9-6-3 reps for time", description:"95-lb. squat cleans\nDouble-unders\n185-lb. deadlifts\nBox jumps, 24-inch box\nBegin each round with a 50-meter bear crawl", type: "For time", color: "blue", id: ""),
            Workout(name:"Coe", typeDescription:"10 rounds for time", description:"10 thrusters (95 lbs)\n10 ring push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Collin", typeDescription:"6 rounds for time", description:"Carry sandbag 400 meters\n12 push presses\n12 box jumps\n12 sumo deadlift high pulls (95 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Danny", typeDescription:"As many rounds as possible in 20 min", description:"30 box jumps\n20 push presses (115 lbs)\n30 pull-ups", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Daniel", typeDescription:"For time", description:"50 pull-ups\n400-meter run\n95-lb. thrusters, 21 reps\n800-meter run\n95-lb. thrusters, 21 reps\n400-meter run\n50 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Del", typeDescription:"For time", description:"25 burpees\nRun 400 meters with a 20-lb. medicine ball\n25 weighted pull-ups with a 20-lb. dumbbell\nRun 400 meters with a 20-lb. medicine ball\n25 handstand push-ups\nRun 400 meters with a 20-lb. medicine ball\n25 chest-to-bar pull-ups\nRun 400 meters with a 20-lb. medicine ball\n25 burpees", type: "For time", color: "blue", id: ""),
            Workout(name:"Desforges", typeDescription:"5 rounds for time", description:"12 deadlift (225 lbs)\n20 pull-ups\n12 clean and jerks (135 lbs)\n20 knees-to-elbows", type: "For time", color: "blue", id: ""),
            Workout(name:"Dae han", typeDescription:"3 rounds for time", description:"Run 800 meters with barbell (45 lbs)\n3 Rope climbs\n12 Thrusters", type: "For time", color: "blue", id: ""),
            Workout(name:"DT", typeDescription:"5 Rounds For Time", description:"12 Deadlift\n9 Hang Power Clean\n6 Push Jerk", type: "For time", color: "blue", id: ""),
            Workout(name:"Erin", typeDescription:"5 rounds for time", description:"15 dumbbell split cleans (40 lbs)\n21 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Falkel", typeDescription:"As many rounds as possible in 25 min", description:"8 handstand push-ups\n8 box jumps, 30-inch box\n15-ft. rope climb, 1 ascent", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Forrest", typeDescription:"3 rounds for time", description:"20 L-pull-ups\n30 toes-to-bars\n40 burpess\nRun 800 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Gator", typeDescription:"8 rounds for time", description:"5 front squats (185 lbs)\n26 ring push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Garrett", typeDescription:"3 rounds for time", description:"75 squat\n25 ring handstand push-ups\n25 L-pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Gaza", typeDescription:"5 rounds for time", description:"35 kettlebell swings, 1.5 pood\n30 push-ups\n25 pull-ups\n20 box jumps, 30-inch box\n1-mile run", type: "For time", color: "blue", id: ""),
            Workout(name:"Glen", typeDescription:"For time", description:"135-lb. clean and jerks, 30 reps\nRun 1 mile\n15-ft. rope climbs, 10 ascents\nRun 1 mile\n100 burpees", type: "For time", color: "blue", id: ""),
            Workout(name:"Hammer", typeDescription:"5 rounds for time", description:"5 power cleans (135 lbs)\n10 front squats (135 lbs)\n5 jerks (135 lbs)\n20 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Hamilton", typeDescription:"3 rounds for time", description:"Row 1,000 meters\n50 push-ups\nRun 1,000 meters\n50 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Hansen", typeDescription:"5 rounds for time", description:"30 kettlebell swings\n30 burpess\n30 GHD sit-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Helton", typeDescription:"3 rounds for time", description:"Run 800 meters\n30 dumbbell squat cleans (50 lbs)\n30 burpees", type: "For time", color: "blue", id: ""),
            Workout(name:"Hidalgo", typeDescription:"For time", description:"Run 2 miles\nRest 2 min\n135-lb. squat cleans, 20 reps\n20 box jumps, 24-inch box\n20 walking lunges with 45-lb. plate held overhead\n20 box jumps, 24-inch box\n135-lb. squat cleans, 20 reps\nRest 2 min\nRun 2 miles", type: "For time", color: "blue", id: ""),
            Workout(name:"Holbrook", typeDescription:"10 rounds for time", description:"5 thrusters (115 lbs)\n10 pull-ups\n100-meter sprint\nRest 1 minute", type: "For time", color: "blue", id: ""),
            Workout(name:"Holleyman", typeDescription:"30 rounds for time", description:"5 wall-ball shots, 20-lb. ball\n3 handstand push-ups\n225-lb. power clean, 1 rep", type: "For time", color: "blue", id: ""),
            Workout(name:"Hortman", typeDescription:"As many rounds as possible in 45 min", description:"Run 800 meters\n80 squats\n8 muscle-ups", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Jack", typeDescription:"As many rounds as possible in 20 min", description:"10 push presses (115 lbs)\n10 kettlebell swings\n10 box jumps", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Jag 28", typeDescription:"For time", description:"Run 800 meters\n28 kettlebell swings, 2-pood kettlebell\n28 strict pull-ups\n28 kettlebell clean and jerks, 2-pood each\n28 strict pull-ups\nRun 800 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Jared", typeDescription:"4 rounds for time", description:"Run 800 meters\n40 pull-ups\n70 push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Jason", typeDescription:"For time", description:"100 squats\n5 muscle-ups\n75 squats\n10 muscle-ups\n50 squats\n15 muscle-ups\n25 squats\n20 muscle-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"JBO", typeDescription:"As many rounds as possible in 28 min", description:"9 overhead squats (115 lbs)\n1 legless rope climb\n12 Bench presses (115 lbs)", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Jerry", typeDescription:"For time", description:"Run 1 mile\nRow 2.000 meters\nRun 1 mile", type: "For time", color: "blue", id: ""),
            Workout(name:"Josh", typeDescription:"For time", description:"95-lb. overhead squats, 21 reps\n42 pull-ups\n95-lb. overhead squats, 15 reps\n30 pull-ups\n95-lb. overhead squats, 9 reps\n18 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Johnson", typeDescription:"As many rounds as possible in 20 min", description:"9 deadlifts (245 lbs)\n8 muscle-ups\n9 squat cleans (155 lbs)", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Joshie", typeDescription:"3 Rounds For Time", description:"21 dumbbell snatches (40 lbs)\n21 L-pull-ups\n21 dumbbell snatches (40 lbs)\n21 L-pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"JT", typeDescription:"21, 15, 9 reps for time", description:"Handstand push-ups\nRing dips\nPush-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Justin", typeDescription:"30-20-10 rounds", description:"Back squats (BW)\nBench press (BW)\nStrict pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Klepto", typeDescription:"4 rounds for time", description:"27 box jumps\n20 burpess\n11 squat cleans (145 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Ledesma", typeDescription:"As many rounds as possible in 20 min", description:"5 parallette handstand push-ups\n10 toes-through-rings\n15 medicine-ball cleans, 20-lb. ball", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Loredo", typeDescription:"6 rounds for time", description:"24 squats\n24 push-ups\n24 walking-lunge steps\nRun 400 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Luce", typeDescription:"3 Rounds For Time", description:"1k Run\n10 Muscle Ups\n100 Squats", type: "For time", color: "blue", id: ""),
            Workout(name:"Manion", typeDescription:"7 rounds for time", description:"Run 400 meters\n29 back squats (135 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Marco", typeDescription:"3 rounds for time", description:"21 pull-ups\n15 handstand push-ups\n9 thrusters, 135 lb.", type: "For time", color: "blue", id: ""),
            Workout(name:"McGhee", typeDescription:"As many rounds as possible in 30 min", description:"5 deadlifts (275 lbs)\n13 push-ups\n9 box jumps (24 inch)", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Mccluskey", typeDescription:"3 rounds for time", description:"9 muscle-ups\n15 burpee pull-ups\n21 pull ups\nRun 800 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Meadows", typeDescription:"For time", description:"20 muscle-ups\n25 lowers\n30 ring handstand push-ups\n35 ring rows\n40 ring push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Michael", typeDescription:"3 Rounds For Time", description:"Run 800 meters\n50 back extensions\n50 sit-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Moon", typeDescription:"7 rounds for time", description:"40-lb. dumbbell hang split snatches, 10 reps, right arm\nRope climb, 1 ascent\n40-lb. dumbbell hang split snatches, 10 reps, left arm\nRope climb, 1 ascent", type: "For time", color: "blue", id: ""),
            Workout(name:"Moore", typeDescription:"As many rounds as possible in 20 min", description:"Rope climb\nRun 400 meters\nMax-reps handstand push-ups", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Morrison", typeDescription:"50-40-30-20-10 reps", description:"Wall-ball shots\nBox jumps\nKettlebell swings", type: "For time", color: "blue", id: ""),
            Workout(name:"Mr. Joshua", typeDescription:"5 Rounds For Time", description:"Run 400 meters\n30 GHD sit-ups\n15 Deadlifts (250 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Murph", typeDescription:"For Time", description:"1 mile Run\n100 pull-ups\n200 push-ups\n300 Squats\n1 mile Run", type: "For time", color: "blue", id: ""),
            Workout(name:"Nate", typeDescription:"As many rounds as possible in 20 min", description:"2 muscle-ups\n4 handstand push-ups\n8 kettlebell swings", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Nick", typeDescription:"12 rounds for time", description:"45-lb. dumbbell hang squat cleans, 10 reps\n6 handstand push-ups on dumbbells", type: "For time", color: "blue", id: ""),
            Workout(name:"Nutts", typeDescription:"For time", description:"10 handstand push-ups\n250-lb. deadlifts, 15 reps\n25 box jumps, 30-inch box\n50 pull-ups\n100 wall-ball shots, 20-lb. ball\n200 double-unders\nRun 400 meters with a 45-lb. plate", type: "For time", color: "blue", id: ""),
            Workout(name:"Paul", typeDescription:"5 rounds for time", description:"50 double-unders\n35 knees-to-elbows\noverhead walk (20 yards)", type: "For time", color: "blue", id: ""),
            Workout(name:"Rahoi", typeDescription:"As many rounds as possible in 12 min", description:"12 box jumps\n6 thrusters (95 lbs)\n6 burpees", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Ralph", typeDescription:"4 rounds for time", description:"250-lb. deadlifts, 8 reps\n16 burpees\n15-ft. rope climbs, 3 ascents\nRun 600 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Randy", typeDescription:"AMRAP", description:"75 power Snatch", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Rankel", typeDescription:"As many rounds as possible in 20 min", description:"6 deadlifts (225 lbs)\n7 burpee pull-ups\n10 kettlebell swings\nRun 200 meters", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Ricky", typeDescription:"As many rounds as possible in 20 min", description:"10 pull-ups\n5 dumbbell deadlifts (75 lbs)\n8 push press (135 lbs)", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"RJ", typeDescription:"5 rounds for time", description:"Run 800 meters\n5 ropeclimbs\n50 push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Robbie", typeDescription:"as many rounds as possible in 25 min", description:"8 freestanding handstand push-ups\n15-foot L-sit rope climb, 1 ascent", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Roy", typeDescription:"5 rounds for time", description:"15 deadlifts (225 lbs)\n20 box jumps\n25 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Ryan", typeDescription:"For Time", description:"75 power snatches (75 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Pheezy", typeDescription:"3 rounds for Time", description:"165-lb. front squats, 5 reps\n18 pull-ups\n225-lb. deadlifts, 5 reps\n18 toes-to-bars\n165-lb. push jerks, 5 reps\n18 hand-release push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Pike", typeDescription:"5 rounds for Time", description:"75-lb. thrusters, 20 reps\n10 strict ring dips\n20 push-ups\n10 strict handstand push-ups\n50-meter bear crawl", type: "For time", color: "blue", id: ""),
            Workout(name:"Santiago", typeDescription:"7 rounds for time", description:"18 dumbell squat cleans\n18 pull-ups\n10 power cleans (135 lbs)\n10 handstand push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Santora", typeDescription:"3 rounds for reps", description:"155-lb. squat cleans, 1 minute\n20-ft. shuttle sprints (20 ft. forward + 20 ft. backwards = 1 rep), 1 minute\n245-lb. deadlifts, 1 minute\nBurpees, 1 minute\n155-lb. jerks, 1 minute\nRest 1 minute", type: "For time", color: "blue", id: ""),
            Workout(name:"Sean", typeDescription:"10 rounds for time", description:"11 chest-to-bar pull-ups\n75-lb. front squats, 22 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Servais", typeDescription:"For time", description:"Run 1.5 miles\nThen, 8 rounds of:\n19 pull-ups\n19 push-ups\n19 burpees\nThen,\n400-meter sandbag carry (heavy)\n1-mile farmers carry with 45-lb. dumbbell", type: "For time", color: "blue", id: ""),
            Workout(name:"Severin", typeDescription:"For time", description:"50 strict pull-ups\n100 push-ups\nRun 5.000 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Ship", typeDescription:"9 rounds for time", description:"185-lb. squat cleans, 7 reps\n8 burpee box jumps, 36-inch box", type: "For time", color: "blue", id: ""),
            Workout(name:"Small", typeDescription:"3 rounds for time", description:"Row 1.000 meters\n50 burpess\n50 box jumps\nRun 800 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Stephen", typeDescription:"30-25-20-15-10-5 reps for time", description:"GHD sit-ups\nBack extensions\nKnees-to-elbows\nStiff-legged deadlifts (95 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Strange", typeDescription:"8 rounds for time", description:"600-meter run\n1.5-pood weighted pull-up, 11 reps\n11 walking lunges, carrying 1.5-pood kettlebells\n1.5-pood kettlebell thruster, 11 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Terry", typeDescription:"For time", description:"1-mile run\n100 push-ups\n100-meter bear crawl\n1-mile run\n100-meter bear crawl\n100 push-ups\n1-mile run", type: "For time", color: "blue", id: ""),
            Workout(name:"The Seven", typeDescription:"7 rounds for time", description:"7 handstand push-ups\n135-lb. thrusters, 7 reps\n7 knees-to-elbows\n245-lb. deadlifts, 7 reps\n7 burpees\n2-pood kettlebell swings, 7 reps\n7 pull-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Thompson", typeDescription:"10 rounds for time", description:"Rope climb\n29 back squat (95 lbs)\nFarmers carry 10 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Tom", typeDescription:"As many rounds as possible in 25 min", description:"7 muscle-ups\n155-lb. thrusters, 11 reps\n14 toes-to-bars", type: "AMRAP", color: "blue", id: ""),
            Workout(name:"Tommy", typeDescription:"For time", description:"115-lb. thrusters, 21 reps\n15-ft. rope climbs, 12 ascents\n115-lb. thrusters, 15 reps\n15-ft. rope climbs, 9 ascents\n115-lb. thrusters, 9 reps\n15-ft. rope climbs, 6 ascents", type: "For time", color: "blue", id: ""),
            Workout(name:"Tully", typeDescription:"4 rounds for time", description:"Swim 200 meters\n40-lb. dumbbell squat cleans, 23 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Tumilson", typeDescription:"8 rounds for time", description:"Run 200 meters\n11 dumbbell burpee deadlifts, 60-lb. dumbbells", type: "For time", color: "blue", id: ""),
            Workout(name:"Tyler", typeDescription:"5 rounds for time", description:"7 muscle-ups\n21 sumo deadlift high pulls (95 lbs)", type: "For time", color: "blue", id: ""),
            Workout(name:"Omar", typeDescription:"For time", description:"95-lb. thrusters, 10 reps\n15 bar-facing burpees\n95-lb. thrusters, 20 reps\n25 bar-facing burpees\n95-lb. thrusters, 30 reps\n35 bar-facing burpees", type: "For time", color: "blue", id: ""),
            Workout(name:"War Frank", typeDescription:"3 rounds for time", description:"25 muscle-ups\n100 squats\n35 GHD sit-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Weaver", typeDescription:"4 rounds for time", description:"10 L-pull-ups\n15 push-ups\n15 chest-to-bar pull-ups\n15 push-ups\n20 pull-ups\n15 push-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Weston", typeDescription:"5 rounds for time", description:"Row 1,000 meters\n200-meter farmers carry, 45-lb. dumbbells\n45-lb. dumbbell waiters walk, 50 meters, right arm\n45-lb. dumbbell waiters walk, 50 meters, left arm", type: "For time", color: "blue", id: ""),
            Workout(name:"White", typeDescription:"5 rounds For Time", description:"3 rope climb\n10 toes to bar\n21 lunges\nRun 400 meters", type: "For time", color: "blue", id: ""),
            Workout(name:"Wilmot", typeDescription:"6 rounds for time", description:"50 squats\n25 ring dips", type: "For time", color: "blue", id: ""),
            Workout(name:"Whitten", typeDescription:"5 rounds for time", description:"2-pood kettlebell swings, 22 reps\n22 box jumps, 24-inch box\nRun 400 meters\n22 burpees\n22 wall-ball shots, 20-lb. ball", type: "For time", color: "blue", id: ""),
            Workout(name:"Woehlke", typeDescription:"3 rounds, each for time", description:"4 jerks, 185 lb.\n5 front squats, 185 lb.\n6 power cleans, 185 lb.\n40 pull-ups\n50 push-ups\n60 sit-ups", type: "For time", color: "blue", id: ""),
            Workout(name:"Wood", typeDescription:"5 rounds for time", description:"Run 400 meters\n10 burpee box jumps, 24-inch box\n95-lb. sumo deadlift high pulls, 10 reps\n95-lb. thrusters, 10 reps\nRest 1 minute", type: "For time", color: "blue", id: ""),
            Workout(name:"Wittman", typeDescription:"7 rounds for time", description:"15 kettlebell swings\n15 power cleans (95 lbs)\n15 box jumps", type: "For time", color: "blue", id: ""),
            Workout(name:"ZEUS", typeDescription:"3 rounds for time", description:"30 wall-ball shots, 20-lb. ball\n75-lb. sumo deadlift high pulls, 30 reps\n30 box jumps, 20-inch box\n75-lb. push presses, 30 reps\nRow 30 calories\n30 push-ups\nBody-weight back squats, 10 reps", type: "For time", color: "blue", id: ""),
            Workout(name:"Zimmerman", typeDescription:"As many rounds as possible in 25 min", description:"11 chest-to-bar pull-ups\n2 deadlifts (315 lbs)\n10 handstand push-ups", type: "AMRAP", color: "blue", id: ""),
            
            Workout(name:"OPEN 17.5", typeDescription:"10 Rounds for Time", description:"9 Thrusters (95/65 lb)\n35 Double Unders", type: "For time", color: "yellow", id: "308"),
            Workout(name:"OPEN 17.4", typeDescription:"AMRAP in 13 min", description:"55 Deadlifts (225/155 lbs)\n55 Wall Ball Shots (20/14 lb to 10/9 ft)\n55 calorie Row\n55 Handstand Push-Ups", type: "AMRAP", color: "yellow", id: "310"),
            Workout(name:"OPEN 17.3", typeDescription:"For Reps", description:"Prior to 8 minutes, 3 rounds of:\n6 Chest-to-Bar Pull-Ups\n6 Squat Snatches (95/65 lbs)\nThen 3 rounds of:\n7 Chest-to-Bar Pull-Ups\n5 Squat Snatches (135/95 lbs)\n* Prior to 12 minutes, 3 rounds of:\n8 Chest-to-Bar Pull-Ups\n4 Squat Snatches (185/135 lbs)\n* Prior to 16 minutes, 3 rounds of:\n9 Chest-to-Bar Pull-Ups\n3 Squat Snatches (225/155 lbs)\n* Prior to 20 minutes, 3 rounds of:\n10 Chest-to-Bar Pull-Ups\n2 Squat Snatches (245/175 lbs)\n* Prior to 24 minutes, 3 rounds of:\n11 Chest-to-Bar Pull-Ups\n1 Squat Snatch (265/185 lbs)", type: "AMRAP", color: "yellow", id: "312"),
            Workout(name:"OPEN 17.2", typeDescription:"AMRAP in 12 min", description:"2 Rounds of:\n50 ft Dumbbell Walking Lunges (50/35 lb)\n16 Toe-to-Bars\n8 Dumbbell Power Cleans (50/35 lb)\nThen, 2 Rounds of:\n50 ft Dumbbell Walking Lunges (50/35 lb)\n16 Bar Muscle-Ups\n8 Dumbbell Power Cleans (50/35 lb)", type: "AMRAP", color: "yellow", id: "314"),
            Workout(name:"OPEN 17.1", typeDescription:"For Time", description:"10 Dumbbell Snatches (50/35 lbs)\n15 Burpee Box Jump Overs\n20 Dumbbell Snatches (50/35 lbs)\n15 Burpee Box Jump Overs\n30 Dumbbell Snatches (50/35 lbs)\n15 Burpee Box Jump Overs\n40 Dumbbell Snatches (50/35 lbs)\n15 Burpee Box Jump Overs\n50 Dumbbell Snatches (50/35 lbs)\n15 Burpee Box Jump Overs", type: "For time", color: "yellow", id: "316"),
            
            Workout(name:"OPEN 16.5", typeDescription:"21-18-15-12-9-6-3 Reps For Time", description:"Thrusters (95/65 lbs)\nBar-Facing Burpees", type: "For time", color: "yellow", id: "318"),
            Workout(name:"OPEN 16.4", typeDescription:"AMRAP in 13 min", description:"55 Deadlifts (225/155 lb)\n55 Wall-Balls (20/14 lb)\n55 calorie Row\n55 Handstand Push-Ups", type: "AMRAP", color: "yellow", id: "320"),
            Workout(name:"OPEN 16.3", typeDescription:"AMRAP in 7 minutes", description:"10 Power Snatches (75/55 lbs)\n3 Bar Muscle-Ups", type: "AMRAP", color: "yellow", id: "322"),
            Workout(name:"OPEN 16.2", typeDescription:"AMRAP in 20 min", description:"Continue until 4 minutes:\n25 Toes-to-Bars\n50 Double-Unders\n15 Squat Cleans (135/85 lbs)\nIf completed before 4 minutes, continue until 8 minutes:\n25 Toes-to-Bars\n50 Double-Unders\n13 Squat Cleans (185/115 lbs)\nIf completed before 8 minutes, continue until 12 minutes:\n25 Toes-to-Bars\n50 Double-Unders\n11 Squat Cleans (225/145 lbs)\nIf completed before 12 minutes, continue until 16 minutes:\n25 Toes-to-Bars\n50 Double-Unders\n9 Squat Cleans (275/175 lbs)\nIf completed before 16 minutes, continue until 20 minutes:\n25 Toes-to-Bars\n50 Double-Unders\n7 Squat Cleans (315/205 lbs)", type: "AMRAP", color: "yellow", id: "324"),
            Workout(name:"OPEN 16.1", typeDescription:"AMRAP in 20 minutes", description:"25 ft Overhead Walking Lunges (95/65 lbs)\n8 Bar-Facing Burpees\n25 ft Overhead Walking Lunges (95/65 lbs)\n8 Chest-to-Bar Pull-Ups", type: "AMRAP", color: "yellow", id: "326"),
            
            Workout(name:"OPEN 15.5", typeDescription:"27-21-15-9 Reps for Time", description:"Row (calories)\nThrusters (95/65 lbs)", type: "For time", color: "yellow", id: "328"),
            Workout(name:"OPEN 15.4", typeDescription:"As Many Reps as Possible in 8 minutes", description:"Complete as many reps as possible in 8 minutes of:\n3 handstand push-ups\n3 cleans(185/125 lbs)\n6 handstand push-ups\n3 cleans(185/125 lbs)\n9 handstand push-ups\n3 cleans(185/125 lbs)\n12 handstand push-ups\n6 cleans(185/125 lbs)\n15 handstand push-ups\n6 cleans(185/125 lbs)\n18 handstand push-ups\n6 cleans(185/125 lbs)\n21 handstand push-ups\n9 cleans(185/125 lbs)\nEtc., adding 3 reps to the handstand push-up each round, and 3 reps to the clean every 3 rounds.", type: "For time", color: "yellow", id: "330"),
            Workout(name:"OPEN 15.3", typeDescription:"As Many Reps as Possible in 14 mi", description:"7 Muscle-Ups\n50 Wall Balls (20/14 lbs)\n100 Double-Unders", type: "AMRAP", color: "yellow", id: "332"),
            Workout(name:"OPEN 15.2", typeDescription:"AMRAP in 3 min", description:"From 0:00-3:00, 2 rounds of:\n10 Overhead Squats (95/65lbs)\n10 Chest-to-Bar Pull-Ups\nFrom 3:00-6:00, 2 rounds of:\n12 Overhead Squats (95/65lbs)\n12 Chest-to-Bar pull-ups\nFrom 6:00-9:00, 2 rounds of:\n14 Overhead Squats (95/65lbs)\n14 Chest-to-Bar Pull-Ups\nFollow the pattern until you fail to complete both rounds.", type: "AMRAP", color: "yellow", id: "334"),
            Workout(name:"OPEN 15.1", typeDescription:"AMRAP in 9 min", description:"15 Toes-to-Bars\n10 Deadlifts (115/75 lbs)\n5 Snatches (115/75 lbs)\nThen, Open 15.1a: In 6 Minutes\n1-Rep-Max Clean-and-Jerk", type: "AMRAP", color: "yellow", id: "336"),
            
            Workout(name:"OPEN 14.5", typeDescription:"21-18-15-12-9-6-3 Reps For Time", description:"Thrusters (95/65 lb)\nBar Facing Burpees", type: "For time", color: "yellow", id: "338"),
            Workout(name:"OPEN 14.4", typeDescription:"As Many Rounds as Possible in 14 min", description:"60 Calorie Row\n50 Toes-to-Bars\n40 Wall-Ball Shots (20/14 lbs) (10/9 ft target)\n30 Cleans (135 lb)\n20 Muscle-Ups", type: "AMRAP", color: "yellow", id: "340"),
            Workout(name:"OPEN 14.3", typeDescription:"As Many Reps as Possible in 8 min", description:"10 Deadlifts (135/95 lbs)\n15 Box Jumps (24/20 in)\n15 Deadlifts (185/135 lbs)\n15 Box Jumps (24/20 in)\n20 Deadlifts (225/155 lbs)\n15 Box Jumps (24/20 in)\n25 Deadlifts (275/185 lbs)\n15 Box Jumps (24/20 in)\n30 Deadlifts (315/205 lbs)\n15 Box Jumps (24/20 in)\n35 Deadlifts (365/225 lbs)\n15 Box Jumps (24/20 in)", type: "AMRAP", color: "yellow", id: "342"),
            Workout(name:"OPEN 14.2", typeDescription:"AMRAP in 3 min", description:"From 0:00-3:00, 2 rounds of:\n10 Overhead Squats (95/65lbs)\n10 Chest-to-Bar Pull-Ups\nFrom 3:00-6:00, 2 rounds of:\n12 Overhead Squats (95/65lbs)\n12 Chest-to-Bar pull-ups\nFrom 6:00-9:00, 2 rounds of:\n14 Overhead Squats (95/65lbs)\n14 Chest-to-Bar Pull-Ups\nFollow the pattern until you fail to complete both rounds.", type: "AMRAP", color: "yellow", id: "344"),
            Workout(name:"OPEN 14.1", typeDescription:"As Many Reps as Possible in 10 minutes", description:"30 Double-Unders\n15 Power Snatches (75/55 lbs)", type: "AMRAP", color: "yellow", id: "346"),
            
            Workout(name:"OPEN 13.5", typeDescription:"As Many Reps as Possible in 4 min", description:"15 Thrusters (100/65 lbs)\n15 Chest-to-Bar Pull-ups", type: "AMRAP", color: "yellow", id: "348"),
            Workout(name:"OPEN 13.4", typeDescription:"As Many Reps as Possible in 7 min", description:"3 Clean-and-Jerks (135/95 lbs)\n3 Toes-to-Bars\n6 Clean-and-Jerks (135/95 lbs)\n6 Toes-to-Bars\n9 Clean-and-Jerks (135/95 lbs)\n9 Toes-to-Bars\n12 Clean-and-Jerks (135/95 lbs)\n12 Toes-to-Bars\nIf you complete the round of 12, go on to 15. If you complete 15, go on the 18, etc.", type: "AMRAP", color: "yellow", id: "350"),
            Workout(name:"OPEN 13.3", typeDescription:"As Many Reps as Possible in 12 min", description:"150 Wall Balls (20/14lbs)\n90 Double-Unders\n30 Muscle-Ups", type: "AMRAP", color: "yellow", id: "352"),
            Workout(name:"OPEN 13.2", typeDescription:"As Many Reps as Possible in 10 min", description:"5 Shoulder-to-Overheads (115/75 lbs)\n10 Deadlifts (115/75 lbs)\n15 Box Jumps (24/20 in)", type: "AMRAP", color: "yellow", id: "354"),
            Workout(name:"OPEN 13.1", typeDescription:"AMRAP in 17 minutes", description:"40 Burpees\n30 Snatches (75/45 lbs)\n30 Burpees\n30 Snatches (135/75 lbs)\n20 Burpees\n30 Snatches (165/100 lbs)\n10 Burpees\nMax Snatches (210/120 lbs)", type: "AMRAP", color: "yellow", id: "356"),
            
            Workout(name:"OPEN 12.5", typeDescription:"As Many Reps as Possible in 7 min", description:"3 Thrusters (100/65 lbs)\n3 Chest-to-Bar Pull-ups\n6 Thrusters (100/65 lbs)\n6 Chest-to-Bar Pull-ups\n9 Thrusters (100/65 lbs)\n9 Chest-to-Bar Pull-ups\nIf you complete the round of 9, complete a round of 12, then go on to 15, etc.", type: "AMRAP", color: "yellow", id: "358"),
            Workout(name:"OPEN 12.4", typeDescription:"As Many Reps as Possible in 12 min", description:"150 Wall Balls (20/14lbs)\n90 Double-Unders\n30 Muscle-Ups", type: "AMRAP", color: "yellow", id: "360"),
            Workout(name:"OPEN 12.3", typeDescription:"As Many Reps as Possible in 18 min", description:"15 Box Jumps (24/20 in)\n12 Push Press (115/75 lbs)\n9 Toes-to-Bar", type: "AMRAP", color: "yellow", id: "362"),
            Workout(name:"OPEN 12.2", typeDescription:"As Many Reps as Possible in 10 min", description:"30 Snatches (75/45 lbs)\n30 Snatches (135/75 lbs)\n30 Snatches (165/100 lbs)\n30 Snatches (210/120 lbs)\nContinue at this weight until time is up", type: "AMRAP", color: "yellow", id: "364"),
            Workout(name:"OPEN 12.1", typeDescription:"AMRAP in 7 minutes", description:"Burpees", type: "AMRAP", color: "yellow", id: "366"),
            
            Workout(name:"OPEN 11.6", typeDescription:"As Many Reps as Possible in 7 min", description:"3 Thrusters (100/65 lbs)\n3 Chest-to-Bar Pull-ups\n6 Thrusters (100/65 lbs)\n6 Chest-to-Bar Pull-ups\n9 Thrusters (100/65 lbs)\n9 Chest-to-Bar Pull-ups\nIf you complete the round of 9, complete a round of 12, then go on to 15, etc.", type: "AMRAP", color: "yellow", id: "368"),
            Workout(name:"OPEN 11.5", typeDescription:"As Many Reps as Possible in 20 min", description:"5 Power Cleans (145/105 lbs)\n10 Toes-To-Bars\n15 Wall Balls (20/14 lbs) (10 ft)", type: "AMRAP", color: "yellow", id: "370"),
            Workout(name:"OPEN 11.4", typeDescription:"As Many Reps as Possible in 10 min", description:"60 Bar Facing Burpees\n30 Overhead Squats (120/90 lbs)\n10 Muscle-Ups", type: "AMRAP", color: "yellow", id: "372"),
            Workout(name:"OPEN 11.3", typeDescription:"As Many Reps as Possible in 5 min", description:"Squat Clean (165/110 lbs)\nJerk (165/110 lbs)", type: "4", color: "yellow", id: "374"),
            Workout(name:"OPEN 11.2", typeDescription:"As Many Reps as Possible in 15 min", description:"9 Deadlifts (155/100 lbs)\n12 Push-Ups\n15 Box Jumps (24/20 in)", type: "AMRAP", color: "yellow", id: "376"),
            Workout(name:"OPEN 11.1", typeDescription:"AMRAP in 10 min", description:"30 Double-Unders\n15 Power Snatches (75/55 lbs)", type: "AMRAP", color: "yellow", id: "378"),
     
        ]
        
    }

    
}
