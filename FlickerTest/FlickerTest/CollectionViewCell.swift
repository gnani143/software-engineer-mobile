//
//  CollectionViewCell.swift
//  FlickerTest
//
//  Created by Gnani Naidu on 8/4/17.
//  Copyright © 2017 Loktra. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var flickrPic: UIImageView!
    @IBOutlet private weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderColor = UIColor.blue.cgColor
        borderView.layer.borderWidth = 4.0
        borderView.layer.masksToBounds = false
        borderView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flickrPic.image = nil
        borderView.isHidden = true
    }
    
    func bindCellData(feedItem: FeedItem) {
        if let media = feedItem.media {
            
            if let url = URL(string: media) {
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                    if error != nil {
                        print("some error!")
                    } else {
                        if let image = UIImage(data: data!) {
                            DispatchQueue.main.async {
                                self.flickrPic.image = image
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    func createBorder() {
        borderView.isHidden = false
    }
    
    func removeBorder() {
        borderView.isHidden = true
    }
    
}
