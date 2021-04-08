//
//  BasicUserProfile.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation

//for basic user profile - info only necessary for post data and such
public class BasicUserProfile {
    static var currentBasicUserProfile: BasicUserProfile?

    var firstName: String
    var lastName:String
    var uid: String
    var profilePhotoUrl:URL
    
    init(firstName: String, lastName: String, profilePhotoUrl: URL){
        self.firstName = firstName
        self.lastName = lastName
        self.uid = AuthManager.shared.getUserId() ?? "no uid"
        self.profilePhotoUrl = profilePhotoUrl
    }
    
    init(firstName: String, lastName: String, uid: String, profilePhotoUrl: URL) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.profilePhotoUrl = profilePhotoUrl
    }
    
}
