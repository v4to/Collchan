//
//  PostTableViewCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 05.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import Fuzi

class PostTableViewCell: BoardsListTableViewCell {

    // MARK: - Propeties
    
    var postIdFrame: CGRect = .zero
    var thumbnailsFrame: CGRect = .zero
    var commentFrame: CGRect = .zero
    var dateFrame: CGRect = .zero
    var postRepliesFrame: CGRect = .zero

    override var actionViewBackgroundColor: UIColor 	{
        return Constants.Design.Color.backgroundReplyAction
    }

    lazy var postId = createHeaderLabelWithFont(Constants.Design.Fonts.footnote)
    var files = Array<File>()
    let thumbnailCollectionCellId = "thumbnailCollectionCellId"
    var postIdString = ""

    // MARK: View Properties
    
    let postReplyId: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(13.0)
        label.textColor = Constants.Design.Color.orange
        label.backgroundColor = Constants.Design.Color.background
        return label
    }()
    let thumbnailsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90.0, height: 90.0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = true
        collectionView.backgroundColor = Constants.Design.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var comment: UITextView = {
        let text = UITextView()
        text.delegate = self
        text.font = Constants.Design.Fonts.body
        text.textColor = .label
        text.tintColor = Constants.Design.Color.orange
        text.textAlignment = .left
        text.isSelectable = true
        text.isEditable = false
        text.isScrollEnabled = false
        text.backgroundColor = Constants.Design.Color.background
        text.textContainerInset = UIEdgeInsets.zero
        text.textContainer.lineFragmentPadding = 0.0
        return text
    }()
    
    let postReplies: UIButton = {
        var label = UIButton(type: .custom)
        label.titleLabel?.font = Constants.Design.Fonts.footnoteBold
        label.setTitleColor(Constants.Design.Color.orange, for: .normal)
        label.backgroundColor = Constants.Design.Color.background
        label.titleLabel?.backgroundColor = Constants.Design.Color.background
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.font = Constants.Design.Fonts.footnote
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.Design.Color.background
        self.thumbnailsCollectionView.dataSource = self
        self.thumbnailsCollectionView.delegate = self
        self.postReplies.addTarget(
            nil,
            action: #selector(ThreadTableViewController.actionOpenRepliesModel(_:)),
            for: .touchUpInside
        )
        self.thumbnailsCollectionView.delegate = self
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(comment)
        contentView.addSubview(date)
        contentView.addSubview(postReplies)
        thumbnailsCollectionView.register(
            ThumnailCollectionViewCell.self,
            forCellWithReuseIdentifier: thumbnailCollectionCellId
        )
        setupSwipeIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postIdFrame  = .zero
        self.dateFrame  = .zero
        self.commentFrame  = .zero
        self.thumbnailsFrame  = .zero
        self.postRepliesFrame = .zero
        self.postId.text = nil
        self.files = []
        self.comment.attributedText = nil
        self.date.text = nil
        self.postReplies.setTitle(nil, for: .normal)
    }
    
//    func setupThumbnails(images: [UIImage]) {
    func setupThumbnails(files: [File]) {
        self.files = files
        self.thumbnailsCollectionView.reloadData()
    }
    
    func createHeaderLabelWithFont(_ font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        label.textColor = .secondaryLabel
        return label
    }
    
    func configure(_ post: PostWithIntId) {
        self.postIdFrame = post.postIdFrame
        self.commentFrame = post.commentFrame
        self.thumbnailsFrame = post.thumbnailsFrame
        self.postRepliesFrame = post.postRepliesFrame
        self.dateFrame = post.dateFrame
        postIdString = "\(post.postId)"
        self.postId.text = "\(post.name) • #\(post.postId)"
        self.setupThumbnails(files: post.files)
        self.comment.attributedText = post.attributedComment
        self.date.text = post.dateString
        let repliesCount = post.replies.count

        if repliesCount != 0 {
            postReplies.setTitle(
                "\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")", for: .normal
            )
        }
    }
	
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 10.0
        self.postId.frame = self.postIdFrame
        self.thumbnailsCollectionView.frame = self.thumbnailsFrame
        self.comment.frame = self.commentFrame
        self.date.frame = self.dateFrame
        var currentY = padding
        
        self.postId.frame.origin = CGPoint(x: padding, y: currentY)
        currentY += postId.frame.height
        currentY += padding
        
        self.thumbnailsCollectionView.frame = self.thumbnailsFrame
        self.thumbnailsCollectionView.frame.origin = CGPoint(x: padding, y: currentY)
        currentY += thumbnailsCollectionView.frame.height
        if thumbnailsCollectionView.frame.height > 0 {
            currentY += padding
        }
        
        self.comment.frame = self.commentFrame
        self.comment.frame.origin = CGPoint(x: padding, y: currentY)
        currentY += comment.frame.height
        if comment.frame.height > 0 {
            currentY += padding
        }
        
        self.date.frame = self.dateFrame
        self.date.frame.origin = CGPoint(x: padding, y: currentY)
        
        self.postReplies.frame = self.postRepliesFrame
        self.postReplies.frame.origin = CGPoint(
            x: self.contentView.bounds.width - padding - self.postReplies.bounds.width,
            y: currentY
        )
        currentY += self.postReplies.frame.height
        currentY += padding
    }

    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        self.actionImage.image = Constants.Design.Image.iconReply.withConfiguration(
            configuration
        ).withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}


// MARK: - UITextViewDelegate

extension PostTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.scheme == "thunder") {
            return false
        }
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension PostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: thumbnailCollectionCellId,
            for: indexPath
        ) as! ThumnailCollectionViewCell
        cell.thumbnail.image = files[indexPath.row].thumbnailImage
        return cell
    }
}

// MARK: - ThumnailCollectionViewCell

class ThumnailCollectionViewCell: UICollectionViewCell {
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.backgroundColor = Constants.Design.Color.background
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnail.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.thumbnail)
        self.thumbnail.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnail.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.thumbnail.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.thumbnail.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




/*
class PostTableViewCellWithoutImage: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(comment)
//        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        postId.setContentHuggingPriority(.defaultLow, for: .vertical)
    
        	
    	comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
		comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
		comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
//        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
 
        postReplies.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: margin).isActive = true
		postReplies.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
//		postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
//        layoutIfNeeded()
    }
}

class PostTableViewCellWithoutComment: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultHigh
        tH.isActive = true
      
        postReplies.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        postReplies.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
//        layoutIfNeeded()
    }
}



class PostTableViewCellWithoutReplies: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(comment)

        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultLow
        tH.isActive = true
        
        comment.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

class PostTableViewCellWithoutImageAndReplies: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(comment)
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

class PostTableViewCellWithoutRepliesAndComment: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(comment)
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        thumbnailsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultLow
        tH.isActive = true
 
    }
}

class PostTableViewCellWithoutRepliesAndComentAndImage: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)

        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
 */

























































































/*
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
        //        let postIdString = "#\(post.postId) • \(post.creationDateString)"
        let postIdString = "#\(post.postId) • \(post.dateString)"
        
        //        print(postIdString)
        if postIdString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            postIdRect =  postIdString.rectThatFits(
                CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude),
                and: Constants.Design.Fonts.footnote
            )
            
            /*
             postIdRect = rectForString(
             postIdString,
             font: UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0),
             width: textWidthAvailable
             )
             */
            
            postIdStringHeight += postIdRect.height
            totalTextHeightAddition += postIdStringHeight
            totalTextHeightAddition += padding
        }
        
        
        
        var dateStringHeight: CGFloat = 0.0
        var dateRect: CGRect = CGRect.zero
        //        let dateString = post.dateString
        //        let dateString = post.creationDateString
        let dateString = post.dateString
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
            commentRect = commentAttributedString.rectThatFits(
                CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude)
            )
            //            commentRect = rectForAttributedString(
            //                commentAttributedString,
            //                width: textWidthAvailable
            //            )
            
            //                let largestSize = CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude)
            //                let frameSetter = CTFramesetterCreateWithAttributedString(commentAttributedString)
            //                let commentSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange(), nil, largestSize, nil)
            
            //                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: textWidthAvailable, height: .greatestFiniteMagnitude))
            //                textView.textContainerInset = UIEdgeInsets.zero
            //                textView.attributedText = commentAttributedString
            // correctly calculhate attributed text height
            
            
            
            
            //                let textContainer = NSTextContainer(size: CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude))
            //                let layoutManager = NSLayoutManager()
            //                layoutManager.addTextContainer(textContainer)
            //                let textStorage = NSTextStorage(attributedString: commentAttributedString)
            //
            //                textStorage.addLayoutManager(layoutManager)
            //                commentRect = layoutManager.usedRect(for: textContainer)
            
            
            
            
            
            
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
            let postRepliesString = "\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")".uppercased()
            postRepliesRect = postRepliesString.rectThatFits(
                CGSize(width: textWidthAvailable, height: .greatestFiniteMagnitude),
                and: Constants.Design.Fonts.footnoteBold
            )
            /*
             postRepliesRect = rectForString(
             postRepliesString.uppercased(),
             font: Constants.Design.Fonts.footnoteBold,
             width: textWidthAvailable
             )*/
            
            postRepliesHeight += postRepliesRect.height
            totalTextHeightAddition += postRepliesHeight
            totalTextHeightAddition += padding
        }
        
        
        
        totalHeight += totalTextHeightAddition
        
        frames[index] = Frames(
            postIdFrame: postIdRect,
            dateFrame: dateRect,
            commentFrame: commentRect,
            thumbnailsFrame: thumbnailsRect,
            postRepliesRect: postRepliesRect
        )
        return totalHeight.rounded(.up)
    }
    
    var index: Int = 0
    //    var imageView = UIImageView()
    
    // MARK: - Instance Propeties
    /*
     override func layoutSubviews() {
     super.layoutSubviews()
     if PostTableViewCell.frames[index] == nil {
     return
     }
     let padding: CGFloat = 10.0
     
     thumbnailsCollectionView.frame = CGRect.zero
     postId.frame = CGRect.zero
     postReplies.frame = CGRect.zero
     
     comment.frame = CGRect.zero
     
     var currentY = padding
     
     postId.frame = PostTableViewCell.frames[index]!.postIdFrame
     postId.frame.origin = CGPoint(x: padding, y: currentY)
     
     currentY += postId.frame.height
     currentY += padding
     
     
     if thumbnails.count > 0 {
     thumbnailsCollectionView.frame = CGRect(x: padding, y: currentY, width: bounds.size.width - padding * 2, height: 90.0)
     
     }
     
     
     //        currentY += date.frame.height
     //        currentY += padding
     
     thumbnailsCollectionView.frame = PostTableViewCell.frames[index]!.thumbnailsFrame
     thumbnailsCollectionView.frame.origin = CGPoint(x: padding, y: currentY)
     currentY += thumbnailsCollectionView.frame.height
     if thumbnailsCollectionView.frame.height > 0 {
     currentY += padding
     }
     
     
     //        comment.frame = PostTableViewCell.frames[index]!.commentFrame
     comment.frame = PostTableViewCell.frames[index]!.commentFrame
     comment.frame.origin = CGPoint(x: padding, y: currentY)
     //        self.imageView?.frame = PostTableViewCell.frames[index]!.commentFrame
     //        self.imageView?.frame.origin = CGPoint(x: padding, y: currentY)
     
     //        comment.frame.origin = CGPoint(x: padding, y: currentY)
     //        comment.textContainer.size.height = comment.frame.height
     //        comment.textContainerInset = UIEdgeInsets.zero
     
     //        comment.contentView.size.height = comment.frame.height
     /*
     currentY += self.imageView!.frame.height
     if self.imageView!.frame.height > 0 {
     currentY += padding
     }*/
     
     currentY += comment.frame.height
     if comment.frame.height > 0 {
     currentY += padding
     }
     
     
     
     
     postReplies.frame = PostTableViewCell.frames[index]!.postRepliesRect
     //        postReplies.frame.origin = CGPoint(x: bounds.maxX - postReplies.frame.width - padding, y: currentY)
     postReplies.frame.origin = CGPoint(x: padding, y: currentY)
     
     
     //        currentY += postReplies.frame.height
     //        currentY += padding
     }*/
    
    
    
    override var actionViewBackgroundColor: UIColor     {
        //        return #colorLiteral(red: 0, green: 0.5098509789, blue: 0.9645856023, alpha: 1)
        return Constants.Design.Color.backgroundReplyAction
    }
    
    //    lazy var postId = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .footnote).withSize(13.0))
    lazy var postId = createHeaderLabelWithFont(Constants.Design.Fonts.footnote)
    
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
    
    override func prepareForReuse() {
        self.thumbnails = []
        postId.text = nil
        postReplies.setTitle(nil, for: .normal)
        //        thumbnailsCollectionView.isHidden = false
        //        thumbnailsCollectionViewHeightConstraint?.constant = 90.0
        //        self.thumbnailsCollectionView.layoutIfNeeded()
        //        postRepliesBottomConstraint?.isActive = false
        //        self.imageView?.image = nil
    }
    
    func setupThumbnails(images: [UIImage], post: PostWithIntId) {
        //        DispatchQueue.global().async {
        
        
        self.thumbnails = []
        self.thumbnails.append(contentsOf: images)
        self.thumbnailsCollectionView.reloadData()
        
        //            }
        //        }
        
        
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
        //        layout.itemSize = CGSize(width: 90, height: 90)
        layout.scrollDirection = .horizontal
        //        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: 90.0, height: 90.0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = true
        //        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.alwaysBounceHorizontal = true
        //        collectionView.isScrollEnabled = true
        //        collectionView.backgroundColor = .systemBackground
        //        collectionView.backgroundColor = .clear
        collectionView.backgroundColor = Constants.Design.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var comment: UITextView = {
        //        let comment: UILabel = {
        
        let text = UITextView()
        text.delegate = self
        //        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        //        text.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        text.font = Constants.Design.Fonts.body
        //        text.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        text.textColor = .label
        text.tintColor = Constants.Design.Color.orange
        text.textAlignment = .left
        text.isSelectable = true
        text.isEditable = false
        text.isScrollEnabled = false
        //        text.backgroundColor = .clear
        //        text.isOpaque = true
        text.backgroundColor = Constants.Design.Color.background
        text.textContainerInset = UIEdgeInsets.zero
        //        text.sizeToFit()
        // remove padding
        text.textContainer.lineFragmentPadding = 0.0
        //            text.backgroundColor =
        //            text.numberOfLines = 0
        return text
    }()
    
    let postReplyId: UILabel = {
        let label = UILabel()
        //        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(13.0)
        //        label.textColor = .systemBlue
        label.textColor = Constants.Design.Color.orange
        label.backgroundColor = Constants.Design.Color.background
        return label
    }()
    
    let postReplies: UIButton = {
        var label = UIButton(type: .custom)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = Constants.Design.Fonts.footnoteBold
        
        //        label.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(14.0)
        //        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(15.0)
        //        label.titleLabel?.textColor = .systemBlue
        
        //        label.setTitleColor(.systemBlue, for: .normal)
        label.setTitleColor(.secondaryLabel, for: .normal)
        label.backgroundColor = Constants.Design.Color.background
        label.titleLabel?.backgroundColor = Constants.Design.Color.background
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = .secondaryLabel
        //        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Constants.Design.Color.background
        //        contentView.backgroundColor = Constants.Design.Color.background
        thumbnailsCollectionView.dataSource = self
        thumbnailsCollectionView.delegate = self
        postReplies.addTarget(nil, action: #selector(ThreadTableViewController.actionOpenRepliesModel(_:)), for: .touchUpInside)
        thumbnailsCollectionView.delegate = self
        //        contentView.addSubview(postId)
        //        contentView.addSubview(comment)
        //        contentView.addSubview(thumbnailsCollectionView)
        //        contentView.addSubview(postReplies)
        
        thumbnailsCollectionView.register(ThumnailCollectionViewCell.self, forCellWithReuseIdentifier: thumbnailCollectionCellId)
        setupSwipeIcon()
        
        //        imageView?.backgroundColor = Constants.Design.Color.background
        //        setUpViews()
        setupViews()
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
        //        if post.images.count == 0 {
        //            thumbnailsCollectionViewHeightConstraint?.constant = 0
        //        }
        
        
        postIdString = String(post.postId)
        //        postId.text = "#\(post.postId) • \(post.creationDateString)"
        postId.text = "#\(post.postId) • \(post.dateString)"
        
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
        }
        //        else {
        //            postRepliesBottomConstraint?.isActive = true
        //            commentBottomConstraint?.isActive = false
        //            postReplies.text = "\(repliesCount) repl\(repliesCount > 1 ? "ies" : "y")"
        
        //        }
        
        //        print(post.attributedComment.string.count)
        
        self.comment.attributedText = post.attributedComment
        print(post.attributedComment.string)
        if post.attributedComment.length == 0 {
            //            postRepliesTopConstraint?.isActive = false
            //            postRepliesBottomConstraint?.isActive = true
        }
        //        self.comment.sizeToFit()
        //        self.imageView?.image = UIDevice.current.orientation.isLandscape ? post.convertedAttributedStringLandscape :
        //        if UIDevice.current.orientation.isLandscape {
        //            self.imageView?.image = post.convertedAttributedStringLandscape ?? nil
        //        } else {
        //            self.imageView?.image = post.convertedAttributedString
        //        }
        
        //        self.commentView.image = post.convertedAttributedString
        //        self.comment.text = post.attributedComment.string
        //        self.comment.text = post.comment
        
        
        //        self.imageView?.image = post.convertedAttributedString
        
    }
    
    
    var commentView = UIImageView()
    
    func setUpViews() {
        thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        let stackView = UIStackView(arrangedSubviews: [postId, thumbnailsCollectionView, comment, postReplies])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 15.0
        self.contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        
        //        contentView.addSubview(postId)
        //        contentView.addSubview(comment)
        //        contentView.addSubview(commentView)
        //        contentView.addSubview(thumbnailsCollectionView)
        //        contentView.addSubview(postReplies)
    }
    
    
    func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(comment)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultLow
        tH.isActive = true
        
        comment.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        postReplies.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: margin).isActive = true
        postReplies.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        //        postReplies.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
        postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        //        layoutIfNeeded()
        
    }
    
    var thumbnailsCollectionHeightConstraintHidden: NSLayoutConstraint?
    var thumbnailsCollectionViewBottomConstraint: NSLayoutConstraint?
    var postRepliesTopConstraint: NSLayoutConstraint?
    var postRepliesTopConstraintToThumbnails: NSLayoutConstraint?
    
    
    
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
            UIView.animate(withDuration: 0.3) {
                cell.thumbnail.layer.opacity = 1.0
            }
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
//        return CGSize(width: 80.0, height: 80.0)
//    }
//}


class ThumnailCollectionViewCell: UICollectionViewCell {
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.backgroundColor = Constants.Design.Color.background
        imageView.layer.opacity = 0.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.separatorInset = .zero
        //        self.preservesSuperviewLayoutMargins = false
        //        self.layoutMargins = .zero
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


class PostTableViewCellWithoutImage: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(comment)
        //        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        postId.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        
        comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
        //        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        postReplies.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: margin).isActive = true
        postReplies.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        //        postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        //        layoutIfNeeded()
    }
}

class PostTableViewCellWithoutComment: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(postReplies)
        
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultHigh
        tH.isActive = true
        
        postReplies.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        postReplies.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postReplies.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        postReplies.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        //        layoutIfNeeded()
    }
}



class PostTableViewCellWithoutReplies: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(comment)
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultLow
        tH.isActive = true
        
        comment.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

class PostTableViewCellWithoutImageAndReplies: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(comment)
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        comment.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

class PostTableViewCellWithoutRepliesAndComment: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(thumbnailsCollectionView)
        contentView.addSubview(comment)
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        thumbnailsCollectionView.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        thumbnailsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        thumbnailsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        thumbnailsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        let tH = thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: 90.0)
        tH.priority = .defaultLow
        tH.isActive = true
        
    }
}

class PostTableViewCellWithoutRepliesAndComentAndImage: PostTableViewCell {
    override func setupViews() {
        contentView.addSubview(postId)
        
        
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        postId.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        postId.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}*/
