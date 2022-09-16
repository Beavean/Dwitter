//
//  EditProfileViewModel.swift
//  Dwitter
//
//  Created by Beavean on 16.09.2022.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullName:
            return "Username"
        case .username:
            return "Name"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullName:
            return user.fullName
        case .username:
            return user.username
        case .bio:
            return user.bio
            
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
