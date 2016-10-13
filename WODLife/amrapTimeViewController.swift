//
//  amrapTimeViewController.swift
//  WODLife
//
//  Created by Martin  on 14/08/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit

class amrapTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var startTimerLabel: UIButton!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    @IBOutlet weak var roundCountBtnLabel: UIButton!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    
    var wodName: String?
    var newDate = NSDate()
    var timer : NSTimer?
    var hour = 0
    var minute = 0
    var startTimer: Bool = true
    var roundCount = 0
    var previousRoundsIsEmpty: Bool = true
    var alertController: UIAlertController?
    var hourArray:[String] = []
    var minArray:[String] = []
    var highscore: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        
        timeLeftLabel.hidden = true
        saveBtnLabel.enabled = false
        hourPicker.delegate = self
        hourPicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.dataSource = self
    
        //Populate array with 59 minutes
        for i in 0...59 {
            hourArray.append("\(i)")
        }
        
        for i in 0...59 {
            minArray.append("\(i)")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelBtn(sender: AnyObject) {
        
        //Kill timer on cancel
        timer?.invalidate()
        dismissVC()

    }
    
    @IBAction func saveBtn(sender: AnyObject) {
    }
    
    @IBAction func roundCountBtn(sender: AnyObject) {
        
        roundCount += 1
        roundCountBtnLabel.setTitle("\(roundCount)", forState: UIControlState.Normal)
        roundCountBtnLabel.titleLabel?.font =  UIFont(name: "Helvetica", size: 60)
        saveBtnLabel.enabled = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! WodAMRAPResultsTableViewController
        vc.wodName = wodName
        vc.roundsFromTimer = roundCount
        vc.timerUsed = true
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 1){
            return hourArray[row] + " h"
        }else{
            return minArray[row] + " min"
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if (pickerView.tag == 1){
            return hourArray.count
        }else{
            return minArray.count
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            hour = row
        }else{
            minute = row
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        if (pickerView.tag == 1){
            let titleData = hourArray[row] + " h"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            
            return myTitle
        }else{
            let titleData = minArray[row] + " m"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            
            return myTitle
        }
        
        
    }
    
    @IBAction func startTimerBtn(sender: AnyObject) {
        
        if startTimer == true {
            
            
            let currentDate = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let dateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
            
            let components = NSDateComponents()
            components.year = dateComponents.year
            components.month = dateComponents.month
            components.day = dateComponents.day
            components.weekOfYear = dateComponents.weekOfYear
            components.hour = dateComponents.hour + hour
            components.minute = dateComponents.minute + minute
            components.second = dateComponents.second
            newDate = calendar.dateFromComponents(components)!
            
            setTimeLeft()
            
            // Start timer
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
            
            startTimerLabel.setTitle("STOP", forState: UIControlState.Normal)
            startTimerLabel.backgroundColor = UIColor(hue: 0.9833, saturation: 0.68, brightness: 0.85, alpha: 1.0)
            startTimer = false
            
            
            hourPicker.hidden = true
            minutePicker.hidden = true
            timeLeftLabel.hidden = false
            
        } else if startTimer == false {
            
            timer?.invalidate()
            startTimerLabel.setTitle("START", forState: UIControlState.Normal)
            startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            startTimer = true
            timeLeftLabel.text = "00:00:OO"
            hourPicker.hidden = false
            minutePicker.hidden = false
            timeLeftLabel.hidden = true
            
        }
        
    }
    
    func setTimeLeft() {
        
        let currentDate = NSDate()
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate, toDate: newDate, options: [])
        print(components2.second)
        
        if (components2.second > 0) {
            
            let timeString = String(format:"%02d:%02d:%02d",components2.hour,components2.minute,components2.second)
            timeLeftLabel.text = timeString
            
        } else {
            
            timeIsUp()
            
        }
        
    }
    
    // Need commit
    func timeIsUp(){
        
        timer?.invalidate()
        startTimerLabel.setTitle("Start", forState: UIControlState.Normal)
        startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        startTimer = true
        
        hourPicker.hidden = false
        minutePicker.hidden = false
        timeLeftLabel.hidden = true
        
        alert()
        
    }
    
    func alert(){
        
        //Construct alert view
        alertController = UIAlertController(title: "Time is up", message: "", preferredStyle: .Alert)
        // add an action
        let alertAction = UIAlertAction(title: "Done", style: .Default) {
            
            (action) -> Void in
        }
        alertController!.addAction(alertAction)
        self.presentViewController(alertController!, animated: true, completion: nil)
        
        
        
    }
    
    // Go back on "save"
    func dismissVC(){
        navigationController?.popViewControllerAnimated(true)
        
    }

}
