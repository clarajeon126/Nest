//
//  HubViewController.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import UIKit

class HubViewController: UIViewController {

    @IBOutlet weak var hubCollectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hubCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        hubCollectionView.dataSource = self
        hubCollectionView.delegate = self
        hubCollectionView.collectionViewLayout = HubViewController.createLayout()
        
        refreshControl = UIRefreshControl()
        
        if #available(iOS 10.0, *) {
            hubCollectionView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            hubCollectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(reloadCollectionViewData), for: .valueChanged)
        reloadCollectionViewData()
    }
    
    
    //refresh the data and update collection view data
    @objc func reloadCollectionViewData(){
        print("here")
        DatabaseManager.shared.arrayOfPostByTime { (postArray) in
            print(postArray)
            self.posts = postArray
            self.hubCollectionView.reloadData()
        }
        refreshControl.endRefreshing()
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
extension HubViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hubCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        cell.set(post: posts[indexPath.row])
        
        return cell
    }
    
}
