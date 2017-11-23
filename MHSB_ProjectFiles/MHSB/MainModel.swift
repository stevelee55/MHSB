//
//  MainModel.swift
//  MHSB
//
//  Created by Steve Lee on 9/1/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import Foundation
import CoreData

class Student: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(instrument, forKey: "instrument")
        aCoder.encode(period, forKey: "period")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(status, forKey: "status")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let _firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let _lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let _grade = aDecoder.decodeObject(forKey: "grade") as? Int
        let _instrument = aDecoder.decodeObject(forKey: "instrument") as? String
        let _period = aDecoder.decodeObject(forKey: "period") as? Int
        let _rank = aDecoder.decodeObject(forKey: "rank") as? Int
        let _location = aDecoder.decodeObject(forKey: "location") as? Int
        let _status = aDecoder.decodeObject(forKey: "status") as? String
        self.init(_firstName: _firstName!, _lastName: _lastName!, _grade: _grade!, _instrument: _instrument!, _period: _period!, _rank: _rank!, _location: _location!, _status: _status!)
    }
    
    init(_firstName: String, _lastName: String, _grade: Int, _instrument: String, _period: Int, _rank: Int, _location: Int, _status: String) {
        self.firstName = _firstName
        self.lastName = _lastName
        self.grade = _grade
        self.instrument = _instrument
        self.period = _period
        self.rank = _rank
        self.location = _location
        self.status = _status
    }
    
    override init() {}
    
    var firstName: String? = ""
    var lastName: String? = ""
    var grade: Int? = 0
    var instrument: String? = ""
    //Ask him about he period how some of them have borken ones.
    var period: Int? = 0
    var rank: Int? = 0
    var location: Int? = 0
    var status: String? = ""
}

struct MainModel {

    var studentsData = [Student]()
    var isLoaded = Bool()
    
//Public Functions
    
    //The only way to add data is to add from the email. When the button is pressed, it will either show the instruction or redirect to the email app.
    //So, I just have to update the system data (updateSystemData) whenever the app is launched
    
    public mutating func loadData() {
        //Loading data and seeing if a dataset has already been added. If not,
        //return false.
        let defaults = UserDefaults.standard
        
        if let archievedStudentsData  = defaults.object(forKey: "MHS_Data") as? Data {
            let storedStudentsData = NSKeyedUnarchiver.unarchiveObject(with: archievedStudentsData) as! [Student]
            studentsData = storedStudentsData
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
        //This is where the file is imported from email. Get the raw data from it and pass it to the function.
        let path = Bundle.main.path(forResource: "MHS_0", ofType: "csv")
        let rawCSVData = try! String.init(contentsOf: URL.init(fileURLWithPath: path!))

        //Decide to use the "updateSystemData" or naw.
        studentsData = parseCSVFile(rawData: rawCSVData)
        //print(studentsData[1].firstName)
        
        let defaults = UserDefaults.standard
        
        let archievedStudentsData:NSData = NSKeyedArchiver.archivedData(withRootObject: studentsData) as NSData
        defaults.set(archievedStudentsData, forKey: "MHS_Data")
        defaults.synchronize()
        
        //Saving data imported date
        saveCurrentDate(forKey: "Imported_Date")
        
        /*//Converting CSV file to String
        let csvURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "csv")!)
        
        do {
            rawCSVData = try String(contentsOf: csvURL as URL);
            //print("Imported Data" + "\(rawCSVData)");
        } catch {
            print("Corrupted File");
        }*/
    }
    
    public func storedDateInString(forKey key: String) -> String {
        var dateInString: String
        let defaults = UserDefaults.standard
        if let storedImportedDate = defaults.object(forKey: key) as? String {
            dateInString = "Imported on: " + storedImportedDate
        } else {
            dateInString = "Date for key \"" + key + "\" does not exist"
        }
        return dateInString
    }
    
//Private Functions
    
    private func convertDateToString(inputDate: Date) -> String {
        //Figuring out if the inputDate is empty or not.
        let calendar = Calendar.current
        let year = calendar.component(.year, from: inputDate)
        
        //Formatting the date if the date regardless if it's valid or not.
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        return year == 1 ? "n/a" : formatter.string(from: inputDate)
    }
    
    private func saveCurrentDate(forKey key: String) {
        //Getting the current date and coverting it to "dd/MM/YEAR" format.
        let currentDate = convertDateToString(inputDate: Date())
        
        //Saving
        let defaults = UserDefaults.standard
        defaults.set(currentDate, forKey: key)
        defaults.synchronize()
    }
    
    //This function should be called after the data that's being passed isn't nil.
    private mutating func updateSystemData() {
        
    }

    private mutating func parseCSVFile(rawData: String) -> [Student] {
        /*Parsing*/
        
        //Make this more flexible later on by allowing the user to put
        //the categories in any order they want in the csv file.
        
        //print(rawData)
        
        var parsedData: [Student] = [Student]()
        
        let separatedByStudents:[String] = rawData.components(separatedBy: "\r");
        
        for studentData in separatedByStudents {
            
            let student: Student = Student()
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
                student.status = "Present"
                
                parsedData.append(student)
                
            }
        }
        //print(parsedData[0].firstName)
        return parsedData
    }
}
