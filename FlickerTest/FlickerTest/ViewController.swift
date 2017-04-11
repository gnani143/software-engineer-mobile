//
//  ViewController.swift
//  FlickerTest
//
//  Created by Gnani Naidu on 8/4/17.
//  Copyright © 2017 Loktra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var feedItems: [FeedItem]?
    
    var isFetching: Bool = false
    
    var selectedSection: Int?
    var selectedIndex: Int?
    var selectedCell: CollectionViewCell?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        
        collectionView.register(CollectionCellDescriptionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectionCellDescriptionView")
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = self.view.center
        self.navigationItem.titleView = self.activityIndicator
        
        fetchFlickrData()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.refreshTapped))
        self.navigationItem.rightBarButtonItem = refreshButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fetchFlickrData() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.startAnimating()
        isFetching = true
        NetworkManager.fetchFlickrData { (response, error) in
            self.activityIndicator.stopAnimating()
            self.navigationItem.titleView = nil
            self.isFetching = false
            guard let _ = error else {
                if let feedItems = response as? [FeedItem] {
                    self.feedItems = feedItems
                    self.collectionView.reloadData()
                }
                return
            }
            let alert = UIAlertController(title: "Oops!! Something is wrong", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { (action) in
                self.refreshTapped()
            }))
            self.show(alert, sender: self)
        }
    }
    
    func refreshTapped() {
        if !isFetching {
            self.fetchFlickrData()
        }
    }
    
    // MARK: UICollectionView methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let feedItems = self.feedItems {
            return feedItems.count/2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let feedItems = self.feedItems {
            if (feedItems.count >= (section+1)*2) {
                return 2
            }
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowIndex = indexPath.section*2+indexPath.row
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell, let feedItems = self.feedItems, rowIndex < feedItems.count {
            cell.bindCellData(feedItem: feedItems[rowIndex])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSection = indexPath.section; selectedIndex = (indexPath.section*2)+indexPath.row;
        
        collectionView.performBatchUpdates({
            collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }) { (complete) in
            if let selectedCell = self.selectedCell {
                selectedCell.removeBorder()
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.createBorder()
                self.selectedCell = cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter, let collectionCellDescriptionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionCellDescriptionView", for: indexPath) as? CollectionCellDescriptionView, let feedItems = self.feedItems, let selectedIndex = self.selectedIndex, selectedIndex < feedItems.count {
            
            let feedItem = feedItems[selectedIndex]
            
            collectionCellDescriptionView.bindData(title: feedItem.title, author: feedItem.author, publishedOn: feedItem.publishedOn, tags: feedItem.tags, rowIndex: selectedIndex)

            return collectionCellDescriptionView

        }
        return UICollectionReusableView(frame: CGRect.zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let selectedSection = self.selectedSection, let selectedIndex = self.selectedIndex, selectedSection == section, let feedItems = self.feedItems, selectedIndex < feedItems.count {
            
            let feedItem = feedItems[selectedIndex]
            let height = CollectionCellDescriptionView.heightOfTheView(withWidth: collectionView.frame.width, WithTitle: feedItem.title, author: feedItem.author, publishedOn: feedItem.publishedOn, tags: feedItem.tags)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        return CGSize.zero
    }
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (10.0 * UIScreen.main.bounds.width / 320.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (10.0 * UIScreen.main.bounds.width / 320.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((UIScreen.main.bounds.width - (30.0 * UIScreen.main.bounds.width / 320.0))/2)
        return CGSize(width: width, height: width)
    }
}

