//
//  DashboardVC.swift
//  Attendance_iOS
//
//  Created by Jake Wert on 3/2/16.
//  Copyright © 2016 Jake Wert. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration

class DashboardVC: UIViewController
{
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var classButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var timeButton: UIButton!
    var currentSearchButton: UIButton!
    
    let ref = Firebase(url:"https:attendance-cuwcs.firebaseio.com")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.searchBar.backgroundImage = UIImage()
        
        self.classButton.layer.borderWidth = 1.0
        self.dateButton.layer.borderWidth = 1.0
        self.timeButton.layer.borderWidth = 1.0
        
        let blue = UIColor(red:0/255.0, green:128/255.0, blue:255/255.0, alpha: 1.0).CGColor
        
        self.classButton.layer.borderColor = blue
        self.dateButton.layer.borderColor = blue
        self.timeButton.layer.borderColor = blue
        
        self.currentSearchButton = self.classButton
        self.searchBar.placeholder = "Class Name (CSC 150)"
        self.classButton.backgroundColor = UIColor(red:0/255.0, green:128/255.0, blue:255/255.0, alpha: 1.0)
        self.classButton.setTitleColor(UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0), forState: .Normal)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func classAction()
    {
        if(self.currentSearchButton != self.classButton)
        {
            self.changeSearchCriteria(self.classButton, searchCriteria: "Class Name (CSC 150)")
        }
    }
    
    @IBAction func dateAction()
    {
        if(self.currentSearchButton != self.dateButton)
        {
            self.changeSearchCriteria(self.dateButton, searchCriteria: "Date (1/1/11)")
        }
    }
    
    @IBAction func timeAction()
    {
        if(self.currentSearchButton != self.timeButton)
        {
            self.changeSearchCriteria(self.timeButton, searchCriteria: "Time (14:35)")
        }
    }
    
    func changeSearchCriteria(toButton: UIButton, searchCriteria: String)
    {
        let blue = UIColor(red:0/255.0, green:128/255.0, blue:255/255.0, alpha: 1.0)
        let white = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0)
        
        self.currentSearchButton.setTitleColor(blue, forState: .Normal)
        self.currentSearchButton.backgroundColor = white
        
        self.searchBar.placeholder = searchCriteria
        toButton.backgroundColor = blue
        toButton.setTitleColor(white, forState: .Normal)
        
        self.currentSearchButton = toButton
    }
}
