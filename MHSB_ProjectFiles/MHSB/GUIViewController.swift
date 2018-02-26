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
    
    @IBOutlet weak var bbv: BigBubbleView!
    @IBOutlet weak var gridBubbleCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
        bbv.addGestureRecognizer(gestureSwift2AndHigher)
    }
    
//Helper Functions
    
    private func setUpGUI() {
        //UICollectionView setup stuff for delgation and protocols.
        
        //See when I should design the elements.
        
        //The bbv shouldn't be visible.
        bbv.isUserInteractionEnabled = false
        bbv.isHidden = true
        
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
        //See why this has to be set as clear to make sure every spot is clear.
        //Isn't default supposed to be clear?
        cell.backgroundColor = UIColor.clear
        return cell //return default cell
    }
    
    //Doing something for each of the elements whenever it's pressed.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Selected cell with the path.
        let cell = collectionView.cellForItem(at: indexPath) as! UICollectionViewCellBubble
        
        if (cell.backgroundColor == UIColor.gray) {
            showBigBubbleInfo(collectionView, indexPath: indexPath)
            cell.backgroundColor = UIColor.red
        } else if (cell.backgroundColor == UIColor.red) {
            cell.backgroundColor = UIColor.gray
        }
        
    }
    
    //Displaying bubble view with the passed in cell info by path.
    func showBigBubbleInfo(_ collectionView: UICollectionView, indexPath: IndexPath) {
        gridBubbleCollectionView.isUserInteractionEnabled = false
        gridBubbleCollectionView.isHidden = true
        bbv.isHidden = false
        bbv.isUserInteractionEnabled = true
        let cell = collectionView.cellForItem(at: indexPath) as! UICollectionViewCellBubble
        bbv.firstName.text = cell.firstName.text
//        let newWidthAndHeight = self.view.frame.size.height / 4
//        let newFrameOfTheBubbleRespectToTheViewFrame:CGRect = CGRect(origin: self.view.center, size: CGSize(width: newWidthAndHeight, height: newWidthAndHeight))
//        let infoBubble:UIView = UIView(frame: newFrameOfTheBubbleRespectToTheViewFrame)
//        infoBubble.center = self.view.center
//        //Should create a class of uiview that is bubble that displays name and
//        //things on the bubble automatically when the indexPath is passed.
//        infoBubble.backgroundColor = UIColor.blue
//        self.view.addSubview(infoBubble)
//        self.view.bringSubview(toFront: infoBubble)
//        let label:UILabel = UILabel(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: infoBubble.frame.size))
//        let cell = collectionView.cellForItem(at: indexPath) as! UICollectionViewCellBubble
//        label.text = cell.firstName.text
//        label.backgroundColor = UIColor.white
//        label.font = UIFont(name: "Calbri", size: 400)
//        print(cell.firstName)
//        infoBubble.addSubview(label)
//        infoBubble.bringSubview(toFront: label)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){

        bbv.isUserInteractionEnabled = false
        bbv.isHidden = true
        gridBubbleCollectionView.isUserInteractionEnabled = true
        gridBubbleCollectionView.isHidden = false
    }
}
