//
//  Post.swift
//  Nest
//
//  Created by Clara Jeon on 2/9/21.
//

import Foundation
import UIKit

public class Post {
    var id: String
    var author: BasicUserProfile
    var postImage: URL
    var postCaption: String
    var isAnonymous: Bool
    var createdAt: Date
    
    init(id: String, author: BasicUserProfile, isAnonymous: Bool, postImage: URL, postCaption:String, timestamp: Double){
        self.id = id
        self.author = author
        self.isAnonymous = isAnonymous
        self.postImage = postImage
        self.postCaption = postCaption
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
    
    static func parse(_ key: String, _ data: [String:Any]) -> Post? {
        if let author = data["author"] as? [String:Any],
           let uid = author["uid"] as? String,
           let firstName = author["firstName"] as? String,
           let lastName = author["lastName"] as? String,
           let profilePhotoUrlAsString = author["profilePhotoUrl"] as? String,
           let profilePhotoUrl = URL(string: profilePhotoUrlAsString),
           let postImageUrlAsString = data["postImageUrl"] as? String,
           let postImageUrl = URL(string: postImageUrlAsString),
           let postCaption = data["postCaption"] as? String,
           let isAnonymous = data["isAnonymous"] as? Bool,
           let timestamp = data["timestamp"] as? Double{
            
            let userProfile = BasicUserProfile(firstName: firstName, lastName: lastName, uid: uid, profilePhotoUrl: profilePhotoUrl)
            
            let post = Post(id: key, author: userProfile, isAnonymous: isAnonymous, postImage: postImageUrl, postCaption: postCaption, timestamp: timestamp)
            return post
        }
        return nil
    }
}