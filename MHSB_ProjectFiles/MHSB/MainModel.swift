//
//  MainModel.swift
//  MHSB
//
//  Created by Steve Lee on 9/1/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import Foundation
import CoreData

struct MainModel {

    var studentsData = [Student]()
    var isLoaded = Bool()
    
    struct Student {
        var firstName: String? = ""
        var lastName: String? = ""
        var grade: Int? = 0
        var instrument: String? = ""
        var period: Int? = 0
        var rank: Int? = 0
        var location: Int? = 0
    }
    
//Public Functions
    
    //The only way to add data is to add from the email. When the button is pressed, it will either show the instruction or redirect to the email app.
    //So, I just have to update the system data (updateSystemData) whenever the app is launched
    
    public mutating func loadData() {
        //Loading data and seeing if a dataset has already been added. If not,
        //return false.
        let defaults = UserDefaults.standard
        if let storedData = defaults.object(forKey: "MHS_Data") as? [Student] {
            isLoaded = true
            updateSystemData()
        } else {
            isLoaded = false
        }
    }
    
    //This should run whenever the data is loaded from email. This should be called first and save the data into the "MHS_Data" then the loadData should be called.
    //Adding new spreadsheet data from email.
    //Change the parameter later when implementing email import feature.
    public mutating func addNewData() {
        //This is where the imported file from the email is passed in.
        
        //Dummy values.
        //TEMPPPPPPPPPPPPPP
        let path = Bundle.main.path(forResource: "MHS_0", ofType: "csv")
        let rawCSVData = try! String.init(contentsOf: URL.init(fileURLWithPath: path!))

        parseCSVFile(rawData: rawCSVData)
        
        /*//Converting CSV file to String
        let csvURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "csv")!)
        
        do {
            rawCSVData = try String(contentsOf: csvURL as URL);
            //print("Imported Data" + "\(rawCSVData)");
        } catch {
            print("Corrupted File");
        }*/
    }
    
    
    
//Private Functions
    
    //This function should be called after the data that's being passed isn't nil.
    private mutating func updateSystemData() {
        
    }

    private mutating func parseCSVFile(rawData: String) {
        /*Parsing*/
        
        //Make this more flexible later on by allowing the user to put
        //the categories in any order they want in the csv file.
        
        //print(rawData)
        let separatedByStudents:[String] = rawData.components(separatedBy: "\r");
        
        for studentData in separatedByStudents {
            
            var student: Student = Student()
            let data:[String] = studentData.components(separatedBy: "\t")//Look up what \t is and if it's okay to use instead of ,
            
            if data[0] != "Parade Position" {
                //Separating whole number and tenth digit by separating them in string. Not the best method.
                var rankAndLocation:[String] = data[0].components(separatedBy: ".")
                student.rank = Int(rankAndLocation[0])
                student.location = Int(rankAndLocation[1])
                student.lastName = data[1]
                student.firstName = data[2]
                student.instrument = data[3]
            
                //Separating whole number and tenth digit by separating them in string. Not the best method.
                var periodAndGrade:[String]? = data[4].components(separatedBy: ".")//Check what the empty ones signify
                student.period = Int(periodAndGrade![0])
                student.grade = Int((periodAndGrade?.count == 1) ? "0": periodAndGrade![1])
                studentsData.append(student)
                
            }
        }
        //print(studentsData[0].period)
    }
}
