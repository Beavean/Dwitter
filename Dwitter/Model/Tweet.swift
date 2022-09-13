//
//  Tweet.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let userID: String
    var likes: Int
    var timestamp: Date!
    let retweets: Int
    var user: User
    var didLike = false
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.userID = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
