//
//  UserService.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import Foundation
import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(userID: String, completion: @escaping(User ) -> Void) {
        Constants.referenceUsers.child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(userID: userID, dictionary: dictionary)
            completion(user)
        }
    }
}
