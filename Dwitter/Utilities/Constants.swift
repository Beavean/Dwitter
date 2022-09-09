//
//  Constants.swift
//  Dwitter
//
//  Created by Beavean on 07.09.2022.
//

import Firebase

struct Constants {
    
    static let databaseReference = Database.database().reference()
    static let referenceUsers = databaseReference.child("users")
    static let storageReference = Storage.storage().reference()
    static let profileImagesStorage = storageReference.child("profile_images")
    static let tweetsReference = databaseReference.child("tweets")
    
    static let tweetCellReuseIdentifier = "TweetCell"
    static let profileHeaderReuseIdentifier = "ProfileHeader"
    static let profileFilterCellReuseIdentifier = "ProfileFilterCell"
}
