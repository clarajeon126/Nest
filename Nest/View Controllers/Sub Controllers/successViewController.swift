//
//  successViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/10/21.
//

import UIKit

class successViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rounded corners
        shareButton.layer.cornerRadius = 15
        backHomeButton.layer.cornerRadius = 15
        
    }
    

}
