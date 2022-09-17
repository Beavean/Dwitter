//
//  UploadTweetController.swift
//  Dwitter
//
//  Created by Beavean on 08.09.2022.
//

import UIKit
import ActiveLabel

class UploadTweetController: UIViewController {
    
    //MARK: - Properties
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(height: 48, width: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .mainBlue
        return imageView
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .mainBlue
        label.text = "Replying to @username"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    //MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
    }
    
    //MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { error, reference in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply, tweetID: tweet.tweetID)
            }
            self.uploadMentionNotification(forCaption: caption, tweetID: reference.key)
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - API
    
    fileprivate func uploadMentionNotification(forCaption caption: String, tweetID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            UserService.shared.fetchUser(withUsername: username) { user in
                NotificationService.shared.uploadNotification(toUser: user, type: .mention, tweetID: tweetID)
            }
        }
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .white
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        view.addSubview(imageCaptionStack)
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
         navBarAppearance.configureWithOpaqueBackground()
         navBarAppearance.backgroundColor = .white
         navigationController?.navigationBar.standardAppearance = navBarAppearance
         navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .mainBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
        }
    }
}
