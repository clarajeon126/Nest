//
//  hashtagViewController.swift
//  Nest
//
//  Created by Clara Jeon on 4/18/21.
//

import UIKit

class hashtagViewController: UIViewController {

    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var hashtagCollectionView: UICollectionView!
    @IBOutlet weak var noPostsErrorMessage: UIView!
    var hashtag = ""
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(reloadCollectionViewNotif(_:)),
                                                   name: .reloadProfileView,
                                                   object: nil)
        
        //set up collection view
        hashtagCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        hashtagCollectionView.dataSource = self
        hashtagCollectionView.delegate = self
        hashtagCollectionView.collectionViewLayout = HubViewController.createLayout()
        arrayUpdateAndReload()
        
        //rounded corners
        noPostsErrorMessage.layer.cornerRadius = 15
        
        //
        hashtagLabel.text = "#\(hashtag)"
        
    }
    
    @objc private func reloadCollectionViewNotif(_ notification: Notification) {
        // Update screen after user successfully signed in
        print("inside notif")
        arrayUpdateAndReload()
    }
    

    func arrayUpdateAndReload(){
        DatabaseManager.shared.arrayOfPostsByHashtag(hashtag: hashtag) { (posts) in
            if posts.count == 0{
                self.noPostsErrorMessage.isHidden = false
            }
            self.posts = posts
            self.hashtagCollectionView.reloadData()
        }
    }
    
    //layout for collection view looks veryyyy cool
    static func createLayout() -> UICollectionViewCompositionalLayout {
        //items
        let twoByTwo = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        
        let oneByOne = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1/2)))
        
        let twoByOne = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1)))
        
        let oneByTwo = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/2)))
        
        let insets:CGFloat = 6
        
        //padding for the cells
        twoByTwo.contentInsets = NSDirectionalEdgeInsets(top: insets, leading: insets, bottom: insets, trailing: insets)
        oneByOne.contentInsets = NSDirectionalEdgeInsets(top: insets, leading: insets, bottom: insets, trailing: insets)
        twoByOne.contentInsets = NSDirectionalEdgeInsets(top: insets, leading: insets, bottom: insets, trailing: insets)
        oneByTwo.contentInsets = NSDirectionalEdgeInsets(top: insets, leading: insets, bottom: insets, trailing: insets)

        
        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1/2)),
                                                        subitem: oneByTwo, count: 2)
        
        let group3 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1/2),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitem: twoByTwo, count: 2)
        
        let group5 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitems: [twoByOne, group3])
        
        let group6 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitems: [group3, twoByOne])
        let group7 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitems: [twoByOne, twoByOne])
        let group8 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)),
                                                        subitems: [group3, group3])
        let group9 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalWidth(1)),
                                                    subitems: [oneByTwo, oneByTwo])
        let group10 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalWidth(1)),
                                                    subitems: [group2, oneByTwo])
        let group11 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalWidth(1)),
                                                    subitems: [oneByTwo, group2])
        
        let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(11)),
                                                        subitems: [oneByTwo, twoByTwo, group5, group9, group11, twoByTwo, group8, group7, group10, twoByTwo, group6, oneByTwo])

        
        
        let section = NSCollectionLayoutSection(group: finalGroup)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension hashtagViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hashtagCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        cell.mainView.backgroundColor = lightCyanColor
        cell.hashtagButton.backgroundColor = lightOrangeColor
        let postInQuestion = posts[indexPath.row]
        
        let postAuthor = postInQuestion.author
        
        let userUid = UserProfile.currentUserProfile?.uid
        
        let isUsersPost = postAuthor == userUid
        
        if isUsersPost {
            cell.set(post: postInQuestion, isUsers: true)
        }
        else {
            cell.set(post: postInQuestion, isUsers: false)
        }
        
        
        return cell
    }
    
}
