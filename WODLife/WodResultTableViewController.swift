//
//  WodResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class WodResultTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate{

    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var wodName: String?
    var wodResult: Int?
    var pickOption:[String] = []
    var pickOption2:[String] = []
    var minutes: Int?
    var seconds: Int?
    var newDate = Date()
    let pickerView = UIPickerView()
    var timerUsed: Bool = false
    var elapsedTimeInSeconds: Int?
    
    var editMode: Bool = false
    var timeToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(editMode)
        
        wodNameLabel.text = wodName
        notesTextView.delegate = self
   
        minutes = 0
        seconds = 0
        
        textFieldPlaceholder()
        
        configPickerViews()
        
        if timerUsed == true {
            
            elapsedTimeInSeconds = wodResult
            
             timeTextField.text = secondsToHoursMinutesSeconds(wodResult!)
            
        }
        
        if editMode == true {
        
            elapsedTimeInSeconds = timeToEdit
            
            timeTextField.text = secondsToHoursMinutesSeconds(timeToEdit!)
            
            notesTextView.text = notesToEdit
        
        }
        
    }
    @IBAction func saveBtn(_ sender: AnyObject) {
        
        if timeTextField.text!.isEmpty {
            
            elapsedTimeInSeconds = 0
        
        }
    
        if editMode == false {
            
            saveResult()
        
        } else {
            
            updateResult()
        
        }
        
    }
    
    
    func saveResult(){
    
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let ent = NSEntityDescription.entity(forEntityName: "WodResult", in: context)
        let Wod = WodResult(entity: ent!, insertInto: context)
        
        let currentDate = Date()
        
        Wod.name = wodName
        Wod.time = elapsedTimeInSeconds as NSNumber?
        Wod.date = currentDate
        Wod.notes = notesTextView.text
        
        do {
            
            try context.save()
            dismissVC()
        } catch {
            return
        }
        
    }
    
    func updateResult() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WodResult")
        request.predicate = NSPredicate(format: "name = %@ && date == %@", wodName!, dateToEdit! as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                let time = elapsedTimeInSeconds as NSNumber?
                res.setValue(time, forKey: "time")
                res.setValue(notesTextView.text, forKey: "notes")
                
                
                try con.save()
                dismissVC()
            }
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func dismissVC(){
        
        let controller = navigationController?.viewControllers[1] // it is at index 1. index start from 0, 1 .. N
      let _ = navigationController?.popToViewController(controller!, animated: true)
        /*
        navigationController?.popViewControllerAnimated(true)
        */
    }
    
    func textFieldPlaceholder(){
        
        timeTextField.placeholder = "0:00"
        var placeHolder = NSMutableAttributedString()
        let Name  = "0:00"
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 17.0)!])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range:NSRange(location:0,length:Name.characters.count))
        
        // Add attribute
        timeTextField.attributedPlaceholder = placeHolder
    
    }
    
    func configPickerViews(){
        
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        
        //Populate array with 59 minutes
        for x in 0...59 {
            pickOption2.append("\(x)")
        }
        
        for i in 0...59 {
            pickOption.append("\(i)")
        }
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.white
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WodResultTableViewController.donePicker))
        doneButton.tintColor = UIColor.black
      
        toolBar.setItems([spaceButton1,spaceButton2, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return pickOption.count
        } else {
            return pickOption2.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
        return pickOption[row] + " min"
        } else {
            return pickOption2[row] + " s"
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (String) {
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
    
   override func viewDidAppear(_ animated: Bool) {
        self.timeTextField.becomeFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 200;
    }
    
}
