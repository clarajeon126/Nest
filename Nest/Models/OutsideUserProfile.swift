//
//  OutsideUserProfile.swift
//  Nest
//
//  Created by Clara Jeon on 4/11/21.
//

import Foundation
import UIKit

public class OutsideUserProfile {
    var firstName: String
    var lastName: String
    var bio: String
    var profilePicUrl: URL
    
    init(firstName: String, lastName: String, bio: String, profilePicUrl: URL){
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.profilePicUrl = profilePicUrl
    }
    
    static func parse(_ data: [String: Any], completion: @escaping (_ userProfile: OutsideUserProfile)->()){
        if let firstName = data["firstName"] as? String,
           let lastName = data["lastName"] as? String,
           let bio = data["bio"] as? String,
           let urlAsString = data["profilePhotoUrl"] as? String,
           let imageUrl = URL(string: urlAsString) {
            
            let userProfile = OutsideUserProfile(firstName: firstName, lastName: lastName, bio: bio, profilePicUrl: imageUrl)
            completion(userProfile)
        }
    }
}
