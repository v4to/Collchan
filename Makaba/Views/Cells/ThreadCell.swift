//
//  ThreadCell.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 24.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadCell: BoardsListTableViewCell {
    // MARK: - Instance Properties
    let threadThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(17.0)
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        return label
    }()
    
    let detail: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
        return view
    }()
    
    
    
    let detailText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(14.0)
        return label
    }()
    
    let postnumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(13.0)
        label.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        return label
    }()
    
    let fileImage: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        var image = UIImage(systemName: "photo", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1), renderingMode: .alwaysOriginal)
        
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .bottom
        return imageView
    }()
    
    let filesCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "46"
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(12.0)
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }()
    
    
    let commentImage: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        var image = UIImage(systemName: "text.bubble", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1), renderingMode: .alwaysOriginal)
        
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .bottom
        return imageView
    }()
    
    
    let postsCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "146"
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(12.0)
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)

        return label
    }()
    
    
    let clockImage: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        var image = UIImage(systemName: "clock", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1), renderingMode: .alwaysOriginal)
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .bottom
        return imageView
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "16.06.2020, 15:36"
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(12.0)
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)

        return label
    }()
    
    
    
    
    // MARK: - Intialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupSwipeIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    // MARK: - Instance Properties


    // MARK: - Instance Methods
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "bookmark.fill", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
    
    
    func setupViews() {
//        backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        
        
//        contentView.addSubview(postnumber)
        contentView.addSubview(heading)
        contentView.addSubview(detail)
        detail.addSubview(postnumber)
        detail.addSubview(detailText)
        detail.addSubview(fileImage)
        detail.addSubview(filesCount)
        detail.addSubview(commentImage)
        detail.addSubview(postsCount)
        detail.addSubview(clockImage)
        detail.addSubview(date)
        contentView.addSubview(threadThumbnail)


        heading.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        heading.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0).isActive = true
        heading.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0).isActive = true
        heading.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        
        detail.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10.0).isActive = true
        detail.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15.0).isActive = true
        detail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 118.0).isActive = true
        detail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        
        postnumber.topAnchor.constraint(equalTo: detail.topAnchor, constant: 0.0).isActive = true
        postnumber.leftAnchor.constraint(equalTo: detail.leftAnchor, constant: 0.0).isActive = true

        
        detailText.topAnchor.constraint(equalTo: postnumber.bottomAnchor, constant: 5.0).isActive = true
        detailText.leftAnchor.constraint(equalTo: detail.leftAnchor).isActive = true
        detailText.rightAnchor.constraint(equalTo: detail.rightAnchor).isActive = true
        detailText.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)


        fileImage.topAnchor.constraint(equalTo: detailText.bottomAnchor, constant: 5.0).isActive = true
        fileImage.leftAnchor.constraint(equalTo: detailText.leftAnchor).isActive = true
        fileImage.bottomAnchor.constraint(equalTo: detail.bottomAnchor).isActive = true
        
        filesCount.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor).isActive = true
        filesCount.leftAnchor.constraint(equalTo: fileImage.rightAnchor, constant: 3.0).isActive = true
        
        commentImage.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor).isActive = true
        commentImage.leftAnchor.constraint(equalTo: filesCount.rightAnchor, constant: 5.0).isActive = true
        
        postsCount.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor).isActive = true
        postsCount.leftAnchor.constraint(equalTo: commentImage.rightAnchor, constant: 3.0).isActive = true
        
        clockImage.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor).isActive = true
        clockImage.leftAnchor.constraint(equalTo: postsCount.rightAnchor, constant: 5.0).isActive = true
        
        date.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor).isActive = true
        date.leftAnchor.constraint(equalTo: clockImage.rightAnchor, constant: 3.0).isActive = true

        threadThumbnail.widthAnchor.constraint(equalToConstant: 88.0).isActive = true
        threadThumbnail.heightAnchor.constraint(equalToConstant: 88.0).isActive = true
        threadThumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0).isActive = true
        threadThumbnail.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10.0).isActive = true
        threadThumbnail.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15.0).isActive = true
    }

}

