//
//  WodAMRAPResultTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/07/2016. Swift 3
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class WodAMRAPResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
   
    @IBOutlet weak var roundsTextField: UITextField!
    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var saveBtnLabel: UIBarButtonItem!
   
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var wodTypeLabel: UILabel!

    @IBOutlet weak var dateInput: UITextField!
    
    var wodName: String?
    var wodType: String?
    var roundsFromTimer: Int?
    var newDate = Date()
    var timerUsed: Bool = false
    var editMode: Bool = false
    var datePicker = UIDatePicker()
    var roundsToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    var dateToFetch: Date?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wodNameLabel.text = wodName
        textFieldPlaceholder()
        datePlaceholder()
        dateToFetch = dateToEdit
        
        dateInput.inputView = datePicker
        datePicker.addTarget(self, action: #selector(WodAMRAPResultsTableViewController.updateDateTxt), for: UIControlEvents.valueChanged)

        
        roundsTextField.addTarget(self, action: #selector(CreateWodTableViewController.txtEditing(textField:)), for: UIControlEvents.editingChanged)
 
        roundsTextField.delegate = self
        notesView.delegate = self
        
     
 
        if wodType == "For load" {
        
        wodTypeLabel.text = "Weight"
        
        } else {
        
        wodTypeLabel.text = "Rounds"
        
        }
        
        if timerUsed == true {
            
            if wodType == "For load" {
                
                roundsTextField.text = "0"
                
            } else {
                
                roundsTextField.text = "\(roundsFromTimer!)"
                
            }
        
        }
        
        if (editMode == true){
        
            roundsTextField.text = "\(roundsToEdit!)"
        
            notesView.text = notesToEdit
 
        
        }
    
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
 
        if roundsTextField.text?.isEmpty == true {
        
        saveBtnLabel.isEnabled = false
        
        }
        
    }
    
    @IBAction func saveB(_ sender: AnyObject) {
        
        if roundsTextField.text!.isEmpty {
        roundsTextField.text = "0"
        }
        
        if notesView.text!.isEmpty {
        
        notesView.text = "None"
            
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
      
        Wod.name = wodName
        let roundsInt:NSNumber? = Int(roundsTextField.text!) as NSNumber?

        if (wodType == "For load" ) {
            Wod.weight = roundsInt
        } else {
            Wod.rounds = roundsInt!
        
        }
        
        Wod.date = getDate()
        Wod.notes = notesView.text
        
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
                
                let roundsInt:NSNumber? = Int(roundsTextField.text!) as NSNumber?
                
                if wodType == "For load" {
                     res.setValue(roundsInt, forKey: "weight")
                } else {
                     res.setValue(roundsInt, forKey: "rounds")
                }
                
                res.setValue(notesView.text, forKey: "notes")
                res.setValue(getDate(), forKey: "date")
        
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
    }
    
    func textFieldPlaceholder(){
        
        roundsTextField.placeholder = "0"
        
        var placeHolder = NSMutableAttributedString()
        let Name  = "0"
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 17.0)!])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range:NSRange(location:0,length:Name.characters.count))
        
        // Add attribute
        roundsTextField.attributedPlaceholder = placeHolder
        
    }
    
    func datePlaceholder(){
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateInput.text = dateFormatter.string(from: getDate())
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 200;
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica", size: 12)!
        header.textLabel?.textColor = UIColor.groupTableViewBackground
    }
    
    func txtEditing(textField: UITextField) {

        if roundsTextField.text?.isEmpty == true {
            saveBtnLabel.isEnabled = false
        } else {
            saveBtnLabel.isEnabled = true
        }
        
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
        dateToEdit = datePicker.date
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateInput.text = dateFormatter.string(from: datePicker.date)
    }
    

}
