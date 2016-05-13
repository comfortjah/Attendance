//
//  ClassesVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 5/13/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//
//  This ViewController manages the professor's classes


import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class ClassesVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructorLabel: UILabel!
    
    var ref: Firebase!
    var refClasses: Firebase!
    var instructor: JSON!
    var classKey: String!
    var classesJSON: [JSON]!
    var classKeys: [String]!
    var handlerClasses: UInt!
    var count: Int = 0
    
    @IBAction func signOutAction(sender: AnyObject)
    {
        self.ref.unauth()
        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refClasses = ref.childByAppendingPath("Classes")
        
        self.classesJSON = []
        self.classKeys = []
        
        self.instructorLabel.text = "Professor \(self.instructor["lastName"])"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //TODO:
        //Change observer from .Value to .ChildAdded & .ChildRemoved 
        //so that the classes can be sorted by property "className"
        
        self.handlerClasses = self.refClasses.observeEventType(.Value, withBlock:
        { snapshot in
            let json = JSON(snapshot.value)
                
            self.classesJSON = []
            self.classKeys = []
                
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
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        self.classKeys.removeAll()
        self.classesJSON.removeAll()
        
        self.refClasses.removeObserverWithHandle(self.handlerClasses)
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
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    //This function is fired when editing cells in the UITableView.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {   
            let refClass = ref.childByAppendingPath("Classes").childByAppendingPath(self.classKeys[indexPath.row])
            
            refClass.removeValueWithCompletionBlock(
            { (error:NSError?, ref:Firebase!) in
                if (error != nil)
                {
                    self.alert("Unable to delete the class.")
                }
            })
        }
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.classesJSON.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let cellTextStr = "\(self.classesJSON[indexPath.row]["className"]) (\(self.classesJSON[indexPath.row]["days"]) \(self.classesJSON[indexPath.row]["startTime"]))"
        
        cell.textLabel?.text = cellTextStr
        
        return cell
    }
    
    //This function fire when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.classKey = self.classKeys[indexPath.row]
        
        self.performSegueWithIdentifier("toClass", sender: nil)
    }
}
