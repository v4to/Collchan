//
//  ThreadsTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 16.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadCell: UICollectionViewCell {
    // MARK: - Instance Properties
    let threadThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
//    var threadThumbnail: UIImageView? {
//        didSet {
//            threadThumbnail!.contentMode = .scaleAspectFill
//
//            addSubview(threadThumbnail!)
//
//            threadThumbnail?.translatesAutoresizingMaskIntoConstraints = false
//
//            threadThumbnail?.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            threadThumbnail?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//            threadThumbnail?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            threadThumbnail?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        }
//    }
    
    
    
    // MARK: - Intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    // MARK: - Instance Properties
    let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "text"
        label.textColor = .black
        return label
    }()

    // MARK: - Instance Methods
    func setupViews() {
        backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        
        addSubview(threadThumbnail)
        threadThumbnail.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        threadThumbnail.heightAnchor.constraint(equalToConstant: 80.0).isActive = true

        threadThumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        threadThumbnail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        threadThumbnail.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
//        threadThumbnail.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        addSubview(wordLabel)
//        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        wordLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

    }

}


class ThreadsCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - Instance Properties
    var threadId = ""
    
    private let cellId = "cellId"
    
    private var sectionsArray = [Thread]()
    
    lazy var spinner: UIActivityIndicatorView = {
        let ativityIndicator = UIActivityIndicatorView()
        ativityIndicator.center = navigationController!.view.center
        return ativityIndicator
    }()
    
    // MARK: - Initialization
    

    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = threadId
//        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        
        collectionView.backgroundColor = #colorLiteral(red: 0.04705037922, green: 0.0470642224, blue: 0.04704734683, alpha: 1)
        collectionView.register(ThreadCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        navigationController?.view.addSubview(spinner)
        
        spinner.startAnimating()
        
//        collectionView.alpha = 0.0
//        collectionView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
//      self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    var threadsService = ThreadsService()
    
//    var threadsRequest: API
//    var threadsRequest: API
    
    
    var imageRequests = [ImageRequest]()
    var images = [UIImage?]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(threadId)
        threadsService.getThreads(
            from: threadId,
            completion: { result in
                
                self.sectionsArray = result!.threads
                
//                dump(self.sectionsArray)
                
                for section in self.sectionsArray {
//                    let path = section.files[0].thumbnail
                    let path = section.posts[0].files[0].thumbnail
                    let url = URL(string: BaseUrls.dvach + path)!
                    let imageRequest = ImageRequest(url: url)
                    self.imageRequests.append(imageRequest)
                }
                
                var counter = self.sectionsArray.count
                for imageRequest in self.imageRequests {
                    
//                    imageRequest?.load(withCompletion: completion)
//                    for file in section.files {
//                    print(section.files[0].thumbnail)
                    imageRequest.load { (image) in
//                        print(image)
                        counter -= 1
                        self.images.append(image)
                        if counter == 0 {
//                            print(self.images)
                            self.collectionView.reloadData()
                            
                            self.spinner.stopAnimating()
                            
//                            self.collectionView.alpha = 1.0
//                            self.collectionView.isHidden = false
                        }
                    }
                    
//                    }
                }
                
//                self.threadsService.getThreadsThumbnailImageAtPath(
//                    self.sectionsArray[0].files[0].path,
//                    completion: { (data) in
//                        print(data)
//                    }
//                )
                
                self.collectionView.reloadData()
            }
        )
    }

    // MARK: - CollectionView
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sectionsArray.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ThreadCell
        if images.count > 0 {
//            print(indexPath.item)
//            print(images[indexPath.section])
            cell.threadThumbnail.image = images[indexPath.item]
        }
        cell.addBorder(side: .bottom, color: #colorLiteral(red: 0.1372389793, green: 0.1372650862, blue: 0.1372332871, alpha: 1) , width: 1.0)
        cell.addBorder(side: .top, color: #colorLiteral(red: 0.1372389793, green: 0.1372650862, blue: 0.1372332871, alpha: 1) , width: 1.0)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
//        return self.collectionView.frame.size
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

    
    
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
