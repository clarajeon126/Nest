//
//  oopsViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/10/21.
//

import UIKit

class oopsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //will be sent to posting vc
    var challengeInQuestion: Challenge = Challenge(title: "blank", description: "blank", image: blankUrl!, emoji: "blank", point: 0, hashtag: "blank", keywords: ["blank"])
    
    var imageTaken: UIImage = #imageLiteral(resourceName: "loading")
    
    var numInPersonalChallengeArray = 0
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backToHomeButton: UIButton!
    @IBOutlet weak var secondTimeErrorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rounded corners
        tryAgainButton.layer.cornerRadius = 15
        backToHomeButton.layer.cornerRadius = 15
        
    }
    
    //image picker + Machine Learning stuff
    var imagePicker: UIImagePickerController!
    let mobileNet = NestImageClassifier1()
    
    //submit button tapped should prompt a image picker
    @IBAction func picToSubmit(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
                                imageTaken = pickedImage
                                print("result:\(resultInFocus), keyword:\(keywordInFocus), and a success!")
                            }
                        }
                    }
                    
                    //segue to the respective vc depending on success or failure
                    dismiss(animated: true) {
                        if isSuccess {
                            self.performSegue(withIdentifier: "oopsToSuccess", sender: self)
                        }
                        else {
                            self.secondTimeErrorMessage.isHidden = false
                        }
                    }
                }
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //prepare segue for success vc
        if segue.identifier == "oopsToSuccess"{
            let destination = segue.destination as! successViewController
            destination.challengeInQuestion = self.challengeInQuestion
            destination.imageInQuestion = imageTaken
            destination.numInPersonalChallengeArray = self.numInPersonalChallengeArray
        }
    }
}
