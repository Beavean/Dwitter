//
//  NotificationsController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit

class NotificationsController: UIViewController {
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}
