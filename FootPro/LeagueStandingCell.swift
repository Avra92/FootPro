//
//  LeagueStandingCell.swift
//  FootPro
//
//  Created by Avra Ghosh on 10/11/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit

class LeagueStandingCell: UITableViewCell {

    @IBOutlet weak var view_standingCell: UIView!
    @IBOutlet weak var lb_position: UILabel!
    @IBOutlet weak var lb_team: UILabel!
    @IBOutlet weak var lb_matchesPlayed: UILabel!
    @IBOutlet weak var lb_matchesWon: UILabel!
    @IBOutlet weak var lb_matchesDrawn: UILabel!
    @IBOutlet weak var lb_matchesLost: UILabel!
    @IBOutlet weak var lb_goalFor: UILabel!
    @IBOutlet weak var lb_goalAgainst: UILabel!
    @IBOutlet weak var lb_Points: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
