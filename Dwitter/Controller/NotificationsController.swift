//
//  NotificationsController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit

class NotificationsController: UITableViewController {
    //MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: Constants.notificationCellReuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.notificationCellReuseIdentifier, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        cell.notification = notifications[indexPath.row]
        return cell
    }
}
