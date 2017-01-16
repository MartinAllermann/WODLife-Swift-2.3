//
//  amrapTimeViewController.swift
//  WODLife
//
//  Created by Martin  on 14/08/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import AVFoundation

class amrapTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var startTimerLabel: UIButton!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    @IBOutlet weak var roundCountBtnLabel: UIButton!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var timeComponentLabel: UILabel!

    @IBOutlet weak var wodDescriptionView: UITextView!
    
    var wodName: String?
    var timeComponent: String?
    var wodType: String?
    var wodDescription: String?
    var newDate = Date()
    var timer : Timer?
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
        setWod()

        // Prevent Iphone from going idle
        UIApplication.shared.isIdleTimerDisabled = true
        startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        
        timeLeftLabel.isHidden = true
        saveBtnLabel.isEnabled = false
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelBtn(_ sender: AnyObject) {
        
        //Kill timer on cancel
        timer?.invalidate()
        dismissVC()

    }
    
    @IBAction func saveBtn(_ sender: AnyObject) {
    }
    
    @IBAction func roundCountBtn(_ sender: AnyObject) {
        
        roundCount += 1
        roundCountBtnLabel.setTitle("\(roundCount)", for: UIControlState())
        roundCountBtnLabel.titleLabel?.font =  UIFont(name: "Helvetica", size: 75)
        
        if (timeLeftLabel.isHidden == true){
            saveBtnLabel.isEnabled = true
        } else {
            saveBtnLabel.isEnabled = false
        }
    }
    
    func setWod() {
        
        wodNameLabel.text? = (wodName?.uppercased())!
        timeComponentLabel.text = timeComponent?.uppercased()
        wodDescriptionView.text? = wodDescription!
        wodDescriptionView.isEditable = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! WodAMRAPResultsTableViewController
        vc.wodName = wodName
        vc.wodType = wodType
        vc.roundsFromTimer = roundCount
        vc.timerUsed = true

    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 1){
            return hourArray[row] + " h"
        }else{
            return minArray[row] + " min"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if (pickerView.tag == 1){
            return hourArray.count
        }else{
            return minArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            hour = row
        }else{
            minute = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        if (pickerView.tag == 1){
            let titleData = hourArray[row] + " h"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            return myTitle
        }else{
            let titleData = minArray[row] + " m"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            return myTitle
        }
        
        
    }
    
    @IBAction func startTimerBtn(_ sender: AnyObject) {
        
        if startTimer == true {
            
            saveBtnLabel.isEnabled = false
            let currentDate = Date()
            let calendar = Calendar.current
            let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.nanosecond], from: currentDate)
            
            var components = DateComponents()
            components.year = dateComponents.year
            components.month = dateComponents.month
            components.day = dateComponents.day
            components.weekOfYear = dateComponents.weekOfYear
            components.hour = dateComponents.hour! + hour
            components.minute = dateComponents.minute! + minute
            components.second = dateComponents.second
            newDate = calendar.date(from: components)!
            
            setTimeLeft()
            
            // Start timer
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
            
            startTimerLabel.setTitle("Stop", for: UIControlState())
            startTimerLabel.backgroundColor = UIColor(hue: 0.9833, saturation: 0.68, brightness: 0.85, alpha: 1.0)
            startTimer = false
            
            
            hourPicker.isHidden = true
            minutePicker.isHidden = true
            timeLeftLabel.isHidden = false
            
        } else if startTimer == false {
            
            saveBtnLabel.isEnabled = true
            timer?.invalidate()
            startTimerLabel.setTitle("Start", for: UIControlState())
            startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
            startTimer = true
            timeLeftLabel.text = "00:00:00"
            hourPicker.isHidden = false
            minutePicker.isHidden = false
            timeLeftLabel.isHidden = true
            
        }
        
    }
    
    func setTimeLeft() {
        
        let currentDate = Date()
        let calendar2 = Calendar.current
        let components2 = (calendar2 as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.nanosecond], from: currentDate, to: newDate, options: [])
        
        if (components2.second! > 0 || components2.minute! > 0 || components2.hour! > 0) {
            
            let timeString = String(format:"%02d:%02d:%02d",components2.hour!,components2.minute!,components2.second!)
            timeLeftLabel.text = timeString
            saveBtnLabel.isEnabled = false
            
        } else {
            
            timeIsUp()
            
        }
        
    }
    
    // Need commit
    func timeIsUp(){
        
        alert()
        playSound()
        
        saveBtnLabel.isEnabled = true
        timeLeftLabel.isHidden = true
        hourPicker.isHidden = false
        minutePicker.isHidden = false
        
        timer?.invalidate()
        startTimerLabel.setTitle("Start", for: UIControlState())
        startTimerLabel.backgroundColor = UIColor(hue: 0.4583, saturation: 0.7, brightness: 0.73, alpha: 1.0)
        startTimer = true
        
    }
    
    func alert(){
        //Construct alert view
        alertController = UIAlertController(title: "Time is up", message: "", preferredStyle: .alert)
        // add an action
        let alertAction = UIAlertAction(title: "Done", style: .default) {
            
            (action) -> Void in
        }
        alertController!.addAction(alertAction)
        self.present(alertController!, animated: true, completion: nil)
        
    }
    
    func playSound(){
        
        // create a sound ID, in this case its the tweet sound.
        let systemSoundID: SystemSoundID = 1005
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    // Go back on "save"
    func dismissVC(){
        let _ = navigationController?.popViewController(animated: true)
    }

}
