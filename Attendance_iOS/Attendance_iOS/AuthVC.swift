//
//  AuthVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AuthVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var instructor: JSON!
    var ref: Firebase!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction()
    {
        if(self.isLoginFormValid())
        {
            self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock:
            { error, authData in
                if error != nil
                {
                    // There was an error logging in to this account
                    self.errorLabel.text = "The email and password do not match."
                    
                    self.passwordTextField.text = nil
                }
                else
                {
                    let refInstructors = self.ref.childByAppendingPath("Instructors")
                    refInstructors.observeSingleEventOfType(.Value, withBlock:
                    { snapshot in
                        let json = JSON(snapshot.value)
                        
                        self.instructor = json[authData.uid]
                                
                        self.emailTextField.text = nil
                        self.passwordTextField.text = nil
                                
                        self.performSegueWithIdentifier("toClasses", sender: nil)
                    })
                }
            })
        }
    }
    
    @IBAction func signUpAction()
    {
        
    }
    
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
    
    
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)
    {
        if (segue.identifier == "toClasses")
        {
            let destinationVC:ClassesVC = segue.destinationViewController as! ClassesVC
            
            destinationVC.instructor = self.instructor
        }
    }
    
    //======================================
    //     Text Field Delegate Functions   |
    //======================================
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
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
