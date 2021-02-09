//
//  challenges.swift
//  Nest
//
//  Created by Clara Jeon on 1/23/21.
//

import Foundation

public class challenges {
    var titleOfChallenge: String
    var descriptionOfChallenge: String
    var imageOfChallenge: String
    var emojiOfChallenge: String
    var pointValue:Int
    var keywords:String
    
    required init(title: String, description: String, image: String, emoji: String, point: Int, keyword:String) {
        titleOfChallenge = title
        descriptionOfChallenge = description
        imageOfChallenge = image
        emojiOfChallenge = emoji
        pointValue = point
        keywords = keyword
        
    }
}
