//
//  TableViewCell.swift
//  GithubTest
//
//  Created by Nveen Bandlamoodi on 10/4/17.
//  Copyright © 2017 Loktra. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var shaLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.layer.masksToBounds = true
    }
    
    func bindData(withCommit commit: Commit, rowIndex: Int) {
        
        authorNameLabel.text = commit.authorName
        shaLabel.text = commit.sha
        messageLabel.text = commit.commitMessage
        timeLabel.text = commit.commitDate
        avatarImageView.image = UIImage(named: "avatarPlaceholder")
        let weakRowIndex = rowIndex
        
        if let authorAvatarUrl = commit.authorAvatarUrl {
            if let url = URL(string: authorAvatarUrl) {
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                    if error == nil {
                        if let image = UIImage(data: data!), weakRowIndex == rowIndex {
                            DispatchQueue.main.async {
                                self.avatarImageView.image = image
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
}
