//
//  AttendanceVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AttendanceVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var attendanceTableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    
    var classKey: String!
    var attendanceDate: String!
    
    var theRoster: JSON!
    var theStudentIDs: [String]!
    var attendanceRecords: [String]!
    
    var ref: Firebase!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.theRoster = JSON("{}")
        self.theStudentIDs = []
        self.attendanceRecords = []
        self.dateLabel.text = self.attendanceDate
        
        ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.attendanceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let refRoster = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Roster")
        
        let refDate = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Attendance").childByAppendingPath(self.attendanceDate)
        
        print(refRoster)
        print(refDate)
        
        refRoster.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                self.theRoster = JSON(snapshot.value)
                
                print("Roster : \(self.theRoster)")
                
                self.attendanceTableView.reloadData()
            })
        
        refDate.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                let json = JSON(snapshot.value)
                
                print("refDate : \(json)")
                
                for (studentID, time) in json
                {
                    self.theStudentIDs.append(studentID)
                    self.attendanceRecords.append(time.stringValue)
                }
                
                print("Student IDs: \(self.theStudentIDs)")
                print("Records: \(self.attendanceRecords)")
                
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
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
}
