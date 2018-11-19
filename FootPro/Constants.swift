//
//  Constants.swift
//  FootPro
//
//  Created by Avra Ghosh on 8/11/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let country_ID = ["England": "169", "Italy": "170", "Spain": "171", "Germany": "172", "France": "173", "Portugal": "176"]
    
    //Error Messages
    static let error_internet = "Internet issue. Please try again"
    static let error_server = "Server issue. Please try again"
    static let error_general = "An error occurred. Please try again"
    static let error_league = "League Standing not found"
    
    //Colors
    static let cell_Color = UIColor(red:79/255,green:148/255,blue:0/255,alpha:1)
    static let navigation_Color = UIColor(red:124/255,green:255/255,blue:143/255,alpha:1)
    
    
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            
        }
        alert.addAction(okAction)
        return alert;
    }
}


