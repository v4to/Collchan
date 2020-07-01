//
//  ThreadCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 24.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit


struct Frames {
    var headingFrame: CGRect
    var commentFrame: CGRect
    var statsFrame: CGRect
}

class ThreadCell: BoardsListTableViewCell {
    
    static func preferredHeightForThread(_ thread: Thread, andWidth width: CGFloat, index: Int) -> CGFloat {
        let padding: CGFloat = 10.0
        let thumbnailWidth: CGFloat = 80.0
        var totalHeight: CGFloat = padding
        let textWidthAvailable = width - padding * 3 - thumbnailWidth
        var totalTextHeightAddition: CGFloat = 0.0
        var headingStringHeight: CGFloat = 0.0
        
        var headingRect: CGRect = CGRect.zero
        let headingString = thread.posts[0].subject
        if headingString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            headingRect = rectForString(
                headingString,
                font: UIFont.preferredFont(forTextStyle: .headline).withSize(17.0),
                width: textWidthAvailable
            )
            headingStringHeight += headingRect.height
            totalTextHeightAddition += headingStringHeight
            totalTextHeightAddition += padding
        }
        
        var commentStringHeight: CGFloat = 0.0
        var commentRect: CGRect = CGRect.zero
        let commentString = thread.posts[0].comment
        if commentString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let commentString = thread.posts[0].comment
            commentRect = rectForString(
                commentString,
                font: UIFont.preferredFont(forTextStyle: .body).withSize(14.0),
                width: textWidthAvailable
            )
            commentStringHeight += commentRect.height
            totalTextHeightAddition += commentStringHeight
            totalTextHeightAddition += padding
        }
        
        
        var statsStringHeight: CGFloat = 0.0
        let statsString = createStatsString(filesCount: thread.filesCount, postsCount: thread.postsCount, date: thread.posts[0].dateString)
        let statsRect = rectForAttributedString(
            statsString,
            font: UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0),
            width: textWidthAvailable
        )
        statsStringHeight += statsRect.height
        totalTextHeightAddition += statsStringHeight
        totalTextHeightAddition += padding
        
        totalHeight += max(totalTextHeightAddition, thumbnailWidth + padding)
   
        frames[index] = Frames(headingFrame: headingRect, commentFrame: commentRect, statsFrame: statsRect)
        
        return totalHeight.rounded(.up)
    }

    static var frames = [Int: Frames]()
    
    var index = 0
    
    static func rectForString(_ string: String, font: UIFont, width: CGFloat) -> CGRect {

        var rect = string.boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [ .font: font ],
            context: nil
        )
            
        rect.size.height = min(rect.size.height.rounded(.up), CGFloat(90.0))
        return rect
    }
    
    
    
    static func rectForAttributedString(_ string: NSAttributedString, font: UIFont, width: CGFloat) -> CGRect {
        var rect = string.boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
//            attributes: [ .font: font ],
            context: nil
        )
            
        rect.size.height = min(rect.size.height.rounded(.up), CGFloat(90.0))
        return rect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 10.0
        let thumbnailWidth: CGFloat = 80.0
        let leftEdgeOffset = padding + thumbnailWidth + padding
//        let textWidthAvailable = bounds.width - padding * 3 - thumbnailWidth
        
        threadThumbnail.frame = CGRect(x: padding, y: padding, width: 80.0, height: 80.0)
        heading.frame = CGRect.zero
        detailText.frame = CGRect.zero
        var currentY: CGFloat = padding
        
        if heading.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            heading.frame = ThreadCell.frames[index]!.headingFrame
            heading.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)
            currentY += heading.frame.height
            currentY += padding
        }
        /*
        if heading.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            heading.frame = CGRect(
                x: padding + thumbnailWidth + padding,
                y: padding,
                width: textWidthAvailable,
//                height: ThreadCell.heightForHeading(heading.text ?? "", width: textWidthAvailable)
                height: ThreadCell.heights[index]!.headingHeight

            )
            heading.preferredMaxLayoutWidth = heading.frame.width
            currentY += heading.frame.height
            currentY += padding
        }*/
        
//        print("deatailText.text = \(detailText.text!)a")
//        print("ThreadCell.commentHeight = \(ThreadCell.commentHeight)")
        if detailText.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            detailText.frame = ThreadCell.frames[index]!.commentFrame
            detailText.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)
//            detailText.frame = CGRect(x: leftEdgeOffset, y: currentY, width: detailText.frame.width, height:  detailText.frame.height)
            currentY += detailText.frame.height
            currentY += padding
        }
        /*
        if detailText.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
//            print(detailText.text!)
            detailText.frame = CGRect(
                x: padding + thumbnailWidth + padding,
//                y: padding + heading.frame.height + padding,
                y: currentY,
                width: textWidthAvailable,
//                height: ThreadCell.heightForComment(detailText.text ?? "", width: textWidthAvailable)
                height: ThreadCell.heights[index]!.commentHeight
            )
            detailText.preferredMaxLayoutWidth = detailText.frame.width
            currentY += detailText.frame.height
            currentY += padding
        }*/
//        print(detailText.frame)
        print(statLabel.attributedText)
        statLabel.frame = ThreadCell.frames[index]!.statsFrame
//        statLabel.sizeToFit()
        statLabel.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)

//        statLabel.frame.size.width = statLabel.frame.width
//        statLabel.frame = CGRect(x: padding + thumbnailWidth + padding, y: currentY, width: statLabel.frame.width, height:  statLabel.frame.height)
//        statLabel.preferredMaxLayoutWidth = statLabel.frame.width
        
        
        
//        statLabel.frame = CGRect(
//            x: padding + thumbnailWidth + padding,
//            y: currentY,
////            + heading.frame.height + padding + detailText.frame.height + padding
//            width: textWidthAvailable,
////            height: ThreadCell.heightForComment(statLabel.attributedText!.string, width: textWidthAvailable)
//            height: ThreadCell.frames[index]!.statsFrame
//
//        )
        
    }
    // MARK: - Instance Properties
    let threadThumbnail: UIImageView = {
        let imageView = UIImageView()
//        let imageView = UIImageView(image: UIImage(named: "placeholder"))

//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    let heading: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(17.0)
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        return label
    }()

    let detailText: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(14.0)
        return label
    }()

    var statLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(statLabel)
        
//        setupViews()
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
    
    static func createStatsString(filesCount: Int, postsCount: Int, date: String) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: " \(filesCount)   \(postsCount)   \(date)", attributes: [:])
        let fileImage = UIImage(systemName: "photo")!
        let fileImageAttachment = NSTextAttachment(image: fileImage)
        let fileString = NSAttributedString(attachment: fileImageAttachment)
        string.insert(fileString, at: 0)
//        print(fileString.string.count)
        let commentImage = UIImage(systemName: "text.bubble")!
        let commentImageAttachment = NSTextAttachment(image: commentImage)
        let commentString = NSAttributedString(attachment: commentImageAttachment)
        string.insert(commentString, at: fileString.string.count + String(filesCount).count + 3)
        let dateImage = UIImage(systemName: "clock")!
        let dateImageAttachment = NSTextAttachment(image: dateImage)
        let dateString = NSAttributedString(attachment: dateImageAttachment)
        string.insert(dateString, at: fileString.string.count + String(filesCount).count + commentString.string.count + String(postsCount).count + 6)
//        statLabel.attributedText = string
        return string
    }
    
//    static var attributedText:
    
    func configure(_ thread: Thread) {
//        UIView.transition(
//            with: threadThumbnail,
//            duration: 0.3,
//            options: .transitionCrossDissolve,
//            animations: {  self.threadThumbnail.image = thread.image },
//            completion: nil
//        )
        
        if thread.image != nil {
            self.threadThumbnail.image = thread.image
        }
//        detailText.text = thread.comment
//        heading.text = thread.heading
        detailText.text = thread.posts[0].comment
        heading.text = thread.posts[0].subject
        statLabel.attributedText = ThreadCell.createStatsString(filesCount: thread.filesCount, postsCount: thread.postsCount, date: thread.posts[0].dateString)
//        createStatsString(
//           filesCount: thread.postsCount,
//           postsCount: thread.filesCount,
//           date: thread.posts[0].dateString
//        )
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
