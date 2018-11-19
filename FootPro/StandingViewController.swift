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
    var status: String?
    var leagueTableArray = [LeagueTable]()
    @IBOutlet weak var StandingList: UITableView!
    @IBOutlet weak var lb_leagueName: UILabel!
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Modifying the Navigation Bar and Title Color
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
        lb_leagueName.text = league_Name
        getLeagueTable()
    }
    
    func getLeagueTable() {
        showOrHideActivityIndicator(show: true)
        leagueTableArray = []
        StandingList.delegate = self
        StandingList.dataSource = self
        
        // Set up the URL request
        let getLeagueTable: String = "https://apifootball.com/api/?action=get_standings&league_id="+league_ID!+"&APIkey=2b6bdde00630c447c10ab19362f49725045c269cb82c571b2520c3113b38113d"
        
        let url = URL(string: getLeagueTable)
        URLSession.shared.dataTask(with:url!) { data, response, error in
            DispatchQueue.main.async(execute: {
                self.showOrHideActivityIndicator(show: false)
            })
            
            guard let data = data, error == nil else {
                self.showError(message: Constants.error_internet)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                self.showError(message: Constants.error_server)
                return
            }
            
            do{
                let standingDetails = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
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
                  }
                  else {
                    self.showError(message: Constants.error_general)
                  }
              }
              //self.leagueTableArray.sort{Int($0.position) < Int($1.position)}
              self.leagueTableArray.sort {
                    $0.position.compare($1.position, options: .numeric) == .orderedAscending
              }
              print(self.leagueTableArray)
              OperationQueue.main.addOperation({
                    self.StandingList.reloadData()
              })
        }
        catch {
            self.showError(message: Constants.error_league)
        }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueTableArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
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
        
        //Cell Designing
        cell.view_standingCell.backgroundColor = UIColor.white
        cell.view_standingCell.layer.borderColor = UIColor.black.cgColor
        cell.view_standingCell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func showOrHideActivityIndicator(show: Bool) {
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
    }
    
    func showError(message: String) {
        DispatchQueue.main.async(execute: {
            self.present(Constants.createAlert(title: "Error", message: message), animated: true, completion: nil)
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Creating a structure with the following fields which will be received from API call
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
