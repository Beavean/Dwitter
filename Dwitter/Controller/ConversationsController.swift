//
//  ConversationsController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit

class ConversationsController: UIViewController {
    //MARK: - Properties
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        SearchController(config: .messages).delegate = self
    }
    
    //MARK: - Selectors
    
    
    
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}

//MARK: - SearchControllerDelegate

extension ConversationsController: SearchControllerDelegate {
    func controller(_ controller: SearchController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}
