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
                }
                else
                {
                    // We are now logged in
                    print("We logged in")
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
}

