//
//  MainTabController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {

    //MARK: - Properties
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .mainBlue
        button.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBlue
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navigation = UINavigationController(rootViewController: LoginController())
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true)
            }
        } else {
            configureViewControllers()
            configureUI()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error)")
        }
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2 
    }
    
    func configureViewControllers() {
        let feedNavigation = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: FeedController())
        let exploreNavigation = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: ExploreController())
        let notificationsNavigation = templateNavigationController(image: UIImage(systemName: "bell"), rootViewController: NotificationsController())
        let conversationsNavigation = templateNavigationController(image: UIImage(systemName: "envelope"), rootViewController: ConversationsController())
        viewControllers = [feedNavigation, exploreNavigation, notificationsNavigation, conversationsNavigation]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
        navigation.navigationBar.barTintColor = .white
        return navigation
    }
}
