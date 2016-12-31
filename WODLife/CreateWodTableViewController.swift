//
//  CreateWodTableViewController.swift
//  WODLife
//
//  Created by Martin on 28/12/2016.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreData

class CreateWodTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var scoring = "For Time"

    @IBOutlet weak var wodNameText: UITextField!

    @IBOutlet weak var wodTypeText: UITextField!

    @IBOutlet weak var wodDescriptionText: UITextView!

    @IBOutlet weak var scoringInput: UISegmentedControl!
   
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.isEnabled = false
        wodNameText.delegate = self
        wodTypeText.delegate = self
        wodDescriptionText.delegate = self
        wodNameText.addTarget(self, action: #selector(CreateWodTableViewController.txtEditing(textField:)), for: UIControlEvents.editingChanged)
        
        wodNameTextPlaceholder()
        wodTypeTextPlaceholder()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        tableView.delegate = self
    }
    
    func txtEditing(textField: UITextField) {
        let length = wodNameText.text?.characters.count
        if length! > 0 {
            saveBtn.isEnabled = true
        } else {
            saveBtn.isEnabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scoringAction(_ sender: Any) {
        
        switch scoringInput.selectedSegmentIndex {
        case 0:
            scoring = "For time"
        case 1:
            scoring = "AMRAP"
        case 2:
            scoring = "EMON"
        default:
            scoring = "For time"
        }
        
    }
  
 
    @IBAction func saveBtnAction(_ sender: Any) {
        
        if wodTypeText.text!.isEmpty {
        
        wodTypeText.text = scoring
        
        }
        if wodDescriptionText.text.isEmpty {
        
        wodDescriptionText.text = "No Description"
        
        }
        
        saveResult()
    }
    
    
    func saveResult(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let ent = NSEntityDescription.entity(forEntityName: "Wod", in: context)
        let createWod = Wod(entity: ent!, insertInto: context)
        
        let currentDate = Date()
        
        createWod.name = wodNameText.text
        createWod.date = currentDate
        createWod.color = "yellow"
        createWod.typeDescription = wodTypeText.text
        createWod.type = scoring
        createWod.wodDescription = wodDescriptionText.text
        
        do {
            
            try context.save()
            dismissVC()
        } catch {
            return
        }
        
    }
    
    func dismissVC(){
    
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 300;
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 45
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func wodNameTextPlaceholder(){
        
        var placeHolder = NSMutableAttributedString()
        let Name  = "Annie"
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 17.0)!])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range:NSRange(location:0,length:Name.characters.count))
        
        // Add attribute
        wodNameText.attributedPlaceholder = placeHolder
        
    }
   
    func wodTypeTextPlaceholder(){
        
        var placeHolder = NSMutableAttributedString()
        let Name  = "21, 15, 9 reps for time"
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 17.0)!])
        
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range:NSRange(location:0,length:Name.characters.count))
        
        // Add attribute
        wodTypeText.attributedPlaceholder = placeHolder
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica", size: 12)!
        header.textLabel?.textColor = UIColor.groupTableViewBackground
    }
    
}
