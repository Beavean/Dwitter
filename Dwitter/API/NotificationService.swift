//
//  NotificationService.swift
//  Dwitter
//
//  Created by Beavean on 14.09.2022.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": userID,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            Constants.notificationsReference.child(tweet.user.userID).childByAutoId().updateChildValues(values)
        } else if let user = user {
            Constants.notificationsReference.child(user.userID).childByAutoId().updateChildValues(values)
        }
    }
}
