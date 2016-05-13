//
//  AddClass.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 5/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This ViewController allows professors to add classes
//  to the attendance system

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
    
    var ref: Firebase!
    var instructor: JSON!
    var dayChoices: [String]!
    var dayValues: [Character]!
    var selectedDays: [Bool]!
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender:AnyObject)
    {
        if(self.isClassFormValid())
        {
            var days = ""
            for i in 0...self.selectedDays.count-1
            {
                if(selectedDays[i].boolValue)
                {
                    days.append(self.dayValues[i])
                }
            }
            
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
            self.addClass(newClass)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.scrollView.contentSize.height = 1050
        
        self.dayChoices = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        self.dayValues = ["M", "T", "W", "R", "F"]
        self.selectedDays = [false, false, false, false, false]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /**
     
     Adds a new class NSDictionary to Classes object in Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - parameters:
        - newClass: The NSDictionary that is added to the firebase database
     
     - version:
     1.0
     
     */
    func addClass(newClass: NSDictionary)
    {
        let classRef = self.ref.childByAppendingPath("Classes").childByAutoId()
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
    
    /**
     
     Validates the new class form
     
     - Author:
     Mike Litman
     
     - returns:
     Bool
     
     - version:
     1.0
     
     */
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
    
    /**
     
     Displays an alert view with a dismiss button and a custom message
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - parameters:
        - message: The custom message to be displayed in the alert view
     
     - version:
     1.0
     
     */
    func alert(message:String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
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
    
    //This function is fired when the Return/Done key is selected
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //This function is fired when touching outside of the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //This function fires when a textField is selected
    func textFieldDidBeginEditing(textField: UITextField)
    {   
        if(textField === self.startTimeTextField)
        {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Time
            textField.inputView = datePicker
            textField.inputAccessoryView = self.createToolbar()
            datePicker.addTarget(self, action: #selector(AddClassVC.startTimeChanged(_:)), forControlEvents: .ValueChanged)
        }
        else if(textField === self.endTimeTextField)
        {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Time
            textField.inputView = datePicker
            textField.inputAccessoryView = self.createToolbar()
            datePicker.addTarget(self, action: #selector(AddClassVC.endTimeChanged(_:)), forControlEvents: .ValueChanged)
        }
        else if(textField === self.crnTextField || textField === self.courseNumberTextField)
        {
            textField.inputAccessoryView = self.createToolbar()
        }
    }
    
    /**
     
     Creates a toolbar with Done and Cancel buttons so users can exit the
     DatePicker
     
     - Author:
     Jake Wert
     
     - returns:
     UIToolbar

     - version:
     1.0
     
     */
    func createToolbar() -> UIToolbar
    {
        let toolbar = UIToolbar()
        toolbar.barStyle = .Default
        toolbar.translucent = true
        toolbar.tintColor = self.view.tintColor
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddClassVC.doneKeyboardAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddClassVC.cancelKeyboardAction))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        return toolbar
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
}
