//
//  AuthenticationService.swift
//  Dwitter
//
//  Created by Beavean on 07.09.2022.
//

import UIKit
import Firebase

struct AuthenticationCredentials {
    let email: String
    let password: String
    let fullName: String
    let username: String
    let profileImage: UIImage
}

struct AuthenticationService {
    
    static let shared = AuthenticationService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthenticationCredentials, completion: @escaping(Error?, DatabaseReference) -> Void ) {
        let email = credentials.email
        let password = credentials.password
        let fullName = credentials.fullName
        let username = credentials.username
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageReference = Constants.profileImagesStorage.child(fileName)
        storageReference.putData(imageData, metadata: nil) { metaData, error in
            storageReference.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    guard let userID = result?.user.uid else { return }
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullName,
                                  "profileImageUrl": profileImageUrl]
                    Constants.referenceUsers.child(userID).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
