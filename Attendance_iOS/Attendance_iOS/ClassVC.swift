//
//  ClassVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/14/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class ClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var rosterTableView: UITableView!
    @IBOutlet var attendanceTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var instructor: JSON!
    
    var attendanceKeys: [String]!
    var rosterKeys: [String]!
    
    var classKey: String!
    
    var ref: Firebase!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        
        self.scrollView.contentSize.height = 846
        
        self.attendanceKeys = []
        self.rosterKeys = []
        
        self.rosterTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.attendanceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let refClass = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey)
        refClass.observeSingleEventOfType(.Value, withBlock:
        { snapshot in
                
            let json = JSON(snapshot.value)
            
            for (key,value) in json["Attendance"]
            {
                self.attendanceKeys.append(key)
            }
            
            for (key, value) in json["Roster"]
            {
                self.rosterKeys.append(key)
            }
            
            self.attendanceTableView.reloadData()
            
            self.rosterTableView.reloadData()
        })
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    //This function is fired when editing cells in the UITableView.
    //It currently only supports deletion.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            //TODO delete item from Firebase
            if(tableView === self.attendanceTableView)
            {
                print("Removed: \(self.attendanceKeys[indexPath.row])")
            }
            else
            {
                print("Removed: \(self.rosterKeys[indexPath.row])")
            }
            
            //items.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView === self.attendanceTableView)
        {
            print("Attendance: \(self.attendanceKeys.count) rows")
            return self.attendanceKeys.count
        }
        else
        {
            print("Roster: \(self.rosterKeys.count) rows")
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
            print("Cell \(indexPath.row) : \(cell.textLabel?.text)")
            
            return cell
        }
        else
        {
            let cell: UITableViewCell = self.rosterTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            
            cell.textLabel?.text = self.rosterKeys[indexPath.row]
            print("Cell \(indexPath.row) : \(cell.textLabel?.text)")
            
            return cell
        }
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView === self.attendanceTableView)
        {
            print("Selected: \(self.attendanceKeys[indexPath.row])")
        }
        else
        {
            print("Selected: \(self.rosterKeys[indexPath.row])")
        }
        
        
        //TODO Prepare for segue to class viewController (pass selectedClass)
    }
}

