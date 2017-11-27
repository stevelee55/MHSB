//
//  GUIViewController.swift
//  MHSB
//
//  Created by Steve Lee on 11/22/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import UIKit

class GUIViewController: UIViewController {
    
//Objects
    var dataModel = MainModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
    }
    
//Helper Functions
    
    private func setUpGUI() {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
