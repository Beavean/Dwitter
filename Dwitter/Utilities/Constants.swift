//
//  Constants.swift
//  Dwitter
//
//  Created by Beavean on 07.09.2022.
//

import Firebase

struct Constants {
    
    static let databaseReference = Database.database().reference()
    static let usersReference = databaseReference.child("users")
    static let storageReference = Storage.storage().reference()
    static let profileImagesStorage = storageReference.child("profile_images")
    static let tweetsReference = databaseReference.child("tweets")
    static let userTweetsReference = databaseReference.child("user-tweets")
    static let userFollowersReference = databaseReference.child("user-followers")
    static let userFollowingReference = databaseReference.child("user-following")
    static let tweetRepliesReference = databaseReference.child("tweet-replies")
    static let userLikesReference = databaseReference.child("user-likes")
    static let tweetLikesReference = databaseReference.child("tweet-likes")
    static let notificationsReference = databaseReference.child("notifications")
    static let userRepliesReference = databaseReference.child("user-replies")
    static let userUsernameReference = databaseReference.child("user-usernames")

    static let tweetCellReuseIdentifier = "TweetCell"
    static let profileHeaderReuseIdentifier = "ProfileHeader"
    static let tweetHeaderReuseIdentifier = "TweetHeader"
    static let profileFilterCellReuseIdentifier = "ProfileFilterCell"
    static let userCellReuseIdentifier = "UserCell"
    static let actionSheetCellReuseIdentifier = "ActionSheetCell"
    static let notificationCellReuseIdentifier = "NotificationCell"
    static let editProfileCellReuseIdentifier = "EditProfileCell"
    static let messageCellReuseId = "MessageCell"
}
