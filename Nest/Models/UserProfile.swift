//
//  UserProfile.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation

public class UserProfile {
    static var currentUserProfile:UserProfile?
    
    var bio: String
    var points: Int
    var basicProfileInfo: BasicUserProfile
    
    init(bio: String, basicProfileInfo: BasicUserProfile) {
        self.bio = bio
        self.points = 0
        self.basicProfileInfo = basicProfileInfo
    }
}
