////
//  ViewController.swift
//  Nest
//
//  Created by Uditi Sharma on 23/01/2021.
//

import UIKit
import Vision


class CheckWorkViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var challengeInQuestion: Challenge = Challenge(title: "blank", description: "blank", image: blankUrl!, emoji: "blank", point: 0, hashtag: "blank", keywords: ["blank"])
    var imageTaken: UIImage = #imageLiteral(resourceName: "loading")
    var numInPersonalChallengeArray = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inspirationButton: UIButton!
    @IBOutlet weak var takeAPicButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting text labels for title and description
        titleLabel.text = "\(challengeInQuestion.title) \(challengeInQuestion.emoji)"
        descriptionLabel.text = challengeInQuestion.description
        
        //setting inspo button text plus text design details
        inspirationButton.setTitle("Look for inspiration on #\(challengeInQuestion.hashtag)", for: .normal)
        inspirationButton.titleLabel?.lineBreakMode = .byClipping
        inspirationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //setting round corners
        descriptionLabel.layer.masksToBounds = true //needed bc overlapping i think
        descriptionLabel.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 15
        inspirationButton.layer.cornerRadius = 15
        takeAPicButton.layer.cornerRadius = 15
        
        //setting image
        ImageService.getImage(withURL: challengeInQuestion.image) { (image, url) in
            self.imageView.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    //image picker + Machine Learning stuff
    var imagePicker: UIImagePickerController!
    let mobileNet = MobileNetV2()
    
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
                            self.performSegue(withIdentifier: "challengeToSuccess", sender: self)
                        }
                        else {
                            self.performSegue(withIdentifier: "challengeToOops", sender: self)
                        }
                    }
                }
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //prepare segue for success vc
        if segue.identifier == "challengeToSuccess"{
            let destination = segue.destination as! successViewController
            destination.challengeInQuestion = self.challengeInQuestion
            destination.imageInQuestion = imageTaken
            destination.numInPersonalChallengeArray = self.numInPersonalChallengeArray
        }
        
        //prepare for oops vc
        else if segue.identifier == "challengeToOops"{
            let destination = segue.destination as! oopsViewController
            destination.challengeInQuestion = self.challengeInQuestion
            destination.numInPersonalChallengeArray = self.numInPersonalChallengeArray
        }
    }
}
