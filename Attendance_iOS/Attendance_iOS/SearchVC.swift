//
//  SearchVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 2/27/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration

class SearchVC: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        print("Text Field Began Editing")
        
        if(textField !== self.classNameTextField)
        {
            let datePicker = UIDatePicker()
            
            // Creates the toolbar
            let toolBar = UIToolbar()
            toolBar.barStyle = .Default
            toolBar.translucent = true
            toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Adds the buttons
            let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneClick")
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelClick")
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            if(textField === self.timeTextField)
            {
                print("Time Text Field")
                datePicker.datePickerMode = UIDatePickerMode.Time
                textField.inputView = datePicker
                textField.inputAccessoryView = toolBar
                datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
                
            }
            else if(textField === self.dateTextField)
            {
                print("Date Text Field")
                datePicker.datePickerMode = UIDatePickerMode.Date
                textField.inputView = datePicker
                textField.inputAccessoryView = toolBar
                datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
            }
        }
        else
        {
            print("Class Name Text Field")
        }
    }
    
    func datePickerChanged(sender: UIDatePicker)
    {
        print("Date Picker was changed")
        if(sender.datePickerMode == UIDatePickerMode.Time)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let strTime = dateFormatter.stringFromDate(sender.date)
            self.timeTextField.text = strTime
        }
        else if(sender.datePickerMode == UIDatePickerMode.Date)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let strDate = dateFormatter.stringFromDate(sender.date)
            self.dateTextField.text = strDate
        }
        else
        {
            print("Error")
        }
    }
    
    func doneClick()
    {
        self.view.endEditing(true)
    }
    
    func cancelClick()
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

