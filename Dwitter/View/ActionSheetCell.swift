//
//  ActionSheetCell.swift
//  Dwitter
//
//  Created by Beavean on 13.09.2022.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
        iv.tintColor = .mainBlue
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Option"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 8)
        optionImageView.setDimensions(height: 36, width: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    
    //MARK: - Helpers
    
    func configure() {
        titleLabel.text = option?.description
    }

}
