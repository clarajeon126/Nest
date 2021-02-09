//
//  PostTableViewCell.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var overallView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userFirstLastName: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var numOtherCommentsLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        overallView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
