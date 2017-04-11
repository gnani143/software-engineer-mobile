//
//  NetworkManager.swift
//  StateList
//
//  Created by Gnani Naidu on 8/4/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    class func fetchGithubCommits(completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        
        let apiUrl: String = "https://api.github.com/repos/rails/rails/commits"
        guard let url = URL(string: apiUrl) else {
            completion(nil, NSError(domain: "Error url", code: 400, userInfo: ["error_message": "Url is not valid"]))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard let _ = error else {
                do {
                    if let commitsArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                        var commits = [Commit]()
                        for commitItem in commitsArray {
                            if let commitItemDictionary = commitItem as? [String: Any] {
                                
                                let commit = Commit()
                                
                                commit.sha = commitItemDictionary["sha"] as? String
                                if let commitDictionary = commitItemDictionary["commit"] as? [String: Any] {
                                    commit.commitMessage = commitDictionary["message"] as? String
                                    if let authorDictionary = commitDictionary["author"] as? [String: Any] {
                                        commit.authorName = authorDictionary["name"] as? String
                                        commit.commitDate = (authorDictionary["date"] as? String)?.convertDateFromServerStringToMediumFormatString()
                                    }
                                }
                                if let authorDictionary = commitItemDictionary["author"] as? [String: Any] {
                                    commit.authorAvatarUrl = authorDictionary["avatar_url"] as? String
                                }

                                commits.append(commit)
                            }
                        }
                        completion(commits, nil)
                    } else {
                        completion(nil, NSError(domain: "Response error", code: 400, userInfo: ["error_message": "Invalid response"]))
                    }
                } catch  {
                    completion(nil, NSError(domain: "JSON error", code: 400, userInfo: ["error_message": "Invalid JSON"]))
                    return
                }
                return
            }
            completion(nil, error)
        })
        task.resume()
    }

}

extension String {
    
    func convertDateFromServerStringToMediumFormatString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'" // "2017-04-09T11:53:44Z"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "d MMM yyyy, hh:mm a"
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
}
