//
//  settingViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/18/21.
//

import UIKit

class settingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //table view set up
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func signOut(){
        AuthManager.shared.logOut(completion: {success in
            DispatchQueue.main.async {
                if success {
                    UserProfile.currentUserProfile = nil
                    
                    let startingStoryBoard = UIStoryboard(name: "Starting", bundle: nil)
                    let loginVC = startingStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true) {
                        print("moved")
                    }
                }
            }
            
        })
    }

}

extension settingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: "feedbackCell", for: indexPath)
            return cell
        }
        else {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: "signOutCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToFeedback", sender: self)
        }
        else if indexPath.row == 1 {
            let alert = UIAlertController(title: "Sign out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { (AlertAction) in
                self.signOut()
            }))
            alert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2
    }
}
