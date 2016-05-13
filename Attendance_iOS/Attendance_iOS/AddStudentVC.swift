//
//  AddStudentVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 5/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AddStudentVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var studentTableView: UITableView!
    
    var ref: Firebase!
    var refStudents: Firebase!
    var handlerStudents: UInt!
    var classKey: String!
    var theStudents: [JSON]!
    var theStudentIDS: [String]!
    
    @IBAction func backAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refStudents = ref.childByAppendingPath("Students")
        
        self.theStudents = []
        self.theStudentIDS = []
        
        self.studentTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //We need to generate a list of students to choose
        self.retrieveAllStudents()
        
        self.studentTableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        self.refStudents.removeObserverWithHandle(self.handlerStudents)
    }
    
    /**
     
     Retrieve the object containing all students from Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func retrieveAllStudents()
    {
        self.handlerStudents = self.refStudents.observeEventType(.Value, withBlock:
        { snapshot in
                
            let json = JSON(snapshot.value)
            
            self.theStudents = []
            self.theStudentIDS = []
            
            for (key, value) in json
            {
                self.theStudentIDS.append(key)
                self.theStudents.append(value)
            }
                
            self.studentTableView.reloadData()
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
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.None;
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.theStudents.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.studentTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let theStudent = self.theStudents[indexPath.row]
        
        cell.textLabel?.text = "\(theStudent["lastName"].stringValue), \(theStudent["firstName"].stringValue)"
        
        return cell
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let theStudent = self.theStudents[indexPath.row]
        
        let refStudent = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Roster").childByAppendingPath(self.theStudentIDS[indexPath.row])
        
        let newStudent = ["firstName":theStudent["firstName"].stringValue, "lastName":theStudent["lastName"].stringValue]
        
        refStudent.setValue(newStudent, withCompletionBlock:
        {
            (error:NSError?, ref:Firebase!) in
            if (error != nil)
            {
                self.alert("Unable to add the student.")
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}