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
    @IBOutlet weak var studentsPeriodSelector: UISegmentedControl!
    @IBOutlet weak var studentsStatusSelector: UISegmentedControl!
    @IBOutlet weak var lastEditedDateLabel: UILabel!
    
    
//Views
    @IBOutlet weak var attendanceTextGUI: UIScrollView!
    

//Setup
    override func viewDidLoad() {
        super.viewDidLoad()
            setupTextUI()
    }
    
//Segments
    
    //Fix this after asking Cotter ("0")
    @IBAction func studentsYearSegmentsNoti(_ sender: UISegmentedControl) {
        var tempGradeForCotter = sender.selectedSegmentIndex
        if tempGradeForCotter == 0 {
            tempGradeForCotter = -1
        } else if tempGradeForCotter == 5 {
            tempGradeForCotter = 0
        }
        setDataInText(grade:  String(tempGradeForCotter),
                      period: String(studentsPeriodSelector.selectedSegmentIndex),
                      status: studentsStatusSelector.selectedSegmentIndex == 0 ? "All" : String(studentsStatusSelector.selectedSegmentIndex == 1 ? "Present" : String(studentsStatusSelector.selectedSegmentIndex == 2 ? "Tardy" : "Absent")))
    }
    @IBAction func studentsPeriodSegmentsNoti(_ sender: UISegmentedControl) {
        var tempGradeForCotter = studentsYearSelector.selectedSegmentIndex
        if tempGradeForCotter == 0 {
            tempGradeForCotter = -1
        } else if tempGradeForCotter == 5 {
            tempGradeForCotter = 0
        }
        setDataInText(grade: String(tempGradeForCotter),
                      period: String(sender.selectedSegmentIndex),
                      status: studentsStatusSelector.selectedSegmentIndex == 0 ? "All" : String(studentsStatusSelector.selectedSegmentIndex == 1 ? "Present" : String(studentsStatusSelector.selectedSegmentIndex == 2 ? "Tardy" : "Absent")))
    }
    @IBAction func studentsStatusSegmentsNoti(_ sender: UISegmentedControl) {
        var tempGradeForCotter = studentsYearSelector.selectedSegmentIndex
        if tempGradeForCotter == 0 {
            tempGradeForCotter = -1
        } else if tempGradeForCotter == 5 {
            tempGradeForCotter = 0
        }
        
        setDataInText(grade: String(tempGradeForCotter),
                      period: String(studentsPeriodSelector.selectedSegmentIndex),
                      status: sender.selectedSegmentIndex == 0 ? "All" : String(sender.selectedSegmentIndex == 1 ? "Present" : String(sender.selectedSegmentIndex == 2 ? "Tardy" : "Absent")))
    }
    
//Segue

    @IBAction func presentGUI(_ sender: Any) {
        performSegue(withIdentifier: "presentGUISegue", sender: nil)
        
    }
    
    @IBAction func importCSV(_ sender: Any) {
        performSegue(withIdentifier: "importNewDataSegue", sender: nil)
        
        //TEST Importing Data
        dataModel.addNewData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentGUISegue" {
            let toVC = segue.destination as! GUIViewController
            toVC.dataModel.studentsData = dataModel.studentsData
        } else if segue.identifier == "importNewDataSegue" {
            
        }
    }
    
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindImportNewDataSegue" {
            
        } else if segue.identifier == "unwindPresentGUISegue" {
            lastEditedDateLabel.text = dataModel.storedDateInString(forKey: "Edited_Date")
        }
    }
    
//Helper Functions
    
    private func setupTextUI() {
        //Load data.
        dataModel.loadData()
        
        //Loading saved data. Check if any data is saved. If yes, load it as GUI.
        //This probably will not pass only when no data is present in the beginning.
        if dataModel.isLoaded {
            //Use functions from MainModel to get the loaded data and present them
            //on the device.
            setImportDate()
            //Setting the edited date.
            lastEditedDateLabel.text = dataModel.storedDateInString(forKey: "Edited_Date")
            
            //setDataInText(grade: "All", period: "All", status: "All")
            setDataInText(grade: "All", period: "All", status: "All")
            
            //No data is present in the system.
        } else {
            displayNoDataSign()
            disableControls()
        }
    }
    
    private func setDataInText(grade: String, period: String, status: String) {
        
        let arrangedDataInText = arrangeDataInTextFormat(grade: grade == "All" ? -1 : Int(grade)!, period: period == "All" ? 0 : Int(period)!, status: status)
        
        attendanceContentLabel.numberOfLines = arrangedDataInText.1
        attendanceContentLabel.text = arrangedDataInText.0
        attendanceContentLabel.sizeToFit()
        attendanceContentLabel.frame.size = CGSize(width: attendanceTextGUI.frame.size.width, height: attendanceContentLabel.frame.size.height)
        
        attendanceTextGUI.contentSize = attendanceContentLabel.frame.size
    }
    
    private func arrangeDataInTextFormat(grade: Int, period: Int, status: String) -> (String, Int) {
        var dataInText:String = ""
        var lineCount: Int = 0
        /*
         var filteredList: [Student] = dataModel.studentsData
        
        
        //Make this better. This is way too inefficient. Using Index -1 could be the key.
        if grade != -1 {
            var index = 0
            for studentData in filteredList {
                if studentData.grade != grade {
                    filteredList.remove(at: index)
                } else {
                    index += 1
                }
            }
        }
        if period != 0 {
            var index = 0
            for studentData in filteredList {
                if studentData.period != period {
                    filteredList.remove(at: index)
                } else {
                    index += 1
                }
            }
        }
        if status != "All" {
            var index = 0
            for studentData in filteredList {
                if studentData.status != status {
                    filteredList.remove(at: index)
                } else {
                    index += 1
                }
            }
        }
     */
        
        for studentData in dataModel.studentsData {
            
            if ((grade == -1 ? true : (studentData.grade == grade ? true : false)) && (period == 0 ? true : (studentData.period == period ? true : false)) && (status == "All" ? true : (studentData.status == status ? true : false))) {
                //Ask What he wants.
                let oneStudentsData = "\(studentData.firstName!) \(studentData.lastName!), Year: \(studentData.grade!), Period: \(studentData.period!), Instrument: \(studentData.instrument!), Rank: \(studentData.rank!),  Location: \(studentData.location!) \n\n "
                dataInText.append(oneStudentsData)
                lineCount += 3 //This is to account for the line spacing.
            }
        }
        let numberOfStudentsCount = "Count: \(lineCount / 3) \n\n"
        dataInText.append(numberOfStudentsCount)
        lineCount += 3 //This is for the count at the bottom.
        return (dataInText, lineCount)
    }
    
    private func displayNoDataSign() {
        attendanceTextGUI.contentSize.height = attendanceContentLabel.frame.size.height
        attendanceTextGUI.isScrollEnabled = false
        attendanceContentLabel.text = "No Attendance Sheet Uploaded"
    }
    
    private func disableControls() {
        guiButton.isEnabled = false
        studentsYearSelector.isEnabled = false
        studentsPeriodSelector.isEnabled = false
        studentsStatusSelector.isEnabled = false
        
    }
    
    private func setImportDate() {
        dateLabel.text = dataModel.storedDateInString(forKey: "Imported_Date")
    }
    
    //This only getscalled whenever data is imported from email.`
    private func functionForTheEmailDummy() {
        
    }
    
    //Function that reloads the text data everytime the scrolllist selector
    //is changed.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

