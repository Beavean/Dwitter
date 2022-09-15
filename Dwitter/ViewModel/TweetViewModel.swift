//
//  TweetViewModel.swift
//  Dwitter
//
//  Created by Beavean on 09.09.2022.
//

import UIKit

struct TweetViewModel {
    
    //MARK: - Properties
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "0s"
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }

    var retweetAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweets, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")

    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username.lowercased())", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " • \(timestamp) ago", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "heart.fill" : "heart"
        guard let image = UIImage(systemName: imageName) else { return UIImage() }
        return image
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUsername = tweet.replyingTo else { return nil }
        return "→ replying to @\(replyingToUsername)"

    }
    //MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    //MARK: - Helpers
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
