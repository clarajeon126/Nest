//
//  LoginViewController.swift
//  Nest
//
//  Created by Clara Jeon on 1/30/21.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(userDidSignInGoogle(_:)),
                                                   name: .signInGoogleCompleted,
                                                   object: nil)
    }
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        print(Auth.auth().currentUser)
        updateScreen()
    }
    
    private func updateScreen() {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loginToMain", sender: self)
        }
    }

}
