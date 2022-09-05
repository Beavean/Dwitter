//
//  MainTabController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit

class MainTabController: UITabBarController {

    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    //MARK: - Helpers
    
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
