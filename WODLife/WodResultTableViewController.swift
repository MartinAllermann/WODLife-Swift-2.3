//
//  WodResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodResultTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    
    var wodName: String?
    var wodResult: Int?
    var pickOption:[String] = []
    var pickOption2:[String] = []
    var minutes: Int?
    var seconds: Int?
    var newDate = NSDate()
    let pickerView = UIPickerView()
    var timerUsed: Bool = false
    var elapsedTimeInSeconds: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wodNameLabel.text = wodName
   
        minutes = 0
        seconds = 0
        
        textFieldPlaceholder()
        
        configPickerViews()
        
        if timerUsed == true {
            
            elapsedTimeInSeconds = wodResult
            
             timeTextField.text = secondsToHoursMinutesSeconds(wodResult!)
            
        }
        
        self.timeTextField.becomeFirstResponder()
        
    }
    @IBAction func saveBtn(sender: AnyObject) {
        
        if timeTextField.text!.isEmpty {
            
            elapsedTimeInSeconds = 0
        
        }
    
        saveResult()
    }
    
    
    func saveResult(){
    
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let ent = NSEntityDescription.entityForName("WodResult", inManagedObjectContext: context)
        let Wod = WodResult(entity: ent!, insertIntoManagedObjectContext: context)
        
        let currentDate = NSDate()
        
        Wod.name = wodName
        Wod.time = elapsedTimeInSeconds
        Wod.date = currentDate
        
        do {
            
            try context.save()
            dismissVC()
        } catch {
            return
        }
        
    }
    
    func dismissVC(){
        
        let controller = self.navigationController?.viewControllers[1] // it is at index 1. index start from 0, 1 .. N
        self.navigationController?.popToViewController(controller!, animated: true)
        /*
        navigationController?.popViewControllerAnimated(true)
        */
    }
    
    func textFieldPlaceholder(){
        
        timeTextField.placeholder = "0:00"
    
    }
    
    func configPickerViews(){
        
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.whiteColor()
        
        //Populate array with 59 minutes
        for x in 0...59 {
            pickOption2.append("\(x)")
        }
        
        for i in 0...59 {
            pickOption.append("\(i)")
        }
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.translucent = false
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WodResultTableViewController.donePicker))
        doneButton.tintColor = UIColor.blackColor()
      
        toolBar.setItems([spaceButton1,spaceButton2, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        timeTextField.inputAccessoryView = toolBar
        timeTextField.inputView = pickerView
    
    }
    
    func donePicker() {
        timeTextField.resignFirstResponder()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return pickOption.count
        } else {
            return pickOption2.count
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
        return pickOption[row] + " min"
        } else {
            return pickOption2[row] + " s"
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            minutes = row
        } else {
            seconds = row
            
        }
        
        configTextField()
    }
    
    func configTextField(){
        
        if seconds <= 9 {
            
            timeTextField.text = "\(minutes!)" + ":" + "0\(seconds!)"
            
        }
        
        else {
            
            timeTextField.text = "\(minutes!)" + ":" + "\(seconds!)"
        
        }
        
        elapsedTimeInSeconds = (minutes! * 60) + (seconds)!
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let min: Int?
        let sec: Int?
        
        min = (seconds % 3600) / 60
        sec = (seconds % 3600) % 60
        
        if sec <= 9 {

            return "\(min!)" + ":" + "0\(sec!)"
        }
            
        else {
            
            return "\(min!)" + ":" + "\(sec!)"
            
        }
    }
    
    
}
