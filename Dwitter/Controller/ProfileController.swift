//
//  ProfileController.swift
//  Dwitter
//
//  Created by Beavean on 09.09.2022.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { tweets in
            self.replies = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(userID: user.userID) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(userID: user.userID) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: Constants.tweetCellReuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.profileHeaderReuseIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.tweetCellReuseIdentifier, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.profileHeaderReuseIdentifier, for: indexPath) as? ProfileHeader else { return UICollectionReusableView() }
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 300
        if user.bio != nil {
            height += 50
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true)
            return
        }
        if user.isFollowed {
            UserService.shared.unFollowUser(userID: user.userID) { error, reference in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(userID: user.userID) { reference, error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        self.collectionView.reloadData()
    }
}
