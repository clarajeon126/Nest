//
//  oopsViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/10/21.
//

import UIKit

class oopsViewController: UIViewController {

    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backToHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rounded corners
        tryAgainButton.layer.cornerRadius = 15
        backToHomeButton.layer.cornerRadius = 15
        
    }
    
}
