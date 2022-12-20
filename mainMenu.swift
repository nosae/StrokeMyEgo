//
//  mainMenu.swift
//  Stroke My Ego
//
//  Created by Nosakhare Edogun on 12/27/21.
//

import UIKit
import SwiftUI
import SQLite3
import AudioToolbox

var newName = String()
var userList = [Users]()

private var defaults = UserDefaults.standard

var firstTimeAppLaunch: Bool {
        get {
            // Will return false when the key is not set.
            return defaults.bool(forKey: "firstTimeAppLaunch")
        }
        set {}
    }

var defaultName = String()

class Users {
 
    var name: String?
    var strokeCount: Int
    
    init(name: String?, strokeCount: Int){
        self.name = name
        self.strokeCount = strokeCount
    }
}

class mainMenu: UIViewController, UITextFieldDelegate {
    
    var db: OpaquePointer?
 
    @IBOutlet weak var namefield: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet var switchState: UISwitch!
    
    var saveState = defaults.bool(forKey: "State")
    
    let corgiGif = UIImage.gif(name: "corgi")

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//       self.view.backgroundColor = UIColor(patternImage: UIImage(named: "scene5")!)
         if !firstTimeAppLaunch {
                    // This will only be trigger first time the application is launched.
                    defaults.set(true, forKey: "firstTimeAppLaunch")
                    //defaults.set(true, forKey: "mySwitchValue")
                }
        
        if saveState == true {
            
            switchState.isOn = true
        } else {
            
            switchState.isOn = false
        }
        
        imageView.animationImages = corgiGif?.images
        // Set the duration of the UIImage
        imageView.animationDuration = corgiGif!.duration
        // Set the repetitioncount
        imageView.animationRepeatCount = 0
        // Start the animation
        imageView.startAnimating()
        
       // checkInitialVc() //calls your function when view is available
        
        self.namefield!.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent("SMEDatabase.sqlite")
       
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (name TEXT, strokeCount INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        load()
      }
    

    @IBAction func switchStateDidChange(_ sender: UISwitch) {
        
//        if saveState == "On" {
        if sender.isOn {
            defaults.set(true, forKey: "State")

        } else {
            defaults.set(false, forKey: "State")

        }
        

    }
    
    func getSwitch() -> Bool{
        let boolValue = UserDefaults.standard.bool(forKey: "State")
        return boolValue
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == namefield {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        
        newName = namefield.text!
        
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
    
        newName = namefield.text!
        
        
    }
     
    //Sroke button action
    @IBAction func strokeButton(_ sender: UIButton) {
       
       // imageView.stopAnimating()
        setDefaultName()
        self.save()
        
    }
    
    
    func setDefaultName() {
        
        defaults = UserDefaults.standard
        defaults.set(nameInField(), forKey: "Name")
        defaultName = defaults.string(forKey: "Name")!
        
    }

    
    
    func nameInField() -> String{
        
        return newName
        
    }
    
    func readValues(){
     
            //first empty the list of heroes
        
        userList.removeAll()
     
            //this is our select query
            let queryString = "SELECT * FROM Users"
     
            //statement pointer
            var stmt:OpaquePointer?
     
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
     
            //traversing through all the records
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let name = String(cString: sqlite3_column_text(stmt, 0))
                let strokeCount = sqlite3_column_int(stmt, 1)
     
                //adding values to list
                userList.append(Users(name: String(describing: name), strokeCount: Int(strokeCount)))
            }
     
        }
    
    func save() {

        //creating a statement
               var stmt: OpaquePointer?
        
               //the insert query
               let queryString = "INSERT INTO Users (name, strokeCount) VALUES (?,?)"
        
        
        defaults.set(newName, forKey: "Name")
        

        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
 
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, newName, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
 
//        if sqlite3_bind_int(stmt, 2, (strokeCount! as NSString).intValue) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding name: \(errmsg)")
//            return
//        }
 
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting user: \(errmsg)")
            return
        }
 
 
        readValues()
 
        //displaying a success message
//        print(userList.count)
//        print("User saved successfully")
        
        
    }
    
    func load() {
      let savedName = defaults.string(forKey: "Name")
        
        newName = savedName ?? ""
        
        namefield.text = savedName
        
    }
    

    
}
