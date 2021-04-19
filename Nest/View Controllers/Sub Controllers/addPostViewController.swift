//
//  addPostViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/7/21.
//

import UIKit

class addPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //will be sent to posting vc
    var challengeInQuestion: Challenge = Challenge(title: "blank", description: "blank", image: blankUrl!, emoji: "blank", point: 0, hashtag: "blank", keywords: ["blank"])
    
    var imageInQuestion: UIImage = #imageLiteral(resourceName: "loading")
    
    //image picker + Machine Learning stuff
    var imagePicker: UIImagePickerController!
    let mobileNet = NestImageClassifier1()
    
    //when change image button is tapped
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Change Image??", message: "If you decide to change your image, you will have to go through the checking process one more time to ensure that your image matches the challenge. 🤔", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go Back", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Change the Image!", style: .default, handler: { [self] (alertAction) in
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //setting picked editted iamge
        if let pickedImage = info[.editedImage] as? UIImage {
            
            //process it through and convert image to pixel buffer
            if let imagebuffer = MLServices.convertImage(image: pickedImage) {
                
                if let prediction = try? mobileNet.prediction(image: imagebuffer){
                    
                    //putting results into a handy array
                    var resultArray:[String] = []
                    if prediction.classLabel.contains(", ") {
                        resultArray = prediction.classLabel.components(separatedBy: ",")
                    }
                    else {
                        resultArray = [prediction.classLabel]
                    }
                    print(resultArray)
                    
                    let keywords = challengeInQuestion.keywords
                    
                    var isSuccess = false
                    
                    //loop through each result
                    for x in 0..<resultArray.count {
                        let resultInFocus = resultArray[x]
                        
                        //loop through each keyword
                        for y in 0..<keywords.count {
                            let keywordInFocus = keywords[y]
                            
                            //success, if this never runs it means it failed
                            if resultInFocus == keywordInFocus {
                                isSuccess = true
                                imageInQuestion = pickedImage
                                print("result:\(resultInFocus), keyword:\(keywordInFocus), and a success!")
                            }
                        }
                    }
                    
                    //segue to the respective vc depending on success or failure
                    dismiss(animated: true) {
                        if isSuccess {
                            print("success yeeee")
                            self.postImageView.image = self.imageInQuestion
                        }
                        else {
                            print("failed yikes")
                            let alert = UIAlertController(title: "Image does not match 😮", message: "The image did not match the challenge, so we went back to the image you had before!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //when the to the hub button is tapped: post goes into database
    @IBAction func hubButtonTapped(_ sender: Any) {
        
        //checking if a caption and iamge is present
        if let caption = captionTextView.text, !(caption == "type in your caption..."), let image = postImageView.image {
            
            //checking the anonymous status
            var isAnonymous = false
            if anonSwitch.isOn {
                isAnonymous = true
            }
            
            //adding post data to databse
            DatabaseManager.shared.addPost(anonymous: isAnonymous, caption: caption, image: image, hashtag: challengeInQuestion.hashtag) { (success) in
                
                //success
                if success {
                    self.performSegue(withIdentifier: "addToHub", sender: self)
                }
                
                //error happened
                else {
                    self.shakeButton(button: self.hubButton)
                }
            }
            
            print("posted image")
        }
        
        //if caption or image was empty shake button
        else {
            shakeButton(button: hubButton)
        }
    }
    
    //outlets
    @IBOutlet weak var anonSwitch: UISwitch!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var hubButton: UIButton!
    @IBOutlet weak var errorAfterSecondErrorButton: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        //setting caption text view
        captionTextView.delegate = self
        captionTextView.text = "type in your caption..."
        captionTextView.textColor = UIColor.lightGray
        
        //setting the place based on challenge and image
        hashtagLabel.text = "#\(challengeInQuestion.hashtag)"
        postImageView.image = imageInQuestion
        
        //rounded corners
        hubButton.layer.cornerRadius = 15
        postImageView.layer.cornerRadius = 15
        captionTextView.layer.cornerRadius = 15
        
        
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

extension addPostViewController: UITextViewDelegate {
    
    //for the "type in caption..." thing when the user has not typed anything yet
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //purpose is same as above
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "type in your caption..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //if you press enter keyboard disappears
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            captionTextView.resignFirstResponder()
            return false
        }
        return true
    }
}
