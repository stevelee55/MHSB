//
//  ViewController.swift
//  MHSB
//
//  Created by Steve Lee on 8/31/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //Objects
    var dataModel = MainModel()
    
    //Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var attendanceContentLabel: UILabel!
    @IBOutlet weak var guiButton: UIButton!
    @IBOutlet weak var studentsYearSelector: UISegmentedControl!
    @IBOutlet weak var studentsGradeSelector: UISegmentedControl!
    @IBOutlet weak var studentsStatusSelector: UISegmentedControl!
    
    
    //Views
    @IBOutlet weak var attendanceTextGUI: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupTextUI()
    }
    
    func setupTextUI() {
        //Load data.
        dataModel.loadData()
        
        //Loading saved data. Check if any data is saved. If yes, load it as GUI.
        //This probably will not pass only when no data is present in the beginning.
        if dataModel.isLoaded {
            //Use functions from MainModel to get the loaded data and present them
            //on the device.

            
        //No data is present in the system.
        } else {
            displayNoDataSign()
            setImportDate()
            disableControls()
        }
    }
    
    func displayNoDataSign() {
        attendanceTextGUI.contentSize.height = attendanceContentLabel.frame.size.height
        attendanceTextGUI.isScrollEnabled = false
        attendanceContentLabel.text = "No Attendance Sheet Uploaded"
    }
    
    func disableControls() {
        guiButton.isEnabled = false
        studentsYearSelector.isEnabled = false
        studentsGradeSelector.isEnabled = false
        studentsStatusSelector.isEnabled = false
        
    }
    
    func setImportDate() {
        if dataModel.isLoaded {
            //Set date as the saved import date from nsuserdata
            let defaults = UserDefaults.standard
            if let storedImportedDate = defaults.object(forKey: "Imported_Date") as? String {
                dateLabel.text = storedImportedDate
            } else {
                dateLabel.text = "Corrupted Date Data"
            }
        } else {
            //Set date as "No Imported Data"
            dateLabel.text = "No Imported Data"
        }
    }
    
    @IBAction func importCSV(_ sender: Any) {
        performSegue(withIdentifier: "importNewDataSegue", sender: nil)
    }
    
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) {
        //Do something here whenever the previous view is dismissed.
        
    }
    
    //This only getscalled whenever data is imported from email.`
    func functionForTheEmailDummy() {
        
    }
    
    //Function that reloads the text data everytime the scrolllist selector
    //is changed.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

