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
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let challengeTableCellId = "challengeCell"
    var challenges = [challengeTableCell]()
//    var randomInt = Int.random(in: 0...1)

    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.register(UINib.init(nibName: challengeTableCellId, bundle: nil), forCellReuseIdentifier: challengeTableCellId)
        homeTableView.dataSource = self
        homeTableView.delegate = self
        for x in 0...6{
            //takes random item from array and loads up different things onto cell when the page loads
            // make segue to description vc 
            let challenge = challengeTableCell()
            challenge?.mainTitle = challengeArray[x].titleOfChallenge
            challenge?.emoji = challengeArray[x].emojiOfChallenge
            challenge?.points = challengeArray[x].pointValue
            challenges.append(challenge!)
        
        }
        homeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNotAuthenticated()
    }
    
    //right side swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
           //replace/ trash action
           let ReplaceAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               print("Update action ...")
               success(true)
           })
           ReplaceAction.backgroundColor = .red

           return UISwipeActionsConfiguration(actions: [ReplaceAction])
    }
    
    func tableView(_ tableView: UITableView,
                      leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{

        let submitCameraAction = UIContextualAction(style: .normal, title:  "Done! Photo timee", handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Submit Through Camera ...")
                performSegue(withIdentifier: "toSubmitPage", sender: self)
               success(true)
           })
           submitCameraAction.backgroundColor = .green
           return UISwipeActionsConfiguration(actions: [submitCameraAction])

    }
    
    func tableView(_ tatbleView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = homeTableView.frame.height
        return tableViewHeight/3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: challengeTableCellId, for: indexPath) as! challengeCell
        
        cell.selectionStyle = .none
        
        let challenge = challenges[indexPath.row]
        
        cell.mainTitle.text = challenge.mainTitle
        
        cell.emojiLabel.text = challenge.emoji
        
        if indexPath.row == 0 {
            cell.viewBackground.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 105/255, alpha: 1.00)
        }
        else if indexPath.row == 1{
            cell.viewBackground.backgroundColor = UIColor(red: 252/255, green: 175/255, blue: 71/255, alpha: 1.00)
            //cell.mainTitle.textColor = UIColor(red: 95/255, green: 111/255, blue: 110/255, alpha: 1.00)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        descriptionInt = indexPath.row
        performSegue(withIdentifier: "gotoDescription", sender: self)
    }

    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            let startingStoryBoard = UIStoryboard(name: "Starting", bundle: nil)
            let loginVC = startingStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }

}
