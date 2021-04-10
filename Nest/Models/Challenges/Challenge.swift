//
//  challenges.swift
//  Nest
//
//  Created by Clara Jeon on 1/23/21.
//

import Foundation

public class Challenge {
    var title: String
    var description: String
    var image: URL
    var emoji: String
    var point:Int
    var hashtag:String
    var keywords:[String]
    
    required init(title: String, description: String, image: URL, emoji: String, point: Int, hashtag: String, keywords:[String]) {
        self.title = title
        self.description = description
        self.image = image
        self.emoji = emoji
        self.point = point
        self.hashtag = hashtag
        self.keywords = keywords
        
    }
    
    //parse through json data from firebase
    static func parse(_ data: [String:Any], completion: @escaping (_ challenge: Challenge)->()){
        if let title = data["title"] as? String,
           let description = data["description"] as? String,
           let imageAsString = data["image"] as? String,
           let image = URL(string: imageAsString),
           let emoji = data["emoji"] as? String,
           let point = data["point"] as? Int,
           let hashtag = data["hashtag"] as? String,
           let keyword = data["keyword"] as? [String]{
            
            
            //create a challenge
            let newChallenge = Challenge(title: title, description: description, image: image, emoji: emoji, point: point, hashtag: hashtag, keywords: keyword)
            
            completion(newChallenge)
        }
    }
}
