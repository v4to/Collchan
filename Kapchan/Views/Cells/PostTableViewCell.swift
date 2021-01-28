//
//  PostTableViewCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 05.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import Fuzi

extension NSAttributedString {

    func sizeFittingWidth(_ w: CGFloat) -> CGSize {
        let textStorage = NSTextStorage(attributedString: self)
        let size = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = CGRect(origin: .zero, size: size)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)

        layoutManager.glyphRange(forBoundingRect: boundingRect, in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)

        return rect.integral.size
    }
}


class PostTableViewCell: BoardsListTableViewCell {

//class PostTableViewCell: BoardsListTableViewCell {
   
    
    
    struct Frames {
        var postIdFrame: CGRect
        var dateFrame: CGRect
        var commentFrame: CGRect
        var thumbnailsFrame: CGRect
        var postRepliesRect: CGRect
    }
    
    static var frames = [Int: Frames]()
    
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
            
        rect.size.height = rect.size.height.rounded(.up)
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
    
    static func preferredHeightForThread(_ post: PostWithIntId, andWidth width: CGFloat, index: Int) -> CGFloat {
        let padding: CGFloat = 10.0
        var totalHeight: CGFloat = padding
        let textWidthAvailable = width - padding * 2
        var totalTextHeightAddition: CGFloat = 0.0
        
        var postIdStringHeight: CGFloat = 0.0
        var postIdRect: CGRect = CGRect.zero
        let postIdString = "#\(post.postId)"
//        print(postIdString)
        if postIdString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            postIdRect = rectForString(
                postIdString,
                font: UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0),
                width: textWidthAvailable
            )
            postIdStringHeight += postIdRect.height
            totalTextHeightAddition += postIdStringHeight
            totalTextHeightAddition += padding
        }
        
        var dateStringHeight: CGFloat = 0.0
        var dateRect: CGRect = CGRect.zero
//        let dateString = post.dateString
        let dateString = post.creationDateString
        if dateString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            dateRect = rectForString(
                dateString,
                font: UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0),
                width: textWidthAvailable
            )
//            dateStringHeight += dateRect.height
//            totalTextHeightAddition += dateStringHeight
//            totalTextHeightAddition += padding
        }
        
        var thumbnailsRect: CGRect = CGRect.zero
        if post.files.count > 0 {
            thumbnailsRect = CGRect(x: padding, y: padding, width: textWidthAvailable, height: 90.0)
            totalTextHeightAddition += 90.0
            totalTextHeightAddition += padding
        }
        
        
        
        var commentStringHeight: CGFloat = 0.0
        var commentRect: CGRect = CGRect.zero
        let commentString = post.comment.replacingOccurrences(of: "<br>", with: "\n")
        var commentAttributedString: NSMutableAttributedString
        if commentString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
//            if let doc = try? HTMLDocument(string: commentString), let body = doc.body {
            var post = post
//            if let comment = post.attributedComment {
            commentAttributedString = post.attributedComment
            commentRect = rectForAttributedString(
                commentAttributedString,
                width: textWidthAvailable
            )
                
//                let largestSize = CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude)
//                let frameSetter = CTFramesetterCreateWithAttributedString(commentAttributedString)
//                let commentSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange(), nil, largestSize, nil)
                
//                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: textWidthAvailable, height: .greatestFiniteMagnitude))
//                textView.textContainerInset = UIEdgeInsets.zero
//                textView.attributedText = commentAttributedString
                // correctly calculhate attributed text height
                let textContainer = NSTextContainer(size: CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude))
                let layoutManager = NSLayoutManager()
                layoutManager.addTextContainer(textContainer)
                let textStorage = NSTextStorage(attributedString: commentAttributedString)
                textStorage.addLayoutManager(layoutManager)
                commentRect = layoutManager.usedRect(for: textContainer)
                
//                let commentSize = textView.sizeThatFits(CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude))
                
//                commentRect = CGRect(origin: CGPoint.zero, size: commentSize)
                commentStringHeight += commentRect.height
                totalTextHeightAddition += commentStringHeight
                totalTextHeightAddition += padding
//            }
            
        }
        
        
        var postRepliesHeight: CGFloat = 0.0
        var postRepliesRect: CGRect = CGRect.zero
        let repliesCount = post.replies.count
        if repliesCount != 0 {
            let postRepliesString = "\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")"
            postRepliesRect = rectForString(
                postRepliesString.uppercased(),
                font: UIFont.preferredFont(forTextStyle: .headline).withSize(14.0),
                width: textWidthAvailable
            )
            postRepliesHeight += postRepliesRect.height
            totalTextHeightAddition += postRepliesHeight
            totalTextHeightAddition += padding
        }
        
        
        
        totalHeight += totalTextHeightAddition
        
        frames[index] = Frames(postIdFrame: postIdRect, dateFrame: dateRect, commentFrame: commentRect, thumbnailsFrame: thumbnailsRect, postRepliesRect: postRepliesRect)
        return totalHeight.rounded(.up)
    }
    
    var index: Int = 0
    
    // MARK: - Instance Propeties
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 10.0
        
        thumbnailsCollectionView.frame = CGRect.zero
        postId.frame = CGRect.zero
        date.frame = CGRect.zero
        postReplies.frame = CGRect.zero
        
        comment.frame = CGRect.zero
        
        var currentY = padding
        
        postId.frame = PostTableViewCell.frames[index]!.postIdFrame
        postId.frame.origin = CGPoint(x: padding, y: currentY)
        
        currentY += postId.frame.height
        currentY += padding
        
        
//        if thumbnails.count > 0 {
//            thumbnailsCollectionView.frame = CGRect(x: padding, y: currentY, width: bounds.size.width - padding * 2, height: 90.0)
        
//        }
        
        
        date.frame = PostTableViewCell.frames[index]!.dateFrame
        date.frame.origin = CGPoint(x: bounds.maxX - date.frame.width - padding, y: padding)
        
//        currentY += date.frame.height
//        currentY += padding
        
        thumbnailsCollectionView.frame = PostTableViewCell.frames[index]!.thumbnailsFrame
        thumbnailsCollectionView.frame.origin = CGPoint(x: padding, y: currentY)
        currentY += thumbnailsCollectionView.frame.height
        if thumbnailsCollectionView.frame.height > 0 {
            currentY += padding
        }
        
        
        comment.frame = PostTableViewCell.frames[index]!.commentFrame
        comment.frame.origin = CGPoint(x: padding, y: currentY)
//        comment.textContainer.size.height = comment.frame.height
        comment.textContainerInset = UIEdgeInsets.zero
        
//        comment.contentView.size.height = comment.frame.height
        
        currentY += comment.frame.height
        if comment.frame.height > 0 {
            currentY += padding
        }
        
        
        
        postReplies.frame = PostTableViewCell.frames[index]!.postRepliesRect
//        postReplies.frame.origin = CGPoint(x: bounds.maxX - postReplies.frame.width - padding, y: currentY)
        postReplies.frame.origin = CGPoint(x: padding, y: currentY)

        
        currentY += postReplies.frame.height
        currentY += padding
    }
    
    
    
    override var actionViewBackgroundColor: UIColor 	{
//        return #colorLiteral(red: 0, green: 0.5098509789, blue: 0.9645856023, alpha: 1)
        return Constants.Design.Color.backgroundReplyAction
    }
    
    lazy var postId = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0))
    lazy var date = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0))
    
    
    struct ThumbnailImage {
        var url: URL
        var image: UIImage?
    }
    
    var thumbnailsArray = [ThumbnailImage]()
    
//    func setupThumbnails(post: PostWithIntId) {
//        for url in post.thumbnailUrls {
//            thumbnailsArray.append(ThumbnailImage(url: url, image: nil))
//        }
//    }
    
    func setupThumbnails(images: [UIImage], post: PostWithIntId) {
        DispatchQueue.global().async {
            self.thumbnails = []
            self.thumbnails.append(contentsOf: images)
            DispatchQueue.main.async {
                self.thumbnailsCollectionView.reloadData()
            }
        }
        
        
//        thumbnails = []
//        if images.count > 0 {
//            for image in images {
//                thumbnails.append(image)
//            }
//
//            commentTopContraintToPostId?.isActive = false
//            commentTopContraintToThumbnailCollectionView?.isActive = true
//            thumbnailsCollectionView.isHidden = false
//        } else {
//            if post.files.count == 0 {
//                commentTopContraintToThumbnailCollectionView?.isActive = false
//                commentTopContraintToPostId?.isActive = true
//
//                thumbnailsCollectionView.isHidden = true
//            }
//        }
//        thumbnailsCollectionView.reloadData()

    }
    
    
    
    
    var thumbnails = [UIImage]()
    let thumbnailsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90.0, height: 90.0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = true
//        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.alwaysBounceHorizontal = true
//        collectionView.isScrollEnabled = true
//        collectionView.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var comment: UITextView = {
//        let comment: UILabel = {

        let text = UITextView()
        text.delegate = self
//        let text = UILabel()
//        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
//        text.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        text.textColor = .label
        text.tintColor = Constants.Design.Color.orange
        text.textAlignment = .left
        text.isSelectable = true
        text.isEditable = false
        text.isScrollEnabled = false
        text.backgroundColor = .clear
        text.isOpaque = true
//        text.textContainerInset = UIEdgeInsets.zero
        
        // remove padding
        text.textContainer.lineFragmentPadding = 0
//            text.backgroundColor =
//            text.numberOfLines = 0
        return text
    }()
    
    let postReplyId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(13.0)
//        label.textColor = .systemBlue
        label.textColor = Constants.Design.Color.orange
        return label
    }()
    
    let postReplies: UIButton = {
        var label = UIButton(type: .custom)
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(14.0)
//        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(15.0)
//        label.titleLabel?.textColor = .systemBlue
        
//        label.setTitleColor(.systemBlue, for: .normal)
        label.setTitleColor(.secondaryLabel, for: .normal)
//        label.title label.titleLabel?.text?.uppercased()
        return label
    }()
    
   
    
    let quote: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        label.textColor = .systemRed
        return label
        
    }()
    
    func createHeaderLabelWithFont(_ font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
//        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        label.textColor = .secondaryLabel
        return label
    }
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Design.Color.background
        thumbnailsCollectionView.dataSource = self
        thumbnailsCollectionView.delegate = self
        postReplies.addTarget(nil, action: #selector(ThreadTableViewController.actionOpenRepliesModel(_:)), for: .touchUpInside)
//        thumbnailsCollectionView.delegate = self
        contentView.addSubview(postId)
        contentView.addSubview(date)
        contentView.addSubview(comment)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        thumbnailsCollectionView.register(ThumnailCollectionViewCell.self, forCellWithReuseIdentifier: thumbnailCollectionCellId)
        setupSwipeIcon()
        //setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Gestures
    
    @objc func handleTap(_ gesutreRecognizer: UITapGestureRecognizer) {
//        print("label tapped")
    }
    
    // MARK: - Instance Methods
    
    static func createCommentAttributeStringFromNode(_ root: XMLNode) -> NSMutableAttributedString {
        if let root = root as? XMLElement {
            let attributedText = NSMutableAttributedString()
            for node in root.childNodes(ofTypes: [.Element, .Text]) {
                attributedText.append(createCommentAttributeStringFromNode(node))
            }
            return attributedText
        }
        
        if root.parent?.tag == "a" && root.parent?.attr("class") != "post-reply-link" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
//                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.strokeWidth: -3.0,
                    NSAttributedString.Key.foregroundColor: Constants.Design.Color.orange,
                    NSAttributedString.Key.link: URL(string:root.parent!.attr("href")!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                ]
            )
        }
        
        if root.parent?.attr("class") == "s" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
//                    NSAttributedString.Key.strikethroughColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1),
                    NSAttributedString.Key.strikethroughColor: UIColor.label,

                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
//                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
                    NSAttributedString.Key.foregroundColor: UIColor.label

                ]
            )
        }
        
        if root.parent?.attr("class") == "spoiler" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1),
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1608105964, green: 0.1608105964, blue: 0.1608105964, alpha: 1)
                ]
            )
        }
        
        if root.parent?.attr("class") == "unkfunc" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: UIColor.systemRed,
                    NSAttributedString.Key.strokeWidth: -3.0,

//                    NSAttributedString.Key.foregroundColor: Constants.Design.Color.backgroundWithOpacity

                ]
            )
        }
        
        if root.parent?.attr("class") == "post-reply-link" {
//            print(root.parent?.attr("data-thread"))
            let postReply = root.parent!.attr("data-num")!
//                print("URL ---", URL(string: "thunder://\(postReply)"))

//            }
            
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(14.0),
//                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.strokeWidth: -3.0,

                    NSAttributedString.Key.foregroundColor: Constants.Design.Color.orange,

                    NSAttributedString.Key.link: URL(string: "thunder://\(postReply)")!
                ]
            )
        }
        
        if root.parent?.attr("class") == "u" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.underlineColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1),
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
                ]
            )
        }
        
        return NSMutableAttributedString(
            string: root.stringValue,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
//                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1) .label
                NSAttributedString.Key.foregroundColor: UIColor.label

            ]
        )
    }
    
    var postIdString = ""
    func configure(_ post: PostWithIntId) {
        setupThumbnails(images: post.images, post: post)
        
        postIdString = String(post.postId)
        postId.text = "#\(post.postId)"
        date.text = post.creationDateString
//        date.text = post.dateString
//
//
//        postReplies.isHidden = false
        let repliesCount = post.replies.count

        if repliesCount != 0 {
            postReplies.setTitle("\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")".uppercased(), for: .normal)
//            postReplies = postReplies.titleLabel?.text?.uppercased()
//            postRepliesBottomConstraint?.isActive = false
//            commentBottomConstraint?.isActive = true
//            postReplies.isHidden = true
        } else {
//            postRepliesBottomConstraint?.isActive = true
//            commentBottomConstraint?.isActive = false
//            postReplies.text = "\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")"

        }

//        print(post.attributedComment.string.count)
        
        self.comment.attributedText = post.attributedComment
//        self.comment.text = post.attributedComment.string
//        self.comment.text = post.comment


        
    }
    
    func setupViews() {
//        backgroundColor = .secondarySystemBackground

//        contentView.addSubview(thumbnailsStackView)
        contentView.addSubview(postId)
        contentView.addSubview(date)
        contentView.addSubview(comment)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 5.0
        
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
//        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        //        date.centerYAnchor.constraint(equalTo: postId.centerYAnchor).isActive = true
        date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        
        date.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        
        
        
        thumbnailCollectioViewTopConstraintToPostIt = thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: 10.0)
        thumbnailCollectioViewTopConstraintToPostIt?.isActive = true
        thumbnailCollectioViewLeftConstraintToPostIt = thumbnailsCollectionView.leftAnchor.constraint(equalTo: postId.leftAnchor)
        thumbnailCollectioViewLeftConstraintToPostIt?.isActive = true
        thumbnailCollectioViewRightConstraintToDate = thumbnailsCollectionView.rightAnchor.constraint(equalTo: date.rightAnchor)
        thumbnailCollectioViewRightConstraintToDate?.isActive = true
        thumbnailsCollectionViewHeightConstraint = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        thumbnailsCollectionViewHeightConstraint?.isActive = true
        //        thumbnailsCollectionViewHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
        thumbnailCollectioViewBottomContraintToContentView = thumbnailsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        //
        commentTopContraintToThumbnailCollectionView = comment.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin)
        commentTopContraintToThumbnailCollectionView?.isActive = true
        
        //        comment.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        
        commentTopContraintToPostId = comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin)
//        commentTopContraintToPostId
        
        
        
        comment.leftAnchor.constraint(equalTo: postId.leftAnchor).isActive = true
        comment.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
        commentBottomConstraint = comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        commentBottomConstraint?.priority = .defaultHigh
        commentBottomConstraint?.isActive = false
        
        postReplies.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: margin).isActive = true
        postReplies.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)

        postRepliesBottomConstraint = postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        postRepliesBottomConstraint?.priority = .defaultHigh
        postRepliesBottomConstraint?.isActive = true
        
    }
    
    var commentBottomConstraint: NSLayoutConstraint?
    var postRepliesBottomConstraint: NSLayoutConstraint?
    
    
    var commentTopContraintToThumbnailCollectionView: NSLayoutConstraint?
    var commentTopContraintToPostId: NSLayoutConstraint?
    
    var thumbnailCollectioViewBottomContraintToContentView: NSLayoutConstraint?
    var thumbnailsCollectionViewHeightConstraint: NSLayoutConstraint?
    var thumbnailCollectioViewTopConstraintToPostIt: NSLayoutConstraint?
    var thumbnailCollectioViewLeftConstraintToPostIt: NSLayoutConstraint?
    var thumbnailCollectioViewRightConstraintToDate: NSLayoutConstraint?
    
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
//        var image = UIImage(systemName: "arrowshape.turn.up.left.fill", withConfiguration: configuration)!
//        image =  image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        actionImage.image = Constants.Design.Image.iconReply.withConfiguration(configuration).withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    let thumbnailCollectionCellId = "thumbnailCollectionCellId"
}

extension PostTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        print(URL)
//        print(URL.scheme)
        if (URL.scheme == "thunder") {
//            print(URL.host)
            
            return false
        }
        return true
    }
}


extension PostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
        let cell = cell as! ThumnailCollectionViewCell
        if indexPath.row < thumbnails.count {
            cell.thumbnail.image = thumbnails[indexPath.row]
        }
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        thumbnails.count
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thumbnailCollectionCellId, for: indexPath) as! ThumnailCollectionViewCell
//        cell.thumbnail.image = thumbnails[indexPath.row]

        
//        cell.backgroundColor = .red
        
        
        return cell
    }
}


//extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 88.0, height: 88.0)
//    }
//}


class ThumnailCollectionViewCell: UICollectionViewCell {
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbnail)
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        thumbnail.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
