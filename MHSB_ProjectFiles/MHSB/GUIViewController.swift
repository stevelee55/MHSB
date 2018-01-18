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
    //When this vc is loaded, "dataModel" is set with the data.
    var dataModel = MainModel()
    
    @IBOutlet weak var gridBubbleCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
    }
    
//Helper Functions
    
    private func setUpGUI() {
        //UICollectionView setup stuff for delgation and protocols.
        
        //See when I should design the elements. 
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//UICollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Have to take account for the empty spots.
        return dataModel.studentsData.count + dataModel.countingEmptySpots()
    }

    //Dynamic UI Generator
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bubbleCell", for: indexPath) as! UICollectionViewCellBubble
        //For every position, row is calculated.
        let row = ((indexPath.row + 1) % 9) == 0 ? ((indexPath.row + 1) / 9) : ((indexPath.row + 1) / 9 + 1)
        
        //Make this a bit more cleaner if possible.
        for i in 0 ... dataModel.studentsData.count - 1 {
            if (dataModel.studentsData[i].rank == row) {
                if (dataModel.studentsData[i].location == ((indexPath.row + 1) % 9)) {
                    cell.firstName.text = dataModel.studentsData[i].firstName
                    cell.lastName.text = dataModel.studentsData[i].lastName
                    cell.backgroundColor = UIColor.gray
                    print(i)
                    return cell
                } else if (((indexPath.row + 1) % 9) == 0) {
                    if (dataModel.studentsData[i].location == 9) {
                        cell.firstName.text = dataModel.studentsData[i].firstName
                        cell.lastName.text = dataModel.studentsData[i].lastName
                        cell.backgroundColor = UIColor.gray
                        //print(i)
                        return cell
                    }
                }
            }
        }
        //print("Above cannot be row number")
        cell.firstName.text = ""
        cell.lastName.text = ""
        cell.backgroundColor = UIColor.red
        return cell //return default cell
    }
    
}
