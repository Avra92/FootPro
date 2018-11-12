//
//  LeagueViewController.swift
//  FootPro
//
//  Created by Avra Ghosh on 9/11/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit

class LeagueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countryID : String?
    var leagueName : String?
    var leagueArray = [League]()
    @IBOutlet weak var LeagueList: UITableView!
    //var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activityIndicator = UIActivityIndicatorView()
        getLeagueDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getLeagueDetails() {
        //showOrHideActivityIndicator(show: true)
        leagueArray = []
        LeagueList.delegate = self
        LeagueList.dataSource = self
        
        // Set up the URL request
        let getLeague: String = "https://apifootball.com/api/?action=get_leagues&country_id="+countryID!+"&APIkey=2b6bdde00630c447c10ab19362f49725045c269cb82c571b2520c3113b38113d"
        print(getLeague)
        
        let url = URL(string: getLeague)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let leagueDetails = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                    for leagueDetail in leagueDetails {
                        if let leagueDetailDict = leagueDetail as? NSDictionary {
                            var league = League(leagueName: "", leagueID: "")
                            if let leaguename = leagueDetailDict.value(forKey: "league_name"){
                                league.leagueName = leaguename as! String
                            }
                            if let leagueid = leagueDetailDict.value(forKey: "league_id"){
                                league.leagueID = leagueid as! String
                            }
                            self.leagueArray.append(league)
                            OperationQueue.main.addOperation({
                                self.LeagueList.reloadData()
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
        return leagueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell") as! LeagueListCell
        cell.leagueName.text = leagueArray[indexPath.row].leagueName
        return cell
    }
    
    //Clicking a particular League list row in Leagues screen the standing for that particular league will be displayed in the League Table screen.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standingController = storyboard?.instantiateViewController(withIdentifier: "StandingViewController") as? StandingViewController
        print(indexPath.row)
        standingController?.league_Name = leagueArray[indexPath.row].leagueName
        standingController?.league_ID = leagueArray[indexPath.row].leagueID
        print("I'm here")
        print(leagueArray[indexPath.row].leagueName)
        print(leagueArray[indexPath.row].leagueID)
        self.navigationController?.pushViewController(standingController!, animated: true)
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
    
    struct League {
        var leagueName: String
        var leagueID: String
    }
}
