//
//  Post.swift
//  Nest
//
//  Created by Clara Jeon on 2/9/21.
//

import Foundation
import UIKit


//Post class that creates  post and stores that info it needs so it can send and parse it from and to firebase
public class Post {
    var id: String
    var author: String
    var postImage: URL
    var postCaption: String
    var createdAt: Date
    var hashtag: String
    
    init(id: String, author: String, postImage: URL, postCaption:String, timestamp: Double, hashtag: String){
        self.id = id
        self.author = author
        self.postImage = postImage
        self.postCaption = postCaption
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        self.hashtag = hashtag
    }
    
    
    //parse the json data retrieved fom firebase into a Post
    static func parse(_ key: String, _ data: [String:Any], completion: @escaping (_ post: Post)->()){
        if let uid = data["author"] as? String,
           let postImageUrlAsString = data["postImageUrl"] as? String,
           let postImageUrl = URL(string: postImageUrlAsString),
           let postCaption = data["postCaption"] as? String,
           let timestamp = data["timestamp"] as? Double,
           let hashtag = data["hashtag"] as? String{
            
            let post = Post(id: key, author: uid, postImage: postImageUrl, postCaption: postCaption, timestamp: timestamp, hashtag: hashtag)
            
            completion(post)
        }
    }
}
