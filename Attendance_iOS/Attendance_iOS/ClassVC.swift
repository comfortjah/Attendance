//
//  ClassVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class ClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var attendanceTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var instructor: JSON!
    
    var attendanceKeys: [String]!
    var rosterKeys: [String]!
    var theRoster: [String:JSON]!
    
    var classKey: String!
    var attendanceDate: String!
    
    var ref: Firebase!
    
    @IBAction func backAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.scrollView.contentSize.height = 846
        
        self.attendanceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.rosterTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.attendanceKeys = []
        self.rosterKeys = []
        self.theRoster = [:]
        
        let refClass = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey)
        refClass.observeSingleEventOfType(.Value, withBlock:
        { snapshot in
                
            let json = JSON(snapshot.value)
            
            for (key,_) in json["Attendance"]
            {
                self.attendanceKeys.append(key)
            }
            
            self.theRoster = json["Roster"].dictionaryValue
            for (key, _) in json["Roster"]
            {
                self.rosterKeys.append(key)
            }
            
            self.daysLabel.text = json["days"].stringValue
            self.timeLabel.text = "\(json["startTime"].stringValue) to \(json["endTime"].stringValue)"
            self.roomLabel.text = json["room"].stringValue
            
            self.attendanceTableView.reloadData()
            
            self.rosterTableView.reloadData()
        })
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        if(tableView === self.attendanceTableView)
        {
            return UITableViewCellEditingStyle.None
        }
        
        return UITableViewCellEditingStyle.Delete;
    }
    
    //This function is fired when editing cells in the UITableView.
    //It currently only supports deletion.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let studentID = self.rosterKeys[indexPath.row]
            let refStudent = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Roster").childByAppendingPath(studentID)
            
            refStudent.removeValueWithCompletionBlock(
            {
                (error:NSError?, ref:Firebase!) in
                if (error != nil)
                {
                    //alert
                }
                else
                {
                    //When I change from once event to regular listener, firebaes will take care of this
                    self.rosterKeys.removeAtIndex(indexPath.row)
                    self.theRoster.removeValueForKey(studentID)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            })
        }
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView === self.attendanceTableView)
        {
            return self.attendanceKeys.count
        }
        else
        {
            return self.rosterKeys.count
        }
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(tableView === self.attendanceTableView)
        {
            let cell: UITableViewCell = self.attendanceTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            
            cell.textLabel?.text = self.attendanceKeys[indexPath.row]
            
            return cell
        }
        else
        {
            let cell: UITableViewCell = self.rosterTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            
            let key = self.rosterKeys[indexPath.row]
            let student = self.theRoster[key]!
            let firstName = student["lastName"].stringValue
            let lastName = student["firstName"].stringValue
            
            cell.textLabel?.text = "\(lastName), \(firstName)"
            
            return cell
        }
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView === self.attendanceTableView)
        {
            self.attendanceDate = self.attendanceKeys[indexPath.row]
            
            self.performSegueWithIdentifier("toAttendance", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)
    {
        if (segue.identifier == "toSelectStudent")
        {
            let destinationVC:AddStudentVC = segue.destinationViewController as! AddStudentVC
            
            destinationVC.classKey = self.classKey
        }
        else if (segue.identifier == "toAttendance")
        {
            let destinationVC:AttendanceVC = segue.destinationViewController as! AttendanceVC
            destinationVC.classKey = self.classKey
            destinationVC.attendanceDate = self.attendanceDate
        }
    }
}