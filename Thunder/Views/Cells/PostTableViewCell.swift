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
    // MARK: - Instance Propeties
    
    override var actionViewBackgroundColor: UIColor {
        return #colorLiteral(red: 0, green: 0.5098509789, blue: 0.9645856023, alpha: 1)
    }
    lazy var postId = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .headline).withSize(14.0))
    lazy var date = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .footnote).withSize(14.0))
    
    let comment: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        text.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        text.textAlignment = .left
        text.isSelectable = true
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    let postReplyId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(13.0)
        label.textColor = .systemBlue
        return label
    }()
    
    let quote: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        label.textColor = .systemGreen
        return label

    }()
    
    func createHeaderLabelWithFont(_ font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSwipeIcon()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Gestures
    
    @objc func handleTap(_ gesutreRecognizer: UITapGestureRecognizer) {
        print("label tapped")
    }
    
    // MARK: - Instance Methods
    func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(date)
        contentView.addSubview(comment)
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 5.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        
        date.centerYAnchor.constraint(equalTo: postId.centerYAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        
        comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: postId.leftAnchor).isActive = true
        comment.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

    }
    
    func createCommentAttributeStringFromNode(_ root: XMLNode) -> NSMutableAttributedString {
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
                        NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                        NSAttributedString.Key.link: URL(string: root.stringValue)!
                    ]
                )
        }
        
        if root.parent?.attr("class") == "s" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.strikethroughColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1),
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
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
                    NSAttributedString.Key.foregroundColor: UIColor.systemGreen
                ]
            )
        }
        
        if root.parent?.attr("class") == "post-reply-link" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(14.0),
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue
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
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
            ]
        )
    }
    
    func configure(_ post: Post) {
        postId.text = "#" + post.postId
        date.text = post.dateString
        
        let commentText = post.comment.replacingOccurrences(of: "<br>", with: "\n")
        if let doc = try? HTMLDocument(string: commentText), let body = doc.body {
            let result = createCommentAttributeStringFromNode(body)
            comment.attributedText = result
        }
    }
    
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "arrowshape.turn.up.left.circle", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
}

