//
//  UserService.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(userID: String, completion: @escaping(User) -> Void) {
        Constants.referenceUsers.child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(userID: userID, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Constants.referenceUsers.observe(.childAdded) { snapshot in
            let userID = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(userID: userID, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(userID: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Constants.userFollowingReference.child(currentUserID).updateChildValues([userID: 1]) { error, reference in
            Constants.userFollowersReference.child(userID).updateChildValues([currentUserID: 1], withCompletionBlock: completion)
        }
    }
    
    func unFollowUser(userID: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Constants.userFollowingReference.child(currentUserID).child(userID).removeValue { error, reference in
            Constants.userFollowersReference.child(userID).child(currentUserID).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(userID: String, completion: @escaping(Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Constants.userFollowingReference.child(currentUserID).child(userID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(userID: String, completion: @escaping(UserRelationStats) -> Void) {
        Constants.userFollowersReference.child(userID).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            Constants.userFollowingReference.child(userID).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
