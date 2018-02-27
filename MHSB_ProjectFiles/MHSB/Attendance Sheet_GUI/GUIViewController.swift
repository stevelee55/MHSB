//
//  GUIViewController.swift
//  MHSB
//
//  Created by Steve Lee on 11/22/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import UIKit

class GUIViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//Objects
    //When this vc is loaded, "dataModel" is set with the passed in data.
    var dataModel = MainModel()
    //Index for finding which cell to update on the database when one of the
    //buttons are pressed.
    var indexForSelectedCell = 0
    
    //Views on the storyboard.
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var studentInfoView: StudentInfoView!
    @IBOutlet weak var gridBubbleCollectionView: UICollectionView!
    
    //Last Edited Date.
    @IBOutlet weak var editedDateLabel: UILabel!
    //Present, Tardy, and Absent Buttons.
    @IBAction func presentButton(_ sender: UIButton) {
        //Updating/saving the current state of data after the button is pressed.
        dismissStudentInfoView(status: (sender.titleLabel?.text)!, index: indexForSelectedCell)
        dataModel.archieveCurrentData()
        //Saving the edited date and time.
        dataModel.saveCurrentDate(forKey: "Edited_Date")
        editedDateLabel.text = dataModel.storedDateInString(forKey: "Edited_Date")
    }
    //Resetting students' status and date.
    @IBAction func resetButton(_ sender: Any) {
        //Resetting the students' status.
        for i in 0 ... dataModel.studentsData.count - 1 {
            dataModel.studentsData[i].status = "Present"
        }
        gridBubbleCollectionView.reloadData()
        dataModel.archieveCurrentData()
        //Resetting the date by clearing it out.
        dataModel.saveCurrentDate(forKey: "Reset")
        editedDateLabel.text = dataModel.storedDateInString(forKey: "Edited_Date")
    }
    //Setting up point.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGUI()
        //Setting up the blurview
        blurView.effect = UIBlurEffect(style: .regular)
    }
    //Not the best method I think
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpGUI()
        gridBubbleCollectionView.reloadData()
        //Setting up the blurview
        blurView.effect = UIBlurEffect(style: .regular)
    }
    
//Helper Functions
    
    private func setUpGUI() {
        //Disabling both blurview and the student info view.
        studentInfoView.isUserInteractionEnabled = false
        studentInfoView.isHidden = true
        blurView.isHidden = true
        //Setting up the last edited date.
        editedDateLabel.text = dataModel.storedDateInString(forKey: "Edited_Date")
    }
    
    //Prepping before going into another view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    //Not sure what this is for yet.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//UICollectionView Methods
    //Getting the number of elements present total.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        //Have to take account for the empty spots.
        return dataModel.studentsData.count + dataModel.countingEmptySpots()
    }
    //Dynamic UI Generator
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bubbleCell",
                                                      for: indexPath) as! UICollectionViewCellBubble
        //For every position, row is calculated.
        let row = ((indexPath.row + 1) % 9) == 0 ?
            ((indexPath.row + 1) / 9) : ((indexPath.row + 1) / 9 + 1)
        
        //Make this a bit more cleaner if possible.
        for i in 0 ... dataModel.studentsData.count - 1 {
            if (dataModel.studentsData[i].rank == row) {
                if (dataModel.studentsData[i].location == ((indexPath.row + 1) % 9)) {
                    cell.firstName.text = dataModel.studentsData[i].firstName
                    cell.lastName.text = dataModel.studentsData[i].lastName
                    
                    //Setting the background according to the status of the selected student.
                    if (dataModel.studentsData[i].status == "Present") {
                        cell.backgroundColor = UIColor.green
                    } else if (dataModel.studentsData[i].status == "Tardy"){
                        cell.backgroundColor = UIColor.yellow
                    } else if (dataModel.studentsData[i].status == "Absent") {
                        cell.backgroundColor = UIColor.red
                    }
                    //print(i)
                    return cell
                } else if (((indexPath.row + 1) % 9) == 0) {
                    if (dataModel.studentsData[i].location == 9) {
                        cell.firstName.text = dataModel.studentsData[i].firstName
                        cell.lastName.text = dataModel.studentsData[i].lastName
                        
                        //Setting the background according to the status of the selected student.
                        if (dataModel.studentsData[i].status == "Present") {
                            cell.backgroundColor = UIColor.green
                        } else if (dataModel.studentsData[i].status == "Tardy"){
                            cell.backgroundColor = UIColor.yellow
                        } else if (dataModel.studentsData[i].status == "Absent") {
                            cell.backgroundColor = UIColor.red
                        }
                        //print(i)
                        return cell
                    }
                }
            }
        }
        //print("Above cannot be row number")
        cell.firstName.text = ""
        cell.lastName.text = ""
        //See why this has to be set as clear to make sure every spot is clear.
        //Isn't default supposed to be clear?
        cell.backgroundColor = UIColor.clear
        //return default cell with clear background color.
        return cell
    }
    
    //Doing something for each of the elements whenever it's pressed.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Show the detailed info about the selected student by passing in the
        //indexPath and getting the info that we need.
        //What's useful here is the indexPath which can be used to update the
        //database. The updateing should be done this way since the the
        //collection view is constantly updated throughout the whole time.
        
        //Getting the location of the selected cell for animation.
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes?.frame
        let cellFrameInSuperview = collectionView.convert(cellRect!, from: collectionView.superview)
        displayStudentInfoView(indexPath: indexPath, cellLocationInfo: cellFrameInSuperview)
    }
    
    //Displaying bubble view with the passed in cell info by path.
    func displayStudentInfoView(indexPath: IndexPath, cellLocationInfo: CGRect) {
        //Disabling the collectionview.
        gridBubbleCollectionView.isUserInteractionEnabled = false
        //Putting up the blurView and the student info view.
        blurView.isHidden = false
        studentInfoView.isHidden = false
        studentInfoView.isUserInteractionEnabled = true
        //Update the database and call the update function of the collection view.
        displayStudentInfo(indexPath: indexPath, cellLocationInfo: cellLocationInfo)
    }
    func displayStudentInfo(indexPath: IndexPath, cellLocationInfo: CGRect) {
        //Animating Initialization.
        studentInfoView.alpha = 0
        blurView.alpha = 0
//        studentInfoView.frame.size = cellLocationInfo.size
//        studentInfoView.center = cellLocationInfo.origin
        
        //Variables needed.
        var studentData = Student()
        
        //Make this faster by defining the data array in the order of the
        //positions, like heap or something.
        //This method goes through every element until finding the element.
        
        //For every position, row is calculated.
        let row = ((indexPath.row + 1) % 9) == 0 ?
            ((indexPath.row + 1) / 9) : ((indexPath.row + 1) / 9 + 1)
        let location = ((indexPath.row + 1) % 9)
                                                                                    //Doble check if this works by testing edge cases.
        for i in 0 ... dataModel.studentsData.count - 1 {
            if ((dataModel.studentsData[i].rank == row)
                && (dataModel.studentsData[i].location == location)) {
                studentData = dataModel.studentsData[i]
                indexForSelectedCell = i
                break
            } else if (location == 0) {
                if ((dataModel.studentsData[i].rank == row)
                    && (dataModel.studentsData[i].location == 9)) {
                    studentData = dataModel.studentsData[i]
                    indexForSelectedCell = i
                    break
                }
            }
        }
        //Getting the data from the database.
        studentInfoView.status.text = studentData.status
        studentInfoView.firstName.text = "First Name: " + studentData.firstName!
        studentInfoView.lastName.text = "Last Name: " + studentData.lastName!
        studentInfoView.instrument.text = "Instrument: " + studentData.instrument!
        studentInfoView.grade.text = "Grade: " + String(describing: studentData.grade!)
        studentInfoView.period.text = "Period: " + String(describing: studentData.period!)
        studentInfoView.location.text = "Location: " + String(describing: studentData.location!)
        
        //Animating.
        UIView.animate(withDuration: 0.18, animations: {
            self.studentInfoView.alpha = 1
            self.blurView.alpha = 1
//            self.studentInfoView.center = (self.view.superview?.convert(self.view.center, to: self.studentInfoView.superview))!
//            self.studentInfoView.frame.size = CGSize.init(width: 414, height: 414)
        }, completion: nil)
    }
    
    //This could be replaced with pressing a button, getting the decision
    //of the student's status, updating the database, and getting rid of the
    //info view.
    func dismissStudentInfoView(status: String, index: Int){
        
        //Updating the data from the data base.
        dataModel.studentsData[index].status = status
        //Updating the collection view after modifying the data.
        gridBubbleCollectionView.reloadData()
        
        //Animating.
        UIView.animate(withDuration: 0.18, animations: {
            self.studentInfoView.alpha = 0
            self.blurView.alpha = 0
        }, completion: { (finished: Bool) in
            self.blurView.isHidden = true
            self.studentInfoView.isUserInteractionEnabled = false
            self.studentInfoView.isHidden = true
            self.gridBubbleCollectionView.isUserInteractionEnabled = true
            self.gridBubbleCollectionView.isHidden = false
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        })
        //Whenever the bubble gets dismissed or appear, make sure to save the data
        //to the database. Saving can be done by using the passed indexPath to find the
        //index at which the element is at.
        //This updated database will later be passed on.
    }
}
