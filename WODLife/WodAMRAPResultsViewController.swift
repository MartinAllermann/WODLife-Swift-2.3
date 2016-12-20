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

    var wodName: String?
    var roundsFromTimer: Int?
    var newDate = Date()
    var timerUsed: Bool = false
    
    var editMode: Bool = false
    var roundsToEdit: Int?
    var notesToEdit: String?
    var dateToEdit: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(editMode)
        
        wodNameLabel.text = wodName
        textFieldPlaceholder()
 
        roundsTextField.delegate = self
        notesView.delegate = self

 
        
        if timerUsed == true {
        
            roundsTextField.text = "\(roundsFromTimer!)"
        
        }
        
        if (editMode == true){
        
            roundsTextField.text = "\(roundsToEdit!)"
        
            notesView.text = notesToEdit!
 
        
        }
    
        self.roundsTextField.becomeFirstResponder()
 
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
        
        let currentDate = Date()
      
        Wod.name = wodName
        
        let roundsInt:NSNumber? = Int(roundsTextField.text!) as NSNumber?
        Wod.rounds = roundsInt!
        Wod.date = currentDate
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
        request.predicate = NSPredicate(format: "name = %@ && date == %@", wodName!, dateToEdit! as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try con.fetch(request) as! [WodResult]
            for res in results {
                
                let roundsInt:NSNumber? = Int(roundsTextField.text!) as NSNumber?
                res.setValue(roundsInt, forKey: "rounds")
                res.setValue(notesView.text, forKey: "notes")
        
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
}
