//
//  SchoolInfoTableViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/2/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit
import SVProgressHUD

class SchoolInfoTableViewController: UITableViewController {
    
    public var currentSchool: School!
    public var currentPrograms: [Program]!
    
    @IBOutlet var cells: [UITableViewCell]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<cells.count {
            cells[i].textLabel!.text = currentSchool.values[School.keys[i]] as? String
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else {return}
        
        if let controller = segue.destination as? ParagraphViewController{
            
            if let val = currentSchool.values[School.keyMap[cell.detailTextLabel!.text!]!] as? String{
                controller.paragraph = val
            }
            
            controller.title = cell.detailTextLabel!.text!
        }
        
        if let controller = segue.destination as? DetailTableViewController{
            if cell.detailTextLabel != nil {
                switch cell.detailTextLabel!.text! {
                case "Sports":
                    
                    guard let _ = currentSchool.values["psal_sports_boys"] as? String,
                        let _ = currentSchool.values["psal_sports_girls"] as? String,
                        let _ = currentSchool.values["psal_sports_coed"] as? String,
                        let _ = currentSchool.values["school_sports"] as? String else {break}
                    
                    controller.unformattedSports = [
                        currentSchool.values["psal_sports_boys"] as! String,
                        currentSchool.values["psal_sports_girls"] as! String,
                        currentSchool.values["psal_sports_coed"] as! String,
                        currentSchool.values["school_sports"] as! String
                    ]
                    controller.detailType = .Sports
                    break
                case "Programs":
                    controller.detailType = .Program
                    controller.programs = currentPrograms
                    break
                default:
                    if let val = currentSchool.values[School.keyMap[cell.detailTextLabel!.text!]!] as? String {
                        controller.unformattedText = val
                    }
                    switch cell.detailTextLabel!.text! {
                    case "Subway":
                        controller.detailType = .Subway
                        break
                    default:
                        controller.detailType = .Default
                    }
                    break
                }
                
                
                
                controller.title = cell.detailTextLabel!.text!
            }else{
                controller.programs = currentPrograms
                controller.detailType = .Program
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4{
            if indexPath.row == 0{ //email
                if let email = currentSchool.values["school_email"] as? String{
                    let alert = UIAlertController(title: email, message: "Email \((describing: currentSchool.values["school_name"] as! String))?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                        switch action.style{
                        case .default:
                            if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                            break
                        case .cancel:
                            self.dismiss(animated: true, completion: nil)
                            break
                        default:
                            break
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else if indexPath.row == 1{ //phone number
                if let number = currentSchool.values["phone_number"] as? String{
                    if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }else if indexPath.section == 0 && indexPath.row == 2{
            if var website = currentSchool.values["website"] as? String {
                if !website.hasPrefix("http"){
                    website = "http://" + website
                }
                if UIApplication.shared.canOpenURL(URL(string: website)!){
                    UIApplication.shared.open(URL(string: website)!, options: [:], completionHandler: nil)
                }
            }
        }else{
            if tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCellAccessoryType.disclosureIndicator {
                UIPasteboard.general.string = tableView.cellForRow(at: indexPath)?.textLabel?.text
                SVProgressHUD.showSuccess(withStatus: "Copied!")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
