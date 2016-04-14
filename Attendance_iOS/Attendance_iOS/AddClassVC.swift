//
//  AddClass.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 4/14/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SwiftyJSON

class AddClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var instructor: JSON!
    var dayChoices: [String]!
    var ref: Firebase!
    var refClasses: Firebase!
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Firebase(url: "https://attendance-cuwcs.firebaseio.com")
        self.refClasses = ref.childByAppendingPath("Classes")
        
        self.scrollView.contentSize.height = 1000
        
        self.dayChoices = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
    }
    
    //======================================
    //            UI Table View            |
    //======================================
    
    //These are the delegate functions for a UITableView
    
    //This function is fired when editing cells in the UITableView.
    //It currently only supports deletion.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    //This function exists to determine the number of cells for the UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dayChoices.count
    }
    
    //This functions exists to determine the data of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.dayChoices[indexPath.row]
        
        return cell
    }
    
    //This function fires when you select a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.blueColor()
        selectedCell.textLabel?.textColor = UIColor.whiteColor()
        //UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    }
    
    //This function fires when you deselect a cell
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
        cellToDeSelect.textLabel?.textColor = UIColor.blackColor()
    }
    
    func alert(message:String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
