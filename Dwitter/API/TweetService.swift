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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var values = ["uid": userID,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        switch type {
        case .tweet:
            Constants.tweetsReference.childByAutoId().updateChildValues(values) { error, reference in
                guard let tweetID = reference.key else { return }
                Constants.userTweetsReference.child(userID).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            Constants.tweetRepliesReference.child(tweet.tweetID).childByAutoId().updateChildValues(values) { error, reference in
                guard let replyID = reference.key else { return }
                Constants.userRepliesReference.child(userID).updateChildValues([tweet.tweetID: replyID], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        Constants.tweetsReference.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let userID = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            UserService.shared.fetchUser(userID: userID) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        Constants.userTweetsReference.child(user.userID).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        Constants.tweetsReference.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let userID = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(userID: userID) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        Constants.userRepliesReference.child(user.userID).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            guard let replyID = snapshot.value as? String else { return }
            Constants.tweetRepliesReference.child(tweetID).child(replyID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let userID = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(userID: userID) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    replies.append(tweet)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        Constants.userRepliesReference.child(tweet.tweetID).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            Constants.tweetRepliesReference.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let userID = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                UserService.shared.fetchUser(userID: userID) { user in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        Constants.userLikesReference.child(user.userID).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        Constants.tweetsReference.child(tweet.tweetID).child("likes").setValue(likes)
        if tweet.didLike {
            Constants.userLikesReference.child(userID).child(tweet.tweetID).removeValue { error, reference in
                Constants.tweetLikesReference.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            Constants.userLikesReference.child(userID).updateChildValues([tweet.tweetID: 1]) { error, reference in
                Constants.tweetLikesReference.child(tweet.tweetID).updateChildValues([userID: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Constants.userLikesReference.child(currentUserID).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
