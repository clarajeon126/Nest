//
//  UserProfile.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation

//overall profile pic that contains bio, pts and everything
public class UserProfile {
    static var currentUserProfile:UserProfile?
    
    var firstName: String
    var lastName:String
    var uid: String
    var profilePhotoUrl:URL
    var bio: String
    var points: Int
    var personalChallenges: [Int]
    var randomNumArray: [Int]
    
    init(firstName: String, lastName: String, profilePicUrl: URL, bio: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePhotoUrl = profilePicUrl
        self.uid = AuthManager.shared.getUserId() ?? "no uid"
        self.bio = bio
        self.points = 0
        
        //in order to create the first three challenges of the user, the items wont be repeated and will only repeat once all of it is finished
        var personalChallengeArray:[Int] = []
        let challengeArrayLastNum = challengeArray.count - 1
        let rangeOfArray = 0...challengeArrayLastNum
        var arrayWithNum = Array(rangeOfArray)
        
        for x in 0...2 {
            var randomNum = Int.random(in: 0...arrayWithNum.count - 1)
            personalChallengeArray.append(arrayWithNum[randomNum])
            arrayWithNum.remove(at: randomNum)
        }
        
        self.randomNumArray = arrayWithNum
        self.personalChallenges = personalChallengeArray
    }
    
    //initializer that takes in all the parameters and createsa UserProfile
    init(firstName: String, lastName: String, uid: String, profilePhotoUrl: URL, bio: String, points: Int, personalChallenges: [Int], randomNumArray: [Int]) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePhotoUrl = profilePhotoUrl
        self.uid = uid
        self.bio = bio
        self.points = points
        self.personalChallenges = personalChallenges
        self.randomNumArray = randomNumArray
    }
    public func replaceASingleChallenge(index: Int){
        print(randomNumArray)
        let randomNum = Int.random(in: 0...randomNumArray.count - 1)
        print(randomNum)
        personalChallenges[index] = randomNumArray[randomNum]
        randomNumArray.remove(at: randomNum)
        
        //when the array is empty
        if randomNumArray.count == 0 {
            randomNumArray = Array(0...challengeArray.count - 1)
            for x in 0...personalChallenges.count - 1 {
                let numToRemove = personalChallenges[x]
                
                for y in 0..<randomNumArray.count {
                    let numInQuestion = randomNumArray[y]
                    if numInQuestion == numToRemove {
                        randomNumArray.remove(at: y)
                        break;
                    }
                }
            }
        }
        print(randomNumArray)
        
        DatabaseManager.shared.reloadCurrentUserData()
    }
    
}
