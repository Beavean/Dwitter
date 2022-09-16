//
//  User.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import Foundation
import Firebase

struct User {
    
    let fullName: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let userID: String
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == userID
    }
    
    init(userID: String, dictionary: [String: AnyObject]) {
        self.userID = userID
        
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
