//
//  aboutViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/18/21.
//

import UIKit

class aboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var changedLabel: UILabel!
    
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        if let about = aboutTextView.text, !(about == "typein your bio..."){
            UserProfile.currentUserProfile?.bio = about
            DatabaseManager.shared.reloadCurrentUserData()
            questionLabel.isHidden = true
            aboutTextView.isHidden = true
            changeButton.isHidden = true
            changedLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        //setting feedback text view
        aboutTextView.delegate = self
        aboutTextView.text = "type in your feedback..."
        aboutTextView.textColor = UIColor.lightGray
        
        //rounded corners
        aboutTextView.layer.cornerRadius = 15
        changeButton.layer.cornerRadius = 15
    }
    
}

extension aboutViewController: UITextViewDelegate {
    //for the "type in bio..." thing when the user has not typed anything yet
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //purpose is same as above
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "type in your bio..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //if you press enter keyboard disappears
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            aboutTextView.resignFirstResponder()
            return false
        }
        return true
    }
}
