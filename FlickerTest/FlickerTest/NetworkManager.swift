//
//  NetworkManager.swift
//  StateList
//
//  Created by Gnani Naidu on 8/4/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    class func fetchFlickrData(completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        
        let apiUrl: String = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
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
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], let feedItemsArray = json["items"] as? NSArray {
                        var feedItems = [FeedItem]()
                        for feedItemElement in feedItemsArray {
                            if let feedItemDictionary = feedItemElement as? [String: Any] {
                                
                                let feedItem = FeedItem()
                                
                                feedItem.title = feedItemDictionary["title"] as? String
                                feedItem.link = feedItemDictionary["link"] as? String
                                if let mediaDictionary = feedItemDictionary["media"] as? [String: Any], let media = mediaDictionary["m"] as? String {
                                    feedItem.media = media
                                }
                                feedItem.dateTaken = feedItemDictionary["date_taken"] as? String
                                feedItem.feedDescription = feedItemDictionary["description"] as? String
                                feedItem.publishedOn = (feedItemDictionary["published"] as? String)?.convertDateFromServerStringToMediumFormatString()
                                
                                feedItem.author = (feedItemDictionary["author"] as? String)?.authorHandleFromAuthorString()
                                feedItem.authorId = feedItemDictionary["author_id"] as? String
                                feedItem.tags = feedItemDictionary["tags"] as? String

                                feedItems.append(feedItem)
                            }
                        }
                        completion(feedItems, nil)
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
    
    func authorHandleFromAuthorString() -> String {
        
        let selfNSString = NSString(string: self)
        let pattern = "\\\".+\\\""
        
        let range = selfNSString.range(of: pattern, options: .regularExpression)
        
        let subString = selfNSString.substring(with: NSMakeRange(range.location+1, range.length-2))
        return subString
    }
    
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
