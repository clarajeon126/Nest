//
//  homeViewController.swift
//  Nest
//
//  Created by Clara Jeon on 1/23/21.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

var descriptionInt = 0

class HomeViewController: UIViewController {
    
    let challengeTableCellId = "challengeCell"
    
    
    //var randomInt = Int.random(in: 0...1)

    var personalChallenges:[Challenge] = []
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(UINib.init(nibName: challengeTableCellId, bundle: nil), forCellReuseIdentifier: challengeTableCellId)
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.separatorColor = .clear
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNotAuthenticated()
        
    }
    
    func setGreetingLabel(){
        var greeting = ""
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        
        dateFormatter.dateFormat = "HH"
        
        let dateHour:Int = Int(dateFormatter.string(from: currentDate)) ?? 1
        print(dateHour)
        
        if dateHour < 12 {
            greeting.append("Good Morning, ")
        }
        else if dateHour < 16 {
            greeting.append("Good Afternoon, ")
        }
        else {
            greeting.append("Good Evening, ")
        }
        
        greeting.append(UserProfile.currentUserProfile?.firstName ?? "error")
        greeting.append("☺️")
        greetingsLabel.text = greeting
    }

    //handle not authenticated to lead to login screen
    private func handleNotAuthenticated() {
        
        if Auth.auth().currentUser == nil {
            print("inside")
            let startingStoryBoard = UIStoryboard(name: "Starting", bundle: nil)
            let loginVC = startingStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
        else {
            print("elseobserve\(Auth.auth().currentUser!.uid)")
            
            //update user profile to be the current one
            DatabaseManager.shared.observeUserProfile(Auth.auth().currentUser!.uid) { (userProfile) in
                print(userProfile)
                UserProfile.currentUserProfile = userProfile
                
                //after that return the challenege array
                DatabaseManager.shared.returnChallengeArray { (challenges) in
                    print("received array from firebase")
                    challengeArray = challenges
                    self.setGreetingLabel()
                    self.reloadHomeTableData()
                }
            }
            
        }
        print("passed")
    }
    
    func reloadHomeTableData(){
        //setting up the personal challenge array
        let challengeArrayStored = UserProfile.currentUserProfile?.personalChallenges
        print(UserProfile.currentUserProfile?.firstName)
        print("outisde reload home table")
        print("inside here")
        print(challengeArrayStored)

        for x in 0...challengeArrayStored!.count - 1 {
            let num = challengeArrayStored![x]
            
            let challengeToBeKept = challengeArray[num]
            
            if personalChallenges.count < 3 {
                personalChallenges.append(challengeToBeKept)
            }
            else {
                personalChallenges[x] = challengeToBeKept
            }
        }
        print(personalChallenges)
        homeTableView.reloadData()
    }
    
}

//all things regarding the table view
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //right side swipe actions, replace cell
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Replace??") { (action, view, completionHandler) in
            
            //replace a single Challenge
            print("swipe action activated!")
            UserProfile.currentUserProfile?.replaceASingleChallenge(index: indexPath.row)
            self.reloadHomeTableData()
            completionHandler(true)
        }
        
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //left swipe action, open camerea
    /*func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
           //replace/ trash action
           let replaceAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               print("Update action ...")
               success(true)
           })
           replaceAction.backgroundColor = .red

           return UISwipeActionsConfiguration(actions: [replaceAction])
    }*/
    
    /*func tableView(_ tableView: UITableView,
                      leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{

        let submitCameraAction = UIContextualAction(style: .normal, title:  "Done! Photo timee", handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Submit Through Camera ...")
                performSegue(withIdentifier: "toSubmitPage", sender: self)
               success(true)
           })
           submitCameraAction.backgroundColor = .green
           return UISwipeActionsConfiguration(actions: [submitCameraAction])

    }*/
    
    //set height of the cell as third of the table view
    func tableView(_ tatbleView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = homeTableView.frame.height
        return tableViewHeight/3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //set cell with title, points, emoji and stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: challengeTableCellId, for: indexPath) as! challengeCell
        
        cell.selectionStyle = .none
    
        if personalChallenges.count < 1 {
            return cell
        }
        else {
            let challenge = personalChallenges[indexPath.row]
            
            print(challenge.title)
            cell.mainTitle.text = challenge.title
            cell.pointsLabel.text = "\(challenge.point) pts"
            cell.emojiLabel.text = challenge.emoji
            
            if indexPath.row == 0 {
                cell.viewBackground.backgroundColor = brightCyanColor
            }
            else if indexPath.row == 1{
                cell.viewBackground.backgroundColor = lightOrangeColor
                //cell.mainTitle.textColor = UIColor(red: 95/255, green: 111/255, blue: 110/255, alpha: 1.00)
            }
            else {
                cell.viewBackground.backgroundColor = lightCyanColor
            }
            
            return cell
        }
    }
    
    //when cell selected segue and update vc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        descriptionInt = indexPath.row
        performSegue(withIdentifier: "goToDescription", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //when the segue is going to the description
        if segue.identifier == "goToDescription" {
            let indexPath = homeTableView.indexPathForSelectedRow
            
            let descriptionVC = segue.destination as! CheckWorkViewController
            
            descriptionVC.challengeInQuestion = personalChallenges[indexPath!.row]
            descriptionVC.numInPersonalChallengeArray = indexPath!.row
        }
    }
}
