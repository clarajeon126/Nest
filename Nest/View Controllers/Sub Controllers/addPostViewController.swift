//
//  addPostViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/7/21.
//

import UIKit

class addPostViewController: UIViewController {

    @IBAction func changeImageButtonTapped(_ sender: Any) {
    }
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        captionTextView.layer.cornerRadius = 15
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
