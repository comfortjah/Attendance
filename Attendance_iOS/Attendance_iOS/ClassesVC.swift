//
//  ClassesVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class ClassesVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    
    var instructor: JSON!
    var classKey: String!
    var classesJSON: [JSON]!
    var classKeys: [String]!
    
    var ref: Firebase!
    var refClasses: Firebase!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refClasses = ref.childByAppendingPath("Classes")
        
        self.classesJSON = []
        self.classKeys = []
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.refClasses.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                let json = JSON(snapshot.value)
                for (key, value) in json
                {
                    //for each class (key is some hash, value is JSON obj with properties)
                    if(value["instructor"] == self.instructor)
                    {
                        self.classKeys.append(key)
                        self.classesJSON.append(value)
                    }
                }
                self.tableView.reloadData()
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
            print("Removed: \(self.classesJSON[indexPath.row]["className"].stringValue)")
            //items.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("\(String(self.classesJSON.count)) rows")
        return self.classesJSON.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let cellTextStr = "\(self.classesJSON[indexPath.row]["className"]) (\(self.classesJSON[indexPath.row]["days"]) \(self.classesJSON[indexPath.row]["startTime"]))"
        
        cell.textLabel?.text = cellTextStr
        
        print("Cell \(indexPath.row) : \(cell.textLabel?.text)")
        
        return cell
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //TODO selectedClass = self.items[indexPath.row]
        print("Selected: \(self.classesJSON[indexPath.row])")
        self.classKey = self.classKeys[indexPath.row]
        
        //TODO Prepare for segue to class viewController (pass selectedClass)
        self.performSegueWithIdentifier("toClass", sender: nil)
    }
    
     override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)
     {
        if (segue.identifier == "toClass")
        {
            let destinationVC:ClassVC = segue.destinationViewController as! ClassVC
     
            destinationVC.instructor = self.instructor
            destinationVC.classKey = self.classKey
        }
     }
}
