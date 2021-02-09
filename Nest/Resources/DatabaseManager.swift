//
//  DatabaseManager.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation
import FirebaseDatabase

//all things related to Firebase Database happen here
public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //inserting user into database
    public func insertNewUser(firstName: String, lastName: String, profilePhotoUrl: URL, completion: @escaping (Bool) -> Void){
        
        //setting static variable currentBasicUserProfile for easy access to data
        BasicUserProfile.currentBasicUserProfile = BasicUserProfile(firstName: firstName, lastName: lastName, profilePhotoUrl: profilePhotoUrl)
        
        guard let uid = BasicUserProfile.currentBasicUserProfile?.uid else {
            completion(false)
            return
        }
        print("before getting profilePhoto")
        //setting the info that will go into database
        let userObj = ["firstName": firstName, "lastName": lastName, "uid": uid, "profilePhotoUrl": profilePhotoUrl.absoluteString] as [String : Any]
        
        database.child("users").child(uid).setValue(userObj) { (error, _) in
            
            //in case of error
            if error == nil {
                completion(true)
                return
            }
            else {
                completion(false)
                return
            }
        }
    }
}
