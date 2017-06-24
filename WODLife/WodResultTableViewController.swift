//
//  WodResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

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


class WodResultTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var wodNameLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var dateTxt: UITextField!
    
    var wodName: String?
    var wodResult: Int?
    var pickOption:[String] = []
    var pickOption2:[String] = []
    let dateFormatter = DateFormatter()
    var minutes: Int?
    var seconds: Int?
    var newDate = Date()
    let pickerView = UIPickerView()
    let pickerDateView = UIDatePicker()
    var timerUsed: Bool = false
    var elapsedTimeInSeconds: Int?
    
    var editMode: Bool = false
    var timeToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    var dateToFetch: Date?
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wodNameLabel.text = wodName
        notesTextView.delegate = self
        dateToFetch = dateToEdit
       
        minutes = 0
        seconds = 0
        
        textFieldPlaceholder()
        datePlaceholder()
        
        configPickerViews()
        configDatePicker()
        
        if timerUsed == true {
            
            elapsedTimeInSeconds = wodResult
            
             timeTextField.text = secondsToHoursMinutesSeconds(wodResult!)
            
        }
        
        if editMode == true {
        
            elapsedTimeInSeconds = timeToEdit
            
            timeTextField.text = secondsToHoursMinutesSeconds(timeToEdit!)
            
            notesTextView.text = notesToEdit
        
        }
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
         pickerDateView.addTarget(self, action: #selector(WodResultTableViewController.updateDateTxt), for: UIControlEvents.valueChanged)
    }
    
    
    @IBAction func saveBtn(_ sender: AnyObject) {
        
        Analytics.logEvent("Save_Button", parameters: nil)
        
        if timeTextField.text!.isEmpty {
            
            elapsedTimeInSeconds = 0
        }
        if notesTextView.text!.isEmpty {
            
            notesTextView.text = "No notes"
            
        }
        
        if (elapsedTimeInSeconds != 0) {
        
            if editMode == false {
                
                saveResult()
                
            } else {
                
                updateResult()
                
            }
        } else{
        alert()
        }
    }
    
    
    func saveResult(){
    
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let ent = NSEntityDescription.entity(forEntityName: "WodResult", in: context)
        let Wod = WodResult(entity: ent!, insertInto: context)
        
        
        Wod.name = wodName
        Wod.time = elapsedTimeInSeconds as NSNumber?
        Wod.date = getDate()
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
        request.predicate = NSPredicate(format: "name = %@ && date == %@", wodName!, dateToFetch! as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                let time = elapsedTimeInSeconds as NSNumber?
                res.setValue(time, forKey: "time")
                res.setValue(notesTextView.text, forKey: "notes")
                res.setValue(dateToEdit, forKey: "date")
                
                
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
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTxt.placeholder = dateFormatter.string(from: getDate())
        
        var placeHolder = NSMutableAttributedString()
        let Name  = "0:00"
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 17.0)!])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.16, green:0.70, blue:0.48, alpha:1.0), range:NSRange(location:0,length:Name.characters.count))
        
        // Add attribute
        timeTextField.attributedPlaceholder = placeHolder
     
    }
    
    func datePlaceholder(){
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTxt.text = dateFormatter.string(from: getDate())
        
    }
    
    func configPickerViews(){
        
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        pickerDateView.datePickerMode = .date
        
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
        dateTxt.inputView = pickerDateView
        timeTextField.inputView = pickerView
    }
    
    func configDatePicker(){
        
        pickerDateView.backgroundColor = UIColor.white
        
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
        return pickOption[row] + " m"
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 200;
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica", size: 12)!
        header.textLabel?.textColor = UIColor.groupTableViewBackground
    }
    
    func getDate() -> Date{
        
        if dateToEdit != nil {
            return dateToEdit!
        } else {
            let currentDate = Date()
            return currentDate
        }
    }
    
    func updateDateTxt(){
        dateToEdit = pickerDateView.date
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTxt.text = dateFormatter.string(from: pickerDateView.date)
    }
    
    func alert(){
        //Construct alert view
        alertController = UIAlertController(title: "Please enter score", message: "", preferredStyle: .alert)
        // add an action
        let alertAction = UIAlertAction(title: "Done", style: .default) {
            
            (action) -> Void in
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
