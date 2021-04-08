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
    
    public func addPost(caption: String, image: UIImage, hashtag: String){
        guard let userUid = UserProfile.currentUserProfile?.basicProfileInfo.uid else {
            return
        }
        
        let postChildRef = postDatabase.childByAutoId()
        let keyOfPost = postChildRef.key
        
        StorageManager.shared.uploadPostPhoto(image, withAutoId: keyOfPost) { (url) in
            let postObj = ["author": ["uid": ]]
        }
        
    }
    
    //query for opportunities by timestamp
    var queryPostsByTime: DatabaseQuery {
        var postsQueryRef: DatabaseQuery
        
        postsQueryRef = postDatabase.queryOrdered(byChild: "timestamp")
        return postsQueryRef
    }
    
    //returns array of posts organized by time
    public func arrayOfPostByTime(completion: @escaping (_ posts: [Post])->()){
        queryPostsByTime.observeSingleEvent(of: .value) { (snapshot) in
            var posts = [Post]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        Post.parse(childSnapshot.key, data) { (post) in
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
    
    
}
