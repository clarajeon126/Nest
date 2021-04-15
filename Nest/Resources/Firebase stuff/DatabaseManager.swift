//
//  DatabaseManager.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import Foundation
import FirebaseDatabase

/*
    for all things related to Firebase Database
    functions it contains:
    - insert a user into the user branch in the database with first last name, prof pic url, uid
    - add a post to the database includng all the data the post needs
    - query posts by time and return an array of the posts
 */

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private let postDatabase = Database.database().reference().child("posts")
    
    private let challengeDatabse = Database.database().reference().child("challenges")
    
    private let userDatabase = Database.database().reference().child("users")
    //inserting user into database
    public func insertNewUser(firstName: String, lastName: String, profilePhotoUrl: URL, completion: @escaping (Bool) -> Void){
        
        
        DatabaseManager.shared.returnChallengeArray { (challenges) in
            print("received array from firebase for inserting new user")
            challengeArray = challenges
            
            //setting static variable currentBasicUserProfile for easy access to data
            UserProfile.currentUserProfile = UserProfile(firstName: firstName, lastName: lastName, profilePicUrl: profilePhotoUrl, bio: "empty")
            
            guard let uid = UserProfile.currentUserProfile?.uid else {
                completion(false)
                return
            }
            
            print("before getting profilePhoto")
            //setting the info that will go into database
            let userObj = ["firstName": firstName, "lastName": lastName, "uid": uid, "profilePhotoUrl": profilePhotoUrl.absoluteString, "bio": "empty", "points": 0, "challenges": UserProfile.currentUserProfile?.personalChallenges ?? [0,1,2], "numberArray": UserProfile.currentUserProfile?.randomNumArray ?? [0,1,2,3,4]] as [String : Any]
            
            print(userObj)
            self.database.child("users").child(uid).setValue(userObj) { (error, _) in
                
                //in case of error
                if error == nil {
                    completion(true)
                    return
                }
                else {
                    print("error loading in new user")
                    completion(false)
                    return
                }
            }
        }
    }
    
    //reload the data when something has changed
    public func reloadCurrentUserData(){
        guard let uid = AuthManager.shared.getUserId() else {
            return
        }
        let refToUser = userDatabase.child(uid)
        
        let currentUser = UserProfile.currentUserProfile
        let newUserObj = ["firstName": currentUser?.firstName, "lastName": currentUser?.lastName, "uid": currentUser?.uid, "profilePhotoUrl": currentUser?.profilePhotoUrl.absoluteString, "bio": currentUser?.bio, "points": currentUser?.points ?? 0, "challenges": currentUser?.personalChallenges ?? [0,1,2], "numberArray": currentUser?.randomNumArray ?? [0,1,2,3,4]] as [String : Any]
        
        refToUser.updateChildValues(newUserObj)
    }
    
    //retrieve user profile
    public func observeUserProfile(_ uid: String, completion: @escaping ((_ userProfile: UserProfile?) -> ())) {
        let userRef = database.child("users/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile: UserProfile?
            
            if let dict = snapshot.value as? [String: Any],
               let firstName = dict["firstName"] as? String,
               let lastName = dict["lastName"] as? String,
               let uid = dict["uid"] as? String,
               let profilePhotoURL = dict["profilePhotoUrl"] as? String,
               let url = URL(string: profilePhotoURL),
               let bio = dict["bio"] as? String,
               let points = dict["points"] as? Int,
               let challenges = dict["challenges"] as? [Int],
               let numberArray = dict["numberArray"] as? [Int]
               
            {
                userProfile = UserProfile(firstName: firstName, lastName: lastName, uid: uid, profilePhotoUrl: url, bio: bio, points: points, personalChallenges: challenges, randomNumArray: numberArray)
            }
            
            completion(userProfile)
        })
    }
    
    //return challenges array from firebase
    public func returnChallengeArray(completion: @escaping (_ challenges: [Challenge])->()){
        challengeDatabse.observeSingleEvent(of: .value) { (snapshot) in
            var challenges = [Challenge]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String:Any]{
                        Challenge.parse(data) { (challenge) in
                            numOfChildThroughFor += 1
                            challenges.append(challenge)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                completion(challenges)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //add post into firebase
    public func addPost(anonymous: Bool, caption: String, image: UIImage, hashtag: String, completion: @escaping (_ success: Bool)->()){
        
        //creating the reference to the post
        let postChildRef = postDatabase.childByAutoId()
        let keyOfPost = postChildRef.key!
        
        //upload the post image to storage manager in firebase
        StorageManager.shared.uploadPostPhoto(image, withAutoId: keyOfPost) { (url) in
            
            //to deal with anonymous
            var authorString = "anon"
            
            if !anonymous {
                
                guard let userUid = UserProfile.currentUserProfile?.uid else {
                    return
                }
                
                authorString = userUid
             
            }
            
            //creating the post obj
            let postObj = ["author": authorString,
                           "caption": caption,
                           "image": url?.absoluteString,
                           "hashtag": hashtag,
                           "timestamp": [".sv":"timestamp"] ] as [String: Any]
            
            postChildRef.setValue(postObj)
            completion(true)
        }
        
    }
    
    //return a simple user profile to be used
    public func getUserProfileFromUid(uid: String, completion: @escaping (_ userProfile: OutsideUserProfile)->()){
        userDatabase.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                OutsideUserProfile.parse(dict) { (userProfile) in
                    completion(userProfile)
                }
            }
        }
    }
    
    //query for posts by timestamp
    var queryPostsByTime: DatabaseQuery {
        var postsQueryRef: DatabaseQuery
        
        postsQueryRef = postDatabase.queryOrdered(byChild: "timestamp")
        return postsQueryRef
    }
    
    //returns array of posts organized by time
    public func arrayOfPostByTime(completion: @escaping (_ posts: [Post])->()){
        queryPostsByTime.observeSingleEvent(of: .value) { (snapshot) in
            print("in query")
            var posts = [Post]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        print("hereee")
                        print(data)
                        Post.parse(childSnapshot.key, data) { (post) in
                            print("parse\(numOfChildThroughFor)")
                            numOfChildThroughFor += 1
                            posts.insert(post, at: 0)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                return completion(posts)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //query for posts by user
    var queryUserPosts: DatabaseQuery {
        var postsQueryRef: DatabaseQuery
        
        postsQueryRef = postDatabase.queryOrdered(byChild: "author").queryEqual(toValue: UserProfile.currentUserProfile?.uid)
        return postsQueryRef
    }
    
    //returns array of posts by user
    public func arrayOfPostsByUser(completion: @escaping (_ posts: [Post])->()){
        queryUserPosts.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            print("in query")
            var userPosts = [Post]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        print("hereee")
                        print(data)
                        Post.parse(childSnapshot.key, data) { (post) in
                            print("parse\(numOfChildThroughFor)")
                            numOfChildThroughFor += 1
                            userPosts.insert(post, at: 0)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                return completion(userPosts)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
