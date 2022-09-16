//
//  EditProfileController.swift
//  Dwitter
//
//  Created by Beavean on 16.09.2022.
//

import UIKit

class EditProfileController: UITableViewController {
    
    //MARK: - Properties
    
    private let user: User
    private lazy var headerView = EditProfileHeader(user: user)
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        dismiss(animated: true)

    }
    
    //MARK: - API
    
    
    
    //MARK: - Helpers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        
        navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        
    }
}
