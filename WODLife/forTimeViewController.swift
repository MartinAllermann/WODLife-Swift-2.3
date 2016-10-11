import UIKit
import CoreData

class forTimeViewController: UIViewController {
    
    var wodName: String?
    var wodResult: String?
    var timer : NSTimer?
    var startTime : NSTimeInterval?
    var accumulatedTime = NSTimeInterval()
    var startStopWatch: Bool = true
    var previousTimeIsEmpty: Bool = true
    var previousTime: String?

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    @IBOutlet weak var startAndStop: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBAction func cancelBtn(sender: AnyObject) {
        timer?.invalidate()
        dismissVC()
    }
    
    
    

    @IBAction func saveBtn(sender: AnyObject) {
        
        
    }
    
    // Go back on "save"
    func dismissVC(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let vc = segue.destinationViewController as! WodResultTableViewController
            vc.wodName = wodName
            vc.timerUsed = true
            vc.wodResult = wodResult!
    }
    
    
     @IBAction func resetBtn(sender: AnyObject) {
     
     timer?.invalidate()
     
     startTime = nil
     accumulatedTime = 0
     currentTime.text = "00:00.00"
     
     startStopWatch = true
     startAndStop.setTitle("START", forState: UIControlState.Normal)
     startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
     }
    
    @IBAction func startBtn(sender: AnyObject) {
        
        saveBtnLabel.enabled = true
        
        if startStopWatch == true {
            
            
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(forTimeViewController.updateTime), userInfo: nil, repeats: true)
            
            startStopWatch = false
            startAndStop.setTitle("STOP", forState: UIControlState.Normal)
            startAndStop.backgroundColor = UIColor(hue: 0.9833, saturation: 0.68, brightness: 0.85, alpha: 1.0)
            
            
        } else {
            
            
            
            self.timer!.invalidate()
            self.timer = nil
            
            startStopWatch = true
            startAndStop.setTitle("START", forState: UIControlState.Normal)
            startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtnLabel.enabled = false
         startAndStop.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        
        // Do any additional setup after loading the view.
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
        
        
        let minutes = UInt8(elapsedTime / 60)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)
        
        let timeString = String(format:"%02d:%02d.%02d",minutes,seconds,fraction)
        currentTime.text = timeString
        
        let wodResultString = "\(minutes)" + ":" + "0\(seconds)"
        wodResult = wodResultString
        
        print(timeString)
        
    }
    
    
    
}
