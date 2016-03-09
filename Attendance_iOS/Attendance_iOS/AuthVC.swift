//
//  ViewController.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 2/27/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration

class AuthVC: UIViewController
{
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //If authToken exists, sign user in
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction()
    {
        let ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        ref.authUser(self.usernameTextField.text, password: self.passwordTextField.text,
            withCompletionBlock:
            { error, authData in
                if error != nil
                {
                    // There was an error logging in to this account
                    
                    self.alert("Username and password do not match.")
                    
                    
                }
                else
                {
                    self.performSegueWithIdentifier("toDashboard", sender: nil)
                }
        })
    }
    
    @IBAction func signUpAction()
    {
        let myRootRef = Firebase(url:"https://attendance-cuwcs.firebaseio.com")
        
        myRootRef.createUser(self.usernameTextField.text, password: self.passwordTextField.text,
            withValueCompletionBlock:
            { error, result in
                if error != nil
                {
                    // There was an error creating the account
                }
                else
                {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                }
        })
    }
    
    func alert(message:String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

