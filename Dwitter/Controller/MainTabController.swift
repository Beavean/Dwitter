//
//  MainTabController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {

    //MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    var user: User? {
        didSet {
            guard let navigation = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = navigation.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .mainBlue
        button.setImage(UIImage(systemName: "plus"), for: .normal)
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
    
    func fetchUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(userID: userID) { user in
            self.user = user
        }
    }
    
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
            fetchUser()
        }
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        let controller: UIViewController
        switch buttonConfig {
        case .message:
            controller = SearchController(config: .messages)
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user, config: .tweet)
        }
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        self.delegate = self
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2 
    }
    
    func configureViewControllers() {
        let feedNavigation = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let exploreNavigation = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: SearchController(config: .userSearch))
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

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let imageName = index == 3 ? "envelope" : "plus"
        self.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
    }
}
