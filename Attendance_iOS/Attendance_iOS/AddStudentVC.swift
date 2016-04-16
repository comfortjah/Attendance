//
//  AddStudentVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AddStudentVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var studentTableView: UITableView!
    
    var classKey: String!
    var theStudents: [JSON]!
    var theStudentIDS: [String]!
    
    var ref: Firebase!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.theStudents = []
        self.theStudentIDS = []
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.studentTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let refStudents = ref.childByAppendingPath("Students")
        
        refStudents.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                
                let json = JSON(snapshot.value)
                
                for (key, value) in json
                {
                    self.theStudentIDS.append(key)
                    self.theStudents.append(value)
                }
                
                self.studentTableView.reloadData()
        })
        
        self.studentTableView.reloadData()
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
        print("Cell \(indexPath.row) : \(cell.textLabel?.text)")
        
        return cell
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let theStudent = self.theStudents[indexPath.row]
        print("Selected: \(theStudent)")
        
        let refStudent = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey).childByAppendingPath("Roster").childByAppendingPath(self.theStudentIDS[indexPath.row])
        
        let newStudent = ["firstName":theStudent["firstName"].stringValue, "lastName":theStudent["lastName"].stringValue]
        
        refStudent.setValue(newStudent, withCompletionBlock:
        {
            (error:NSError?, ref:Firebase!) in
            if (error != nil)
            {
                print("Data could not be saved.")
            }
            else
            {
                print("Data saved successfully!")
            }
        })
        
        //add the selected student to the class roster
        
        //UNWIND
    }
}