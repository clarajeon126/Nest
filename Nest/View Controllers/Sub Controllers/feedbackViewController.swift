//
//  feedbackViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/18/21.
//

import UIKit

class feedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if let feedback = feedbackTextView.text, !(feedback == "type in your feedback..."){
            DatabaseManager.shared.insertFeedback(feedback: feedback) { [self] (success) in
                if success {
                    titleLabel.isHidden = true
                    feedbackTextView.isHidden = true
                    submitButton.isHidden = true
                    thankYouLabel.isHidden = false
                }
            }
        }
        else {
            shakeButton(button: submitButton)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //setting feedback text view
        feedbackTextView.delegate = self
        feedbackTextView.text = "type in your feedback..."
        feedbackTextView.textColor = UIColor.lightGray
        
        //rounded corners
        feedbackTextView.layer.cornerRadius = 15
        submitButton.layer.cornerRadius = 15
        
    }
    
    //shake a button
    func shakeButton(button: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        button.layer.add(animation, forKey: "shake")
    }
}

extension feedbackViewController: UITextViewDelegate {
    //for the "type in feedback..." thing when the user has not typed anything yet
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //purpose is same as above
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "type in your feedback..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //if you press enter keyboard disappears
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            feedbackTextView.resignFirstResponder()
            return false
        }
        return true
    }
}
