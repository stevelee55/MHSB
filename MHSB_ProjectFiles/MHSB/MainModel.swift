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
    
    mutating func loadData() {
        //Loading data and seeing if a dataset has already been added. If not,
        //return false.
        let defaults = UserDefaults.standard
        let storedData = defaults.object(forKey: "MHS_Data") as? [Student]
        if storedData != nil {
            isLoaded = true
        } else {
            isLoaded = false
        }
        addNewData()
    }
    
    //Adding new spreadsheet data from email.
    //Change the parameter later when implementing email import feature.
    mutating func addNewData() {
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
    
    mutating func parseCSVFile(rawData: String) {
        /*Parsing*/
        
        //Make this more flexible later on by allowing the user to put
        //the categories in any order they want in the csv file.
        
        print(rawData)
        let separatedByStudents:[String] = rawData.components(separatedBy: "\r");
        
        for studentData in separatedByStudents {
            
            var student: Student = Student()
            let data:[String] = studentData.components(separatedBy: "\t")//Look up what \t is and if it's okay to use instead of ,
            
            if data[0] != "Parade Position" {
                var rankAndLocation:[String] = data[0].components(separatedBy: ".")
                student.rank = Int(rankAndLocation[0])
                student.location = Int(rankAndLocation[1])
                student.lastName = data[1]
                student.firstName = data[2]
                student.instrument = data[3]
                var periodAndGrade:[String]? = data[4].components(separatedBy: ".")//Check what the empty ones signify
                student.period = Int(periodAndGrade![0])
                student.grade = Int((periodAndGrade?.count == 1) ? "0": periodAndGrade![1])
                studentsData.append(student)
                
            }
        }
        //print(studentsData[0].grade)
    }
    
    struct Student {
        var firstName: String? = ""
        var lastName: String? = ""
        var grade: Int? = 0
        var instrument: String? = ""
        var period: Int? = 0
        var rank: Int? = 0
        var location: Int? = 0
    }
    
    /*//This happens when the button is pressed.
    mutating func addData() {
        
    }*/
    
}
