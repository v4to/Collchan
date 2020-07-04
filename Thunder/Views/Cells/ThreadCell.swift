//
//  ThreadCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 24.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import Fuzi



class ThreadCell: BoardsListTableViewCell {
    
    
    // MARK: - Instance Properties
    
    var index = 0
    
    let threadThumbnail: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    let heading: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(17.0)
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        return label
    }()

    let detailText: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        return label
    }()

    var threadStats: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }()
    
    var bottomMargin: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(#colorLiteral(red: 0.1411602199, green: 0.1411868334, blue: 0.1411544085, alpha: 1)).cgColor
        view.layer.borderWidth = 1.0
        view.backgroundColor = #colorLiteral(red: 0.04705037922, green: 0.0470642224, blue: 0.04704734683, alpha: 1)
        return view
    }()
    
    // MARK: - Intialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
     override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0.0, left: bounds.size.width, bottom: 0.0, right: 0.0);
        let padding: CGFloat = 10.0
        let topAndBottomPadding: CGFloat = 15.0
        let thumbnailWidth: CGFloat = 80.0
        let leftEdgeOffset = padding + thumbnailWidth + padding
//        let textWidthAvailable = bounds.width - padding * 3 - thumbnailWidth
        
        
        
        threadThumbnail.frame = CGRect(x: padding, y: topAndBottomPadding, width: 80.0, height: 80.0)
        heading.frame = CGRect.zero
        detailText.frame = CGRect.zero
        var currentY: CGFloat = topAndBottomPadding
        
        if heading.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            heading.frame = ThreadCell.frames[index]!.headingFrame
            heading.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)
            currentY += heading.frame.height
            currentY += padding
        }
   
        if detailText.text != nil {
            detailText.frame = ThreadCell.frames[index]!.commentFrame
            detailText.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)
            currentY += detailText.frame.height
            currentY += padding
        }

        threadStats.frame = ThreadCell.frames[index]!.statsFrame
        threadStats.frame.origin = CGPoint(x: leftEdgeOffset, y: currentY)

        bottomMargin.frame = CGRect(x: -5.0, y: bounds.maxY - 10.0, width: bounds.width + 10.0, height: 10.0)
    }
    
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
    
    static func createStatsString(filesCount: Int, postsCount: Int, date: String) -> NSMutableAttributedString {
        let string = NSMutableAttributedString()
        
        let fileImage = UIImage(systemName: "photo")!
        let fileImageAttachment = NSTextAttachment(image: fileImage)
        let fileString = NSMutableAttributedString(attachment: fileImageAttachment)
        fileString.addAttributes(
            [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)],
            range: NSRange(location: 0, length: 1)
        )
        string.append(fileString)
        
        let filesCountAttributedString = NSMutableAttributedString(
            string: " \(filesCount)   ",
            attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)
            ]
        )
        string.append(filesCountAttributedString)
        
        let commentImage = UIImage(systemName: "text.bubble")!
        let commentImageAttachment = NSTextAttachment(image: commentImage)
        let commentString = NSMutableAttributedString(attachment: commentImageAttachment)
        commentString.addAttributes(
            [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)],
            range: NSRange(location: 0, length: 1)
        )
        string.append(commentString)
        
        let postsCountAttributedString = NSMutableAttributedString(
            string: " \(postsCount)   ",
            attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)
            ]
        )
        string.append(postsCountAttributedString)
        
        let dateImage = UIImage(systemName: "clock")!
        let dateImageAttachment = NSTextAttachment(image: dateImage)
        let dateString = NSMutableAttributedString(attachment: dateImageAttachment)
        dateString.addAttributes(
            [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)],
            range: NSRange(location: 0, length: 1)
        )
        string.append(dateString)
        
        let dateAttributedString = NSMutableAttributedString(
            string: " \(date)",
            attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0)
            ]
        )
        string.append(dateAttributedString)
        
        return string
    }
    
    func configure(_ thread: Thread) {
        threadThumbnail.image = thread.image ?? UIImage(named: "placeholder")
        heading.text = thread.opPost.subject
        detailText.text = thread.opPost.comment
        threadStats.attributedText = ThreadCell.createStatsString(filesCount: thread.filesCount, postsCount: thread.postsCount, date: thread.opPost.dateString)
    }
    
    func setupViews() {
        contentView.addSubview(threadThumbnail)
        contentView.addSubview(heading)
        contentView.addSubview(detailText)
        contentView.addSubview(threadStats)
        addSubview(bottomMargin)
        
        setupSwipeIcon()
    }
    
    struct Frames {
        var headingFrame: CGRect
        var commentFrame: CGRect
        var statsFrame: CGRect
    }
    
    // MARK: - Static Properties
    
    static var frames = [Int: Frames]()

    // MARK: - Static Methods
    
    static func preferredHeightForThread(_ thread: Thread, andWidth width: CGFloat, index: Int) -> CGFloat {
        let padding: CGFloat = 10.0
        let topAndBottomPadding: CGFloat = 15.0
        let thumbnailWidth: CGFloat = 80.0
        var totalHeight: CGFloat = topAndBottomPadding
        let textWidthAvailable = width - padding * 3 - thumbnailWidth
        var totalTextHeightAddition: CGFloat = 0.0
        
        var headingStringHeight: CGFloat = 0.0
        var headingRect: CGRect = CGRect.zero
        let headingString = thread.opPost.subject
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
        let commentString = thread.opPost.comment
        if commentString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            commentRect = rectForString(
                commentString,
                font: UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
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
            width: textWidthAvailable
        )
        statsStringHeight += statsRect.height
        totalTextHeightAddition += statsStringHeight
        totalTextHeightAddition += topAndBottomPadding + padding
        
        totalHeight += max(totalTextHeightAddition, thumbnailWidth + topAndBottomPadding + padding)
   
        frames[index] = Frames(headingFrame: headingRect, commentFrame: commentRect, statsFrame: statsRect)
        
        return totalHeight.rounded(.up)
    }

    
    
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
            
        rect.size.height = min(rect.size.height.rounded(.up), CGFloat(100.0))
        return rect
    }
    
    static func rectForAttributedString(_ string: NSAttributedString, width: CGFloat) -> CGRect {
        var rect = string.boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            context: nil
        )

        rect.size.height = rect.size.height.rounded(.up)
        return rect
    }
}

