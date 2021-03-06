//
//  SchoolInfoViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/2/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import CoreData

class SchoolInfoViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var currentSchool: School!
    var tableView: UITableView!
    var savedSchool: Bool!
    var currentPrograms: [Program]!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (currentSchool.values["school_name"] as! String)
        // Do any additional setup after loading the view.
        if savedSchool {
            saveButton.title = "Saved"
            saveButton.isEnabled = false
        }else{
            saveButton.title = "Save"
            saveButton.isEnabled = true
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SchoolInfoTableViewController{
            vc.currentSchool = currentSchool
            vc.currentPrograms = currentPrograms
        }
    }
    
    
    @IBAction func mapsButtonPressed(_ sender: UIButton) {
        
        if ((currentSchool.values["primary_address_line_1"]!) as! String) == "N/A" {
            SVProgressHUD.showError(withStatus: "Maps is not available for this school.")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }else{
            let mapURL = "http://maps.apple.com/?address=\(((currentSchool.values["primary_address_line_1"]!) as! String).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"
            if UIApplication.shared.canOpenURL(URL(string: (mapURL))!){
                UIApplication.shared.open(URL(string: mapURL)!, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let schoolContext = (UIApplication.shared.delegate as! AppDelegate).schoolPersistentContainer.viewContext
        let prgContext = (UIApplication.shared.delegate as! AppDelegate).programPersistentContainer.viewContext
        let schoolModel = SchoolModel(context: schoolContext)
        for key in School.keys{
            if(key != "ASC" && key != "DESC"){
                schoolModel.setValue(currentSchool.values[key] as! String, forKey: key)
            }
        }
        for program in currentPrograms {
            let programModel = ProgramModel(context: prgContext)

            for key in Program.programKeys {
                print(key)
                if let prgVal = program.values[key] as? String {
                    programModel.setValue(prgVal, forKey: key)

                }else{
                    programModel.setValue(nil, forKey: key)
                }


            }
            programModel.dbn = currentSchool.values["dbn"] as! String
            (UIApplication.shared.delegate as! AppDelegate).saveContext(type: .Program)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext(type: .School)
        saveButton.title = "Saved"
        saveButton.isEnabled = false
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let text = "Chech out \(currentSchool.values["school_name"] as! String) in the NYC High School Info app!"
        let url = URL(string: "nychs://\(currentSchool.values["dbn"] as! String)")!
        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true) {
            // ...
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


