//
//  ProfileViewController.swift
//  Nest
//
//  Created by Clara Jeon on 1/30/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userPostsCollectionView: UICollectionView!
    
    var userPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounded corners
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        //setting current user as the current user profile
        guard let currentUser = UserProfile.currentUserProfile else {
            return
        }
        
        //setting everything as the one from the current user
        ImageService.getImage(withURL: currentUser.profilePhotoUrl) { (image, url) in
            self.profileImageView.image = image
        }
        
        userNameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
        
        pointLabel.text = "\(currentUser.points) points"
        bioLabel.text = currentUser.bio
        
        //setting collection view stuff
        userPostsCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        userPostsCollectionView.dataSource = self
        userPostsCollectionView.delegate = self
        userPostsCollectionView.collectionViewLayout = ProfileViewController.createLayout()
        
        DatabaseManager.shared.arrayOfPostsByUser { (posts) in
            self.userPosts = posts
            self.userPostsCollectionView.reloadData()
        }
    }
    
    //layout for collection view looks veryyyy cool
    static func createLayout() -> UICollectionViewCompositionalLayout {
        //items
        let twoByTwo = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))

        let insets:CGFloat = 6
        
        //padding for the cells
        twoByTwo.contentInsets = NSDirectionalEdgeInsets(top: insets, leading: insets, bottom: insets, trailing: insets)

        
        let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitems: [twoByTwo])

        
        
        let section = NSCollectionLayoutSection(group: finalGroup)
        
        return UICollectionViewCompositionalLayout(section: section)
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userPostsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        cell.set(post: userPosts[indexPath.row])
        
        return cell
    }
    
}
