import UIKit
import CoreData

class forTimeViewController: UIViewController {
    
    var wodName: String?
    var timeComponent: String?
    var firstExercise: String?
    var secondExercise: String?
    var thirdExercise: String?
    var fourthExercise: String?
    var wodResult: Int?
    var timer : NSTimer?
    var startTime : NSTimeInterval?
    var accumulatedTime = NSTimeInterval()
    var startStopWatch: Bool = true
    var previousTimeIsEmpty: Bool = true
    var previousTime: String?
    var wodResultString: String?
    

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    @IBOutlet weak var startAndStop: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!
    @IBOutlet weak var firstExerciseLabel: UILabel!
    @IBOutlet weak var secondExerciseLabel: UILabel!
    @IBOutlet weak var thirdExerciseLabel: UILabel!
    @IBOutlet weak var fourthExerciseLabel: UILabel!
    
    
    @IBAction func cancelBtn(sender: AnyObject) {
        killTimer()
        dismissVC()
    }
    
    
    @IBAction func saveBtn(sender: AnyObject) {
        
        print("Done")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setWod()
        
        // Prevent Iphone from going idle
        UIApplication.sharedApplication().idleTimerDisabled = true
        saveBtnLabel.enabled = false
        startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        
        
        // Do any additional setup after loading the view.
    }
    
    func setWod() {
        
        
        
        wodNameLabel.text = wodName?.uppercaseString
        timeComponentLabel.text = timeComponent?.uppercaseString
        firstExerciseLabel.text = firstExercise
        secondExerciseLabel.text = secondExercise
        thirdExerciseLabel.text = thirdExercise
        fourthExerciseLabel.text = fourthExercise
    }

    
    func killTimer(){
          timer?.invalidate()
    }
    
    func resetBtn(){
        
        startStopWatch = true
        startAndStop.setTitle("Start", forState: UIControlState.Normal)
        startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
    
    }
    
    
    // Go back on "save"
    func dismissVC(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let vc = segue.destinationViewController as! WodResultTableViewController
            vc.wodName = wodName
            vc.timerUsed = true
            vc.wodResult = wodResult
    }
    
    
     @IBAction func resetBtn(sender: AnyObject) {
     
     timer?.invalidate()
     
     startTime = nil
     accumulatedTime = 0
     currentTime.text = "00:00.00"
        
    resetBtn()
     
     }
    
    @IBAction func startBtn(sender: AnyObject) {
        
        saveBtnLabel.enabled = false
        
        if startStopWatch == true {
            
            saveBtnLabel.enabled = false
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(forTimeViewController.updateTime), userInfo: nil, repeats: true)
            
            startStopWatch = false
            startAndStop.setTitle("Stop", forState: UIControlState.Normal)
            startAndStop.backgroundColor = UIColor(hue: 0.9833, saturation: 0.68, brightness: 0.85, alpha: 1.0)
            
            
        } else {
            
            
            saveBtnLabel.enabled = true
            self.timer!.invalidate()
            self.timer = nil
            
            startStopWatch = true
            startAndStop.setTitle("Start", forState: UIControlState.Normal)
            startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        
        let currentTimeStamp = NSDate.timeIntervalSinceReferenceDate()
        let intervalTime = currentTimeStamp - startTime!
        self.startTime = currentTimeStamp
        self.accumulatedTime += intervalTime
        
        var elapsedTime = self.accumulatedTime
        
        
        let minutes = Int(elapsedTime / 60)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let fraction = Int(elapsedTime * 100)
        
        let timeString = String(format:"%02d:%02d.%02d",minutes,seconds,fraction)
        currentTime.text = timeString
        
        if seconds < 9 {
            wodResultString = "\(minutes)" + ":" + "0\(seconds)"
        } else {
            wodResultString = "\(minutes)" + ":" + "\(seconds)"
        }
        
        wodResult = (minutes * 60) + seconds
        
    }
    
    
    
}
