//
//  AuthManager.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

/*
    for all things related to Firebase Auth
    functions it contains:
    - retrieve user id from the auth manager
 */

public class AuthManager {
    
    // static auth to use all around the app
    static let shared = AuthManager()
    
    //getting uid of current user
    public func getUserId() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return "no uid"
        }
        return uid
    }
    
}


