//
//  TweetHeader.swift
//  Dwitter
//
//  Created by Beavean on 12.09.2022.
//

import UIKit

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(height: 48, width: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .mainBlue
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@username"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Caption"
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "00:00 00/00/2022"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "→ replying to @user"
        return label
    }()
    
    private lazy var retweetsLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let firstDivider = UIView()
        firstDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(firstDivider)
        firstDivider.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let secondDivider = UIView()
        secondDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(secondDivider)
        secondDivider.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFill
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFill
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFill
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFill
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
    
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc func handleRetweetsTapped() {
        
    }
    
    @objc func handleLikesTapped() {
        
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    //MARK: - Helpers

    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweet.user.fullName
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        
        retweetsLabel.attributedText = viewModel.retweetAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
}
