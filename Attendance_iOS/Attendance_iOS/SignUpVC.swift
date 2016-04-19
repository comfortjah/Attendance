//
//  SignUpVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This class manages the account creation process
//  that takes place in its perspective View Controller.

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class SignUpVC: UIViewController
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: Firebase!
    var instructor: JSON!
    
    @IBAction func backAction()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpAction()
    {
        if(self.isSignUpFormValid())
        {
            self.createUser()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.instructor = JSON("{}")
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)
    {
        if(segue.identifier == "signedUp")
        {
            let destinationVC:ClassesVC = segue.destinationViewController as! ClassesVC
            
            destinationVC.instructor = self.instructor
        }
    }
    
    /**
     
     Validates the sign up form
     
     - Author:
     Mike Litman
     
     - returns:
     Bool
     
     - version:
     1.0
     
     */
    func isSignUpFormValid() -> Bool
    {
        if(self.firstNameTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter your first name."
        }
        else if(self.lastNameTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter your last name."
        }
        else if(self.emailTextField.text?.characters.count == 0)
        {
            self.errorLabel.text = "Please enter your email."
        }
        else if(!self.isEmailValid(self.emailTextField.text!))
        {
            self.errorLabel.text = "Please enter a valid email."
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
     
     Authenticates the newly created user
     
     - Author:
     Maxim Shoustin (http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift)
     
     - returns:
     Bool
     
     - parameters:
        - emailAddress: The email address checked for validity
     
     - version:
     1.0
     
     */
    func isEmailValid(emailAddress: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailAddress)
    }
    
    /**
     
     Creates an account for the new user in Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func createUser()
    {
        self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text,
                            withValueCompletionBlock:
            { error, result in
                if error != nil
                {
                    // There was an error creating the account
                    if(error.code == -9)
                    {
                        self.errorLabel.text = "An account already exists with that email."
                    }
                    else
                    {
                        self.errorLabel.text = "Unable to create your account."
                    }
                }
                else
                {
                    let uid = result["uid"] as! String
                    
                    self.authUser(uid)
                }
        })
    }
    
    /**
     
     Authenticates the newly created user
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - parameters:
        - uid: The user id that is retrieved upon signing up
     
     - important:
     If this function does not succeed, the user will have to contact the administrator to delete his or her account and then create a new one.
     
     - version:
     1.0
     
     */
    func authUser(uid: String)
    {
        self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text,
                          withCompletionBlock:
            { error, authData in
                if error != nil
                {
                    self.alert("Unable to fully create your account. Please contact the administrator, have your account deleted, and try again.")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    self.createInstructor(uid)
                }
        })
    }
    
    /**
     
     Creates a record of the new instructor's account in Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - parameters:
        - uid: The user id that is retrieved upon signing up
     
     - important:
     If this function does not succeed, the user will have to contact the administrator to delete his or her account and then create a new one.
     
     - version:
     1.0
     
     */
    func createInstructor(uid: String)
    {
        let newInstructor = self.ref.childByAppendingPath("Instructors").childByAppendingPath(uid)
        let instructor: [String:String] = ["firstName":self.firstNameTextField.text!, "lastName":self.lastNameTextField.text!]
        
        newInstructor.setValue(instructor, withCompletionBlock:
            {
                (error:NSError?, ref:Firebase!) in
                if (error != nil)
                {
                    self.alert("Unable to fully create your account. Please contact the administrator, have your account deleted, and try again.")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    self.instructor = JSON(instructor)
                    self.performSegueWithIdentifier("signedUp", sender: nil)
                }
        })
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
}
