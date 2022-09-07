//
//  FeedController.swift
//  Dwitter
//
//  Created by Beavean on 05.09.2022.
//

import UIKit

class FeedController: UIViewController {
    //MARK: - Properties
    
    
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
}
