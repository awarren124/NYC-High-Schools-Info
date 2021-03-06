//
//  FilterViewController.swift
//  NYC High School Info
//
//  Created by Alexander Warren on 9/4/17.
//  Copyright © 2017 Alexander Warren. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var searchByPicker: UIPickerView!
    @IBOutlet weak var sortByPicker: UIPickerView!
    
    let searchByKeys = [
        "School Name",
        "School Code",
        "Language Classes",
        "Extracurriculars",
        "Sports",
        "Borough"
    ]
    
    let sortByKeys = [
        "Relevance",
        "School Name",
        "Total Students",
        "Attendance Rate",
        "Graduation Rate",
        
    ]
    let sortByDirections = [
        "Ascending",
        "Descending",
    ]
    

    
    var schoolView: SchoolSearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schoolView = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as? SchoolSearchViewController
        
        searchByPicker.delegate = self
        searchByPicker.dataSource = self
        sortByPicker.delegate = self
        sortByPicker.dataSource = self
        
        searchByPicker.selectRow(searchByKeys.index(of: schoolView.currentSearchByFilter)!, inComponent: 0, animated: true)
        sortByPicker.selectRow(sortByKeys.index(of: schoolView.currentSortByFilter)!, inComponent: 0, animated: true)
        sortByPicker.selectRow(sortByDirections.index(of: schoolView.currentSortByDirection)!, inComponent: 1, animated: true)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case sortByPicker:
            return 2
        default:
            return 1
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 1){
            return 2
        }
        switch pickerView {
        case searchByPicker:
            return searchByKeys.count
        case sortByPicker:
            return sortByKeys.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return sortByDirections[row]
        }
        switch pickerView {
        case searchByPicker:
            return searchByKeys[row]
        case sortByPicker:
            return sortByKeys[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case searchByPicker:
            schoolView.currentSearchByFilter = searchByKeys[row]
            print(searchByKeys[row])
            break
        case sortByPicker:
            if component == 0{
                schoolView.currentSortByFilter = sortByKeys[row]
                print(sortByKeys[row])
            }else{
                schoolView.currentSortByDirection = sortByDirections[row]
            }
            break
        default:
            break
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            if UserDefaults.standard.bool(forKey: "Filter Reload") {
                self.schoolView.search()
            }
        })
    }

    
}
