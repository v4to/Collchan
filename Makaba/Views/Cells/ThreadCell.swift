//
//  ThreadCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 24.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadCell: BoardsListTableViewCell {
    
    /*
    static func preferredHeightForThread(_ thread: Thread, andWidth width: CGFloat) -> CGFloat {
        let padding: CGFloat = 15.0
        let thumbnailWidth: CGFloat = 80.0
        var totalHeight: CGFloat = padding
        let textWidthAvailable = width - padding * 3 - thumbnailWidth
        var totalTextHeightAddition: CGFloat = 0.0
        var headingStringHeight: CGFloat = 0.0
        if thread.posts[0].subject.count > 0 {
            let headingString = thread.posts[0].subject
            headingStringHeight += heightForHeading(headingString, width: textWidthAvailable)
            
        }
        totalTextHeightAddition += headingStringHeight
        totalTextHeightAddition += padding
        var commentStringHeight: CGFloat = 0.0
        if thread.posts[0].comment.count > 0 {
            let commentString = thread.posts[0].comment
            commentStringHeight += heightForComment(commentString, width: textWidthAvailable)
        }
        totalTextHeightAddition += commentStringHeight
        totalTextHeightAddition += padding
        totalHeight += max(totalTextHeightAddition, thumbnailWidth + padding)
        return totalHeight.rounded(.up)
    }
    
    static var commentHeight: CGFloat?
    static var headingHeight: CGFloat?
    
    static func heightForComment(_ comment: String, width: CGFloat) -> CGFloat {
        let height = comment.boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body).withSize(14.0)
            ],
            context: nil
        ).size.height
        
        return min(height, CGFloat(90.0))
    }
    
    static func heightForHeading(_ heading: String, width: CGFloat) -> CGFloat {
        let height = heading.boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .headline).withSize(17.0)
            ],
            context: nil
        ).size.height
        
        return height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 15.0
        let thumbnailWidth: CGFloat = 80.0
        let textWidthAvailable = bounds.width - padding * 3 - thumbnailWidth
        
        threadThumbnail.frame = CGRect(x: padding, y: padding, width: 80.0, height: 80.0)
        
        heading.frame = CGRect(
            x: padding + thumbnailWidth + padding,
            y: padding, width: textWidthAvailable,
            height: ThreadCell.heightForHeading(heading.text ?? "", width: textWidthAvailable)
        )
        heading.preferredMaxLayoutWidth = heading.frame.width
    
        print("ThreadCell.commentHeight = \(ThreadCell.commentHeight)")
        detailText.frame = CGRect(x: padding + thumbnailWidth + padding, y: padding + heading.frame.height + padding, width: textWidthAvailable, height: ThreadCell.heightForComment(detailText.text ?? "", width: textWidthAvailable))
            detailText.preferredMaxLayoutWidth = detailText.frame.width
    }*/
    // MARK: - Instance Properties
    let threadThumbnail: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(17.0)
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        return label
    }()

    let detailText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(14.0)
        return label
    }()

    var statLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }()
    
    // MARK: - Intialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(threadThumbnail)
        contentView.addSubview(heading)
        contentView.addSubview(detailText)
        
        setupViews()
        setupSwipeIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
    
    func createStatsString(filesCount: Int, postsCount: Int, date: String) {
        let string = NSMutableAttributedString(string: " \(filesCount)   \(postsCount)   \(date)", attributes: [:])
        let fileImage = UIImage(systemName: "photo")!
        let fileImageAttachment = NSTextAttachment(image: fileImage)
        let fileString = NSAttributedString(attachment: fileImageAttachment)
        string.insert(fileString, at: 0)
        print(fileString.string.count)
        let commentImage = UIImage(systemName: "text.bubble")!
        let commentImageAttachment = NSTextAttachment(image: commentImage)
        let commentString = NSAttributedString(attachment: commentImageAttachment)
        string.insert(commentString, at: fileString.string.count + String(filesCount).count + 3)
        let dateImage = UIImage(systemName: "clock")!
        let dateImageAttachment = NSTextAttachment(image: dateImage)
        let dateString = NSAttributedString(attachment: dateImageAttachment)
        string.insert(dateString, at: fileString.string.count + String(filesCount).count + commentString.string.count + String(postsCount).count + 6)
         statLabel.attributedText = string
    }
    
    
    func configure(_ thread: Thread) {
        // TODO: - Add animation or not
        /*
        UIView.transition(
            with: threadThumbnail,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {  self.threadThumbnail.image = thread.image ?? UIImage(named: "placeholder") },
            completion: nil
        )
        */
        threadThumbnail.image = thread.image ?? UIImage(named: "placeholder")
        detailText.text = thread.posts[0].comment
        heading.text = thread.posts[0].subject
        createStatsString(
           filesCount: thread.postsCount,
           postsCount: thread.filesCount,
           date: thread.posts[0].dateString
        )
    }

    func setupViews() {
        contentView.addSubview(heading)
        contentView.addSubview(detailText)
        contentView.addSubview(statLabel)
        contentView.addSubview(threadThumbnail)

        heading.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        heading.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 118.0).isActive = true
        heading.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        heading.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        
        detailText.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 5.0).isActive = true
        detailText.leftAnchor.constraint(equalTo:  heading.leftAnchor).isActive = true
        detailText.rightAnchor.constraint(equalTo: heading.rightAnchor).isActive = true
        detailText.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        
        statLabel.topAnchor.constraint(equalTo: detailText.bottomAnchor, constant: 5.0).isActive = true
        statLabel.leftAnchor.constraint(equalTo: detailText.leftAnchor).isActive = true
        statLabel.rightAnchor.constraint(equalTo: detailText.rightAnchor).isActive = true
        statLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15.0).isActive = true
 
        threadThumbnail.widthAnchor.constraint(equalToConstant: 88.0).isActive = true
        threadThumbnail.heightAnchor.constraint(equalToConstant: 88.0).isActive = true
        threadThumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0).isActive = true
        threadThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        threadThumbnail.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15.0).isActive = true
     }
}

