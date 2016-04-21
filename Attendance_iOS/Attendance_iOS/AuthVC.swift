//
//  AuthVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This class manages the account authentication process
//  that takes place in its perspective View Controller.

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AuthVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: Firebase!
    var instructor: JSON!
    
    @IBAction func loginAction()
    {
        if(self.isLoginFormValid())
        {
            self.authUser()
        }
    }
    
    @IBAction func signUpAction()
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.instructor = JSON("{}")
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)
    {
        if (segue.identifier == "toClasses")
        {
            let destinationVC:ClassesVC = segue.destinationViewController as! ClassesVC
            
            destinationVC.instructor = self.instructor
        }
    }
    
    /**
     
     Authenticates the user
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func authUser()
    {
        self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock:
            { error, authData in
                if error != nil
                {
                    self.errorLabel.text = "The email and password do not match."
                    
                    self.passwordTextField.text = nil
                }
                else
                {
                    self.retrieveInstructor(authData.uid)
                }
        })
    }
    
    /**
     
     Retrieves the user's instructor object
     
     - Author:
     Jake Wert
     
     - parameters:
        - uid: The user id string that is retrieved upon logging in
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func retrieveInstructor(uid: String)
    {
        let refInstructors = self.ref.childByAppendingPath("Instructors")
        refInstructors.observeSingleEventOfType(.Value, withBlock:
        { snapshot in
            let json = JSON(snapshot.value)
            
            self.instructor = json[uid]
            
            self.emailTextField.text = nil
            self.passwordTextField.text = nil
                
            self.performSegueWithIdentifier("toClasses", sender: nil)
        })
    }
    
    /**
     
     Validates the login form
     
     - Author:
     Mike Litman
     
     - returns:
     Bool
     
     - version:
     1.0
     
     */
    func isLoginFormValid() -> Bool
    {
        if(self.emailTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter your email address."
        }
        else if(self.passwordTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter your password."
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
    //     Text Field Delegate Functions   |
    //======================================
    
    //Fires when pressing the 'Done' button on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if(textField === self.emailTextField)
        {
            self.passwordTextField.becomeFirstResponder()
        }
        else if(textField === self.passwordTextField)
        {
            textField.resignFirstResponder()
            self.loginAction()
        }
        return true
    }
    
    //Fires when a touch is made outside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
