import UIKit
import CoreData

class forTimeViewController: UIViewController {
    
    var wodName: String?
    var timeComponent: String?
    var wodDescription: String?
    var wodResult: Int?
    var timer : Timer?
    var startTime : TimeInterval?
    var accumulatedTime = TimeInterval()
    var startStopWatch: Bool = true
    var previousTimeIsEmpty: Bool = true
    var previousTime: String?
    var wodResultString: String?
    var countdownEnabled: Bool = true
    var countdownTimer: Timer?
    var count = 3

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    @IBOutlet weak var startAndStop: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!
    @IBOutlet weak var wodDescriptionView: UITextView!
    
    
    @IBAction func cancelBtn(_ sender: AnyObject) {
        killTimer()
        dismissVC()
    }
    
    
    @IBAction func saveBtn(_ sender: AnyObject) {
        
        print("Done")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setWod()
        
        // Prevent Iphone from going idle
        UIApplication.shared.isIdleTimerDisabled = true
        saveBtnLabel.isEnabled = false
        startAndStop.backgroundColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
        
        
        // Do any additional setup after loading the view.
    }
    
    func setWod() {
        
        wodNameLabel.text = wodName?.uppercased()
        timeComponentLabel.text = timeComponent?.uppercased()
        wodDescriptionView.text = wodDescription
        wodDescriptionView.isEditable = false
    }

    
    func killTimer(){
          timer?.invalidate()
    }
    
    func resetBtn(){
        
        startStopWatch = true
        startAndStop.setTitle("Start", for: UIControlState())
        startAndStop.backgroundColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
    
    }
    
    
    // Go back on "save"
    func dismissVC(){
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let vc = segue.destination as! WodResultTableViewController
            vc.wodName = wodName
            vc.timerUsed = true
            vc.wodResult = wodResult
    }
    
    
     @IBAction func resetBtn(_ sender: AnyObject) {
     
     timer?.invalidate()
     
     startTime = nil
     accumulatedTime = 0
     currentTime.text = "00:00.00"
        
    resetBtn()
     
     }
    
    @IBAction func startBtn(_ sender: AnyObject) {
        
        saveBtnLabel.isEnabled = false
        
        if startStopWatch == true {
            
            if countdownEnabled == true {
                reset.isHidden = true
                startAndStop.isHidden = true
                count = 3
                currentTime.text = "3"
                self.countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(forTimeViewController.countdownTimerFunc), userInfo: nil, repeats: true)
            } else {
            
                startTimer()
            }
            
        } else {
            
            reset.isEnabled = true
            reset.isHidden = false
            saveBtnLabel.isEnabled = true
            self.timer!.invalidate()
            self.timer = nil
            
            startStopWatch = true
            startAndStop.setTitle("Start", for: UIControlState())
            startAndStop.backgroundColor = UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0)
            
        }
        
    }
    
    func startTimer(){
        
        reset.isEnabled = false
        reset.isHidden = true
        saveBtnLabel.isEnabled = false
        self.startTime = Date.timeIntervalSinceReferenceDate
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(forTimeViewController.updateTime), userInfo: nil, repeats: true)
        
        startStopWatch = false
        startAndStop.setTitle("Stop", for: UIControlState())
        startAndStop.backgroundColor = UIColor(red:0.92, green:0.30, blue:0.36, alpha:1.0)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        
        let currentTimeStamp = Date.timeIntervalSinceReferenceDate
        let intervalTime = currentTimeStamp - startTime!
        self.startTime = currentTimeStamp
        self.accumulatedTime += intervalTime
        
        var elapsedTime = self.accumulatedTime
        
        
        let minutes = Int(elapsedTime / 60)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
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
    
    func countdownTimerFunc(){
        switch count {
        case 3:
            currentTime.text = "2"
            count -= 1
        case 2:
            currentTime.text = "1"
            count -= 1
        case 1:
            currentTime.text = "GO!"
            count -= 1
        default:
            countdownTimer?.invalidate()
            startAndStop.isHidden = false
            startTimer()
        }
    }
    
    
    
}
