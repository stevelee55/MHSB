//
//  ViewController.swift
//  MHSB
//
//  Created by Steve Lee on 8/31/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import UIKit



class MainViewController: UIViewController {
    
    var testVar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            updateTextGUI()
    }
    
    func updateTextGUI() {
        //Load data.
        var dataModel = MainModel()
        dataModel.loadData()
        
        //Loading saved data. Check if any data is saved. If yes, load it as GUI.
        //This probably will not pass only when no data is present in the beginning.
        if dataModel.isLoaded {
            //Use functions from MainModel to get the loaded data and present them
            //on the device.

            
        //No data is present in the system.
        } else {
            //Show in the GUI that no data is present and show the button
            //to add data/teach the user how to add data.
            
            print("No Data")
            
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

