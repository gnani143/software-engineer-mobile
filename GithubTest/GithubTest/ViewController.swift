//
//  ViewController.swift
//  GithubTest
//
//  Created by Nveen Bandlamoodi on 10/4/17.
//  Copyright © 2017 Loktra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    private var commits: [Commit]?
    private var isFetching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        self.navigationItem.title = "Home"
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = self.view.center
        self.navigationItem.titleView = self.activityIndicator
        
        fetchGithubCommits()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.refreshTapped))
        self.navigationItem.rightBarButtonItem = refreshButton

    }
    
    private func fetchGithubCommits() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.startAnimating()
        isFetching = true
        NetworkManager.fetchGithubCommits { (response, error) in
            self.activityIndicator.stopAnimating()
            self.navigationItem.titleView = nil
            self.isFetching = false
            guard let _ = error else {
                if let commits = response as? [Commit] {
                    self.commits = commits
                    self.tableView.reloadData()
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
            self.fetchGithubCommits()
        }
    }
    
    // MARK: UITableView datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commits = self.commits {
            return commits.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell, let commits = self.commits, indexPath.row < commits.count {
            let commit = commits[indexPath.row]
            cell.bindData(withCommit: commit, rowIndex: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

