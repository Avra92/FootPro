//
//  ViewController.swift
//  FootPro
//
//  Created by Avra Ghosh on 7/11/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var txt_selectCountry: UITextField!
    
    // Creating Country List
    let countryList = ["England", "Italy", "Spain", "Germany", "France", "Portugal"]
    var countryMenu = UIPickerView()
    var country_ID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countryMenu.dataSource = self
        countryMenu.delegate = self
        countryMenu.backgroundColor = UIColor.gray
        txt_selectCountry.inputView = countryMenu
        txt_selectCountry.placeholder = "Select country"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Modifying the Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row]
    }
    
    //Based on the country selected from picker view txt_countryList will change
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_selectCountry.text = countryList[row]
        country_ID = Constants.country_ID[txt_selectCountry.text!]!
        print("ID :"+country_ID)
        txt_selectCountry.resignFirstResponder()
    }
    
    @IBAction func didTapGo(_ sender: UIButton) {
        let leagueController = storyboard?.instantiateViewController(withIdentifier: "LeagueViewController") as? LeagueViewController
        leagueController?.countryID = country_ID
        
        self.navigationController?.pushViewController(leagueController!, animated: true)
    }
}

