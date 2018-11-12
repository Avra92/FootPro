//
//  StandingViewController.swift
//  FootPro
//
//  Created by Avra Ghosh on 10/11/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit

class StandingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var league_Name: String?
    var league_ID: String?
    var leagueTableArray = [LeagueTable]()
    @IBOutlet weak var StandingList: UITableView!
    @IBOutlet weak var lb_leagueName: UILabel!
    //var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activityIndicator = UIActivityIndicatorView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lb_leagueName.text = league_Name
        getLeagueTable()
    }
    
    func getLeagueTable() {
        //showOrHideActivityIndicator(show: true)
        leagueTableArray = []
        StandingList.delegate = self
        StandingList.dataSource = self
        
        // Set up the URL request
        let getLeagueTable: String = "https://apifootball.com/api/?action=get_standings&league_id="+league_ID!+"&APIkey=2b6bdde00630c447c10ab19362f49725045c269cb82c571b2520c3113b38113d"
        print(getLeagueTable)
        
        let url = URL(string: getLeagueTable)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let standingDetails = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                    print(standingDetails)
                    for standingDetail in standingDetails {
                        if let standingDetailDict = standingDetail as? NSDictionary {
                            var standing = LeagueTable(position: "", teamName: "",matchesPlayed: "",matchesWon: "", matchesLost: "", matchesDrawn: "", goalFor: "", goalAgainst: "", points: "")
                            if let posi = standingDetailDict.value(forKey: "overall_league_position"){
                                standing.position = posi as! String
                            }
                            if let teamname = standingDetailDict.value(forKey: "team_name"){
                                standing.teamName = teamname as! String
                            }
                            if let matchesplayed = standingDetailDict.value(forKey: "overall_league_payed"){
                                standing.matchesPlayed = matchesplayed as! String
                            }
                            if let matcheswon = standingDetailDict.value(forKey: "overall_league_W"){
                                standing.matchesWon = matcheswon as! String
                            }
                            if let matcheslost = standingDetailDict.value(forKey: "overall_league_L"){
                                standing.matchesLost = matcheslost as! String
                            }
                            if let matchesdrawn = standingDetailDict.value(forKey: "overall_league_D"){
                                standing.matchesDrawn = matchesdrawn as! String
                            }
                            
                            if let goalfor = standingDetailDict.value(forKey: "overall_league_GF"){
                                standing.goalFor = goalfor as! String
                            }
                            if let goalagainst = standingDetailDict.value(forKey: "overall_league_GA"){
                                standing.goalAgainst = goalagainst as! String
                            }
                            if let pts = standingDetailDict.value(forKey: "overall_league_PTS"){
                                standing.points = pts as! String
                            }
                            self.leagueTableArray.append(standing)
                            print(self.leagueTableArray)
                            OperationQueue.main.addOperation({
                                self.StandingList.reloadData()
                            })
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(leagueTableArray.count)
        return leagueTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell") as! LeagueStandingCell
        cell.lb_position.text = leagueTableArray[indexPath.row].position
        cell.lb_team.text = leagueTableArray[indexPath.row].teamName
        cell.lb_matchesPlayed.text = leagueTableArray[indexPath.row].matchesPlayed
        cell.lb_matchesWon.text = leagueTableArray[indexPath.row].matchesWon
        
        cell.lb_matchesLost.text = leagueTableArray[indexPath.row].matchesLost
        cell.lb_matchesDrawn.text = leagueTableArray[indexPath.row].matchesDrawn
        cell.lb_goalFor.text = leagueTableArray[indexPath.row].goalFor
        cell.lb_goalAgainst.text = leagueTableArray[indexPath.row].goalAgainst
        cell.lb_Points.text = leagueTableArray[indexPath.row].points
        return cell
    }
    
    /*func showOrHideActivityIndicator(show: Bool) {
        if (show) {
            activityIndicator?.center = self.view.center
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.activityIndicatorViewStyle = .whiteLarge
            view.addSubview(activityIndicator!)
            UIApplication.shared.beginIgnoringInteractionEvents()
            activityIndicator?.startAnimating()
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator?.stopAnimating()
        }
    }*/
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct LeagueTable {
        var position: String
        var teamName: String
        var matchesPlayed: String
        var matchesWon: String
        var matchesLost: String
        var matchesDrawn: String
        var goalFor: String
        var goalAgainst: String
        var points: String
    }

}
