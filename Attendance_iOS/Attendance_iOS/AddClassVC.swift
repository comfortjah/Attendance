//
//  AddClass.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AddClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var crnTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var instructor: JSON!
    var dayChoices: [String]!
    var dayValues: [Character]!
    var selectedDays: [Bool]!
    var ref: Firebase!
    var refClasses: Firebase!
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender:AnyObject)
    {
        if(self.isClassFormValid())
        {
            var days = ""
            for i in 0...selectedDays.count-1
            {
                if(selectedDays[i].boolValue)
                {
                    days.append(self.dayValues[i])
                }
            }
            
            //set value in firebase
            let classRef = ref.childByAppendingPath("Classes").childByAutoId()
            let newClass =
                [
                    "CRN":self.crnTextField.text!,
                    "className":"CSC\(self.courseNumberTextField.text!)",
                    "instructor":
                        [
                            "firstName":self.instructor["firstName"].stringValue,
                            "lastName":self.instructor["lastName"].stringValue
                    ],
                    "room":"\(self.buildingTextField.text!) \(self.roomNumberTextField.text!)",
                    "days":days, "startTime":self.startTimeTextField.text!,
                    "endTime":self.endTimeTextField.text!
            ]
            
            classRef.setValue(newClass, withCompletionBlock:
                {
                    (error:NSError?, ref:Firebase!) in
                    if (error != nil)
                    {
                        self.alert("Unable to create the class.")
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func isClassFormValid() -> Bool
    {
        if(self.crnTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter the CRN Number."
        }
        else if(self.buildingTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter the building."
        }
        else if(self.roomNumberTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter the room number."
        }
        else if(self.courseNumberTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter the course number."
        }
        else if(!self.selectedDays.contains(true))
        {
            self.errorLabel.text = "Please select the days the class meets."
        }
        else if(self.startTimeTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please select a start time."
        }
        else if (self.endTimeTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please select an end time."
        }
        else
        {
            self.errorLabel.text = ""
            return true
        }
        
        return false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refClasses = ref.childByAppendingPath("Classes")
    
        self.scrollView.contentSize.height = 1050
        
        self.dayChoices = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        self.dayValues = ["M", "T", "W", "R", "F"]
        self.selectedDays = [false, false, false, false, false]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    //This function is fired when editing cells in the UITableView.
    //It currently only supports deletion.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dayChoices.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.dayChoices[indexPath.row]
        
        return cell
    }
    
    //This function fires when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = self.view.tintColor
        selectedCell.textLabel?.textColor = UIColor.whiteColor()
        self.selectedDays[indexPath.row] = true
    }
    
    //This function fires when you deselect a cell
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
        cellToDeSelect.textLabel?.textColor = UIColor.blackColor()
        self.selectedDays[indexPath.row] = false
    }
    
    //======================================
    //     Text Field Delegate Functions   |
    //======================================
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {   
        if(textField === self.startTimeTextField)
        {
            // Creates the toolbar
            let toolBar = UIToolbar()
            toolBar.barStyle = .Default
            toolBar.translucent = true
            toolBar.tintColor = self.view.tintColor
            toolBar.sizeToFit()
            
            // Adds the buttons
            let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddClassVC.doneKeyboardAction))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddClassVC.cancelKeyboardAction))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Time
            textField.inputView = datePicker
            textField.inputAccessoryView = toolBar
            datePicker.addTarget(self, action: #selector(AddClassVC.startTimeChanged(_:)), forControlEvents: .ValueChanged)
        }
        else if(textField === self.endTimeTextField)
        {
            // Creates the toolbar
            let toolBar = UIToolbar()
            toolBar.barStyle = .Default
            toolBar.translucent = true
            toolBar.tintColor = self.view.tintColor
            toolBar.sizeToFit()
            
            // Adds the buttons
            let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddClassVC.doneKeyboardAction))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddClassVC.cancelKeyboardAction))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Time
            textField.inputView = datePicker
            textField.inputAccessoryView = toolBar
            datePicker.addTarget(self, action: #selector(AddClassVC.endTimeChanged(_:)), forControlEvents: .ValueChanged)
        }
        else if(textField === self.crnTextField || textField === self.roomNumberTextField || textField === self.courseNumberTextField)
        {
            // Creates the toolbar
            let toolBar = UIToolbar()
            toolBar.barStyle = .Default
            toolBar.translucent = true
            toolBar.tintColor = self.view.tintColor
            toolBar.sizeToFit()
            
            // Adds the buttons
            let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddClassVC.doneKeyboardAction))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddClassVC.cancelKeyboardAction))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            textField.inputAccessoryView = toolBar
        }
    }
    
    func startTimeChanged(sender: UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.startTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func endTimeChanged(sender: UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.endTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneKeyboardAction()
    {
        self.view.endEditing(true)
    }
    
    func cancelKeyboardAction()
    {
        self.view.endEditing(true)
    }
    
    func alert(message:String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
