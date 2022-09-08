//
//  FeedController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    //MARK: - Properties
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"))
        imageView.tintColor = .mainBlue
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 50, width: 50)
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        let profileImageView = UIImageView()
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
