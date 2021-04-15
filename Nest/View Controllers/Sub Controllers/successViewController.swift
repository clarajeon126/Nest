//
//  successViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/10/21.
//

import UIKit

class successViewController: UIViewController {

    //will be sent to posting vc
    var challengeInQuestion: Challenge = Challenge(title: "blank", description: "blank", image: blankUrl!, emoji: "blank", point: 0, hashtag: "blank", keywords: ["blank"])
    
    var imageInQuestion: UIImage = #imageLiteral(resourceName: "loading")
    
    var numInPersonalChallengeArray = 0
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rounded corners
        shareButton.layer.cornerRadius = 15
        backHomeButton.layer.cornerRadius = 15
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //adding the points to firebase data, updating the array wiht challenges, and updating info on firebase
        print("number in personal challenge that was completed: \(numInPersonalChallengeArray)")
        UserProfile.currentUserProfile?.points += 10
        UserProfile.currentUserProfile?.replaceASingleChallenge(index: numInPersonalChallengeArray)
        DatabaseManager.shared.reloadCurrentUserData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successToPost" {
            let destination = segue.destination as! addPostViewController
            destination.challengeInQuestion = self.challengeInQuestion
            destination.imageInQuestion = self.imageInQuestion
        }
    }
    

}
