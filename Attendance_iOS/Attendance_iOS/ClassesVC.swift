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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructorLabel: UILabel!
    
    var instructor: JSON!
    var classKey: String!
    var classesJSON: [JSON]!
    var classKeys: [String]!
    
    var ref: Firebase!
    var refClasses: Firebase!
    
    @IBAction func signOutAction(sender: AnyObject)
    {
        self.ref.unauth()
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refClasses = ref.childByAppendingPath("Classes")
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.classesJSON = []
        self.classKeys = []
        
        self.refClasses.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                let json = JSON(snapshot.value)
                for (key, value) in json
                {
                    if(value["instructor"] == self.instructor)
                    {
                        self.classKeys.append(key)
                        self.classesJSON.append(value)
                    }
                }
                
                let instructorText = "Professor \(self.instructor["lastName"])"
                self.instructorLabel.text = instructorText
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
            
            let refClass = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKey)
            
            refClass.removeValueWithCompletionBlock(
            { (error:NSError?, ref:Firebase!) in
                if (error != nil)
                {
                    self.alert("Unable to delete the class.")
                }
                else
                {
                    //When I change from once event to regular listener, firebaes will take care of this
                    self.classKeys.removeAtIndex(indexPath.row)
                    self.classesJSON.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            })
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
        else if(segue.identifier == "toAddClass")
        {
            let destinationVC:AddClassVC = segue.destinationViewController as! AddClassVC
            
            destinationVC.instructor = self.instructor
        }
     }
    
    func alert(message:String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
