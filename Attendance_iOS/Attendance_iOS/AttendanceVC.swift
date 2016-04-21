//
//  AttendanceVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This ViewController displays the selected date's 
//  attendance records

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AttendanceVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var attendanceTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var ref: Firebase!
    var classKey: String!
    var attendanceDate: String!
    var theRoster: JSON!
    var theStudentIDs: [String]!
    var attendanceRecords: [String]!
    
    @IBAction func backAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dateLabel.text = self.attendanceDate
        
        ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.attendanceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.theRoster = JSON("{}")
        self.theStudentIDs = []
        self.attendanceRecords = []
        
        //Retrieve the roster so that we can get the last names via their IDs
        self.retrieveRoster()
        self.retrieveAttendance()
    }
    
    /**
     
     Retrieves the roster object of the selected class session from Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func retrieveRoster()
    {
        let refRoster = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Roster")
        
        refRoster.observeSingleEventOfType(.Value, withBlock:
        { snapshot in
            self.theRoster = JSON(snapshot.value)
                
            self.attendanceTableView.reloadData()
        })
    }
    
    /**
     
     Retrieves the class session's attendance object from Firebase
     
     - Author:
     Jake Wert
     
     - returns:
     void
     
     - version:
     1.0
     
     */
    func retrieveAttendance()
    {
        let refDate = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Attendance").childByAppendingPath(self.attendanceDate)
        
        refDate.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                let json = JSON(snapshot.value)
                
                for (studentID, time) in json
                {
                    self.theStudentIDs.append(studentID)
                    self.attendanceRecords.append(time.stringValue)
                }
                
                self.attendanceTableView.reloadData()
        })
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
        return self.theStudentIDs.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.attendanceTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let studentID = self.theStudentIDs[indexPath.row]
        let student = self.theRoster[studentID]
        
        let theText = "\(student["lastName"]), \(student["firstName"]) - \(self.attendanceRecords[indexPath.row])"
        
        cell.textLabel?.text = theText
        
        return cell
    }
}
