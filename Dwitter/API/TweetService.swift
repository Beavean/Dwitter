//
//  TweetService.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let values = ["uid": userId,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        Constants.tweetsReference.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
