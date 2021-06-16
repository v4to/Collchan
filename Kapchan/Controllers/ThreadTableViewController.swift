//
//  ThreadTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 02.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadTableViewController: UITableViewController {
    
    
    @objc func actionOpenRepliesModel(_ sender: UIButton) {
        let postRepliesVC = PostRepliesViewController()
        present(postRepliesVC, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    var newPosts = [PostWithIntId]()
    var savedLastIndex = 0
    var isDataSourceLoading = false
    var cellHeights = [Int: CGFloat]()
    var postsArray = [PostWithIntId]()
    var imageTasks = [String: URLSessionDataTask]()
    var boardId: String?
    var threadId: String?
    var threadName: String?

    var cellId = "postCell"
    
    // MARK: View Properties
    
    var fakeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    var scrollToBottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(scrollToBottomButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = Constants.Design.Color.gap
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.separator.cgColor
        button.layer.cornerRadius = 44.0/2

        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(
            systemName: "chevron.down",
            withConfiguration: configuration
        )?.withTintColor(Constants.Design.Color.secondaryGray, renderingMode: .alwaysOriginal)
        
        button.setImage(image, for: .normal)

        return button
    }()
    
    
    var spinner: UIActivityIndicatorView = {
        let ativityIndicator = UIActivityIndicatorView(style: .medium)
        ativityIndicator.center = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.center
        return ativityIndicator
    }()
    
    var spinnerRefresh = UIActivityIndicatorView()
    
    
    
   

    
   
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = threadName

        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = moreButton


        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(spinner)
        
        spinner.startAnimating()
        setupTableView()
        setUpPopGesture()
        loadPosts()
        setupViews()
    }
    
    // MARK: - Actions
    
    @objc func createNewPostButtonAction(_ sender: UIBarButtonItem) {
        let presentationModelVC = CreatePostModalViewController()
        presentationModelVC.boardId = boardId
        presentationModelVC.threadId = threadId
        presentationModelVC.postText.becomeFirstResponder()
        //        presentationModelVC.modalPresentationStyle = .overFullScreen
        present(presentationModelVC, animated: true, completion: nil)
    }
    
    @objc func scrollToBottomButtonAction(_ sender: UIButton) {
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: self.postsArray.count - 1, section: 0) , at: .bottom , animated: true)
        }
    }
    

    // MARK: - Methods
    
    func setupViews() {
        let navigationController = self.navigationController!
        navigationController.view.addSubview(self.fakeTableView)
        self.fakeTableView.leadingAnchor.constraint(
            equalTo: navigationController.view.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        self.fakeTableView.trailingAnchor.constraint(
            equalTo: navigationController.view.safeAreaLayoutGuide.trailingAnchor
        ).isActive = true
        self.fakeTableView.bottomAnchor.constraint(
            equalTo: navigationController.view.bottomAnchor,
            constant: -self.tabBarController!.tabBar.frame.height
        ).isActive = true
        self.fakeTableView.heightAnchor.constraint(
            equalToConstant: 60.0
        ).isActive = true
        self.tableView.addSubview(self.scrollToBottomButton)
        self.scrollToBottomButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.scrollToBottomButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.scrollToBottomButton.bottomAnchor.constraint(
            equalTo: self.tableView.safeAreaLayoutGuide.bottomAnchor,
            constant: -15.0
        ).isActive = true
        self.scrollToBottomButton.trailingAnchor.constraint(
            equalTo: self.tableView.safeAreaLayoutGuide.trailingAnchor,
            constant: -15.0
        ).isActive = true
        
        self.tableView.addSubview(self.spinnerRefresh)
        self.spinnerRefresh.hidesWhenStopped = true
    }
    
    func setupTableView() {
        self.refreshControl = UIRefreshControl()
        self.tableView.prefetchDataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.estimatedRowHeight = 0.0
        self.tableView.estimatedSectionFooterHeight = 0.0
        self.tableView.estimatedSectionHeaderHeight = 0.0
        self.tableView.allowsSelection = false
        // remove bottom separator when tableView is empty
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    
        self.tableView.backgroundColor = Constants.Design.Color.gap
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
    @objc func loadPosts() {
        guard let boardId = boardId, let threadId = threadId, !self.isDataSourceLoading else {
            return
        }
        self.isDataSourceLoading = true
        NetworkService.shared.getPostsFrom(boardId: boardId, threadId: threadId) { [weak self] (wrapper: PostsWrapper?) in
        	
            guard let self = self, let wrapper = wrapper else {
                return
            }

//            guard let self = self, let posts = posts else {
//                return
//            }
            
            self.postsArray = wrapper.posts
            
            let width = self.tableView.bounds.width
            DispatchQueue.global().async {
                if self.postsArray.count < wrapper.posts.count {
                    let end = self.postsArray.count
                    let newPosts = wrapper.posts[end..<wrapper.posts.count]
                    self.postsArray.append(contentsOf: Array(newPosts))
                    self.postsArray = self.setupReplies(inArray: self.postsArray)
                    for index in self.postsArray.indices {
                        self.cellHeights[index] = self.postsArray[index]
                            .calculateTotalHeighAndFrames(width: width)
//                        self.postsArray[index].convertedAttributedString = self.postsArray[index].attributedComment.image(with: PostTableViewCell.frames[index]!.commentFrame.size)
//                        self.postsArray[index].convertedAttributedStringLandscape = self.postsArray[index].attributedComment.image(with: PostTableViewCell.frames[index]!.commentFrame.size)

                    }
                }
                DispatchQueue.main.async {
                    if self.fakeTableView.refreshControl?.isRefreshing == true {
                        self.fakeTableView.refreshControl?.endRefreshing()
                        self.tableView.reloadData()
                        UIView.animate(withDuration: 0.3) {
                            self.tableView.contentInset = UIEdgeInsets(
                                top: 0.0,
                                left: 0.0,
                                bottom: 0.0,
                                right: 0.0
                            )
                        }
                        self.tableView.scrollToRow(
                            at: IndexPath(row: self.savedLastIndex, section: 0),
                            at: .bottom,
                            animated: true
                        )

                        
                    } else {
                        self.spinner.stopAnimating()
                        
                        self.tableView.reloadData()
                
                        if self.tableView.contentSize.height + self.tableView.adjustedContentInset.top
                            + self.tableView.adjustedContentInset.bottom < self.tableView.bounds.height {
                            self.scrollToBottomButton.isHidden = true
                        }
                    }
                    self.isDataSourceLoading = false
                }
            }
            
            
        }
    }

    
    
    func setUpPopGesture() {
        let popGestureRecognizer = navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            view.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.delegate = self
        }
    }
    
    

   
    
    func setupReplies() {
        var postReplies = [Int: [PostWithIntId]]()
        for post in self.postsArray {
            var post = post
            post.setupAttributedComment()
//            if let attributedComment = post.attributedComment {
                let attributedComment = post.attributedComment
                let range = NSRange(location: 0, length: attributedComment.string.count)
                let regex = try! NSRegularExpression(pattern: ">>(\\d+)", options: NSRegularExpression.Options.caseInsensitive)
                let matches = regex.matches(in: attributedComment.string, options: [], range: range)
//                print("matches.count ---", matches.count)
                
                if matches.count > 0 {
                    for match in matches {
//                        print("range ---", match.range)
//                        print("numberOfRanges ---", match.numberOfRanges)
//                        print("range 0 ---", match.range(at: 0))
//                        print("range 1 ---", match.range(at: 1))
                        let range = Range(match.range(at: 1), in: attributedComment.string)!
                        let postId = Int(attributedComment.string[range]) ?? 0
                        if postReplies[postId] == nil {
                            postReplies[postId] = [post]
                        } else {
                            postReplies[postId]?.append(post)
                        }
                    }
                }
                
//            }
        }
//        dump(postReplies)
        
        
        self.postsArray = self.postsArray.map {
            var post = $0
            
            if let replies = postReplies[post.postId] {
                post.replies.append(contentsOf: replies)
            }
//            let string = post.attibutedComment
            post.setupAttributedComment()

            post.mapDateToString()
            post.setupThumbnailUrls()
            return post
        }
        
        
//        dump(self.postsArray)

    }
}


// MARK: - UITableViewDelegate
extension ThreadTableViewController {
    
    // MARK: - Methods
    
    // MARK: UITableViewDelegate potocol methods

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]!
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeights[indexPath] ?? 9999.0
//    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.global().async {
            if let task = self.imageTasks[indexPath] {
                task.cancel()
                self.imageTasks.removeValue(forKey: indexPath)
            }
        }
       
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var post = postsArray[indexPath.row]

        if post.images.count > 0 || imageTasks[indexPath] != nil {
            return
        }
        
        let cell = cell as! PostTableViewCell

        DispatchQueue.global().async {
            if post.files.count > 0 {
                for file in post.files {
                    let thumbnailUrl = URL(string:BaseUrls.dvach + file.thumbnail)!
                    let task = URLSession.shared.dataTask(with: thumbnailUrl) { (data, reponse, error) in
                        if let data = data {
                            let image = UIImage(data: data)!
                            post.images.append(image)
                            self.postsArray[indexPath.row] = post

                            DispatchQueue.main.async {
                                if post.images.count == post.files.count {
                                    //                                cell.configure(post)
                                    cell.setupThumbnails(images: post.images, post: post)

//                                                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                                //                            cell?.configure(post)
                                //                            cell?.setupThumbnails(images: post.images)
                                //                            cell?.thumbnails.append(image)
                                //                            cell?.setupThumbnails(images: <#T##[UIImage]#>)
                            }
                        }
                    }
                    task.resume()
                    self.imageTasks[indexPath] = task
                }
            }

        }
    }
}

// MARK: - UITableViewDataSource
extension ThreadTableViewController {
    
    // MARK: - Methods
    
    // MARK: UITableViewDataSource protocol methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var post = postsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.configure(post)
        DispatchQueue.global().async {
            for file in post.files {
                if post.images.count != post.files.count ||
                   !self.imageTasks.contains( where: { $0.key == file.thumbnail })
                {
                    let thumbnailUrl = URL(string:BaseUrls.dvach + file.thumbnail)!
                    let task = URLSession.shared.dataTask(with: thumbnailUrl) {
                        [weak self] (data, reponse, error) in
                            guard let self = self else {
                                return
                            }
                            if var data = data {
                                data = data.fixHeader()
                                if let image = UIImage(data: data) {
                                    post.images.append(image)
                                } else {
                                    post.images.append(UIImage(named: "placeholder")!)
                                }
                                self.postsArray[indexPath.row] = post
                                DispatchQueue.main.async {
                                    // Image-fetching callbacks are holding references
                                    // to the tableview cells. When the download completes,
                                    // it sets the imageView.image property,
                                    // even if you have recycled the cell to display a different row.
                                    // Need to test whether the image is still relevant
                                    // to the cell before setting the image
                                    // https://stackoverflow.com/questions/15668160/asynchronous-downloading-of-images-for-uitableview-with-gcd/15668366#15668366
                                    if cell.postIdString == "\(post.postId)" {
                                        cell.setupThumbnails(images: post.images)
                                    }
                                }
                            }
                    }
                    task.resume()
                    self.imageTasks[file.thumbnail] = task
                }
                    
            }
        }
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ThreadTableViewController: UIGestureRecognizerDelegate {
    
    // MARK: - Methods

    // MARK: UIGestureRecognizerDelegate protocol methods

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            // if horizontalComponent of velocity is greater than vertical that
            // means pan gesture is moving in horizontal direction(swipe alike)
            // and so pan gesture of contentView should begin
            let horizontalComponent = abs(panGesture.velocity(in: self.view).x)
            let verticalComponent = abs(panGesture.velocity(in: self.view).y)
            return horizontalComponent > verticalComponent
        }
        
        // otherwise ignore pan gesture of contentView in favor of parent
        // contentView pan gesture
        return false
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ThreadTableViewController: UITableViewDataSourcePrefetching {
    
    // MARK: - Methods
    
    // MARK: UITableViewDataSourcePrefetching protocol methods

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        DispatchQueue.global().async {
            for indexPath in indexPaths {
                var post = self.postsArray[indexPath.row]

                if post.images.count > 0 || self.imageTasks[indexPath] != nil {
                    continue
                }

                if post.files.count > 0 {
                    for file in post.files {
                        let thumbnailUrl = URL(string:BaseUrls.dvach + file.thumbnail)!
                        let task = URLSession.shared.dataTask(with: thumbnailUrl) { (data, reponse, error) in
                            if var data = data {
                                //                            let dataFixedHeader = data.fixHeader()
                                //                            data.fixHeader()
//                                data = self.fixHeader(in: data)
                                let image = UIImage(data: data)!
                                post.images.append(image)
                                self.postsArray[indexPath.row] = post

//                                DispatchQueue.main.async {
//                                    //                                tableView.reloadRows(at: [indexPath], with: .automatic)
//                                }
                            }
                        }
                        task.resume()
                        self.imageTasks[indexPath] = task
                    }
                }

            }

        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let task = imageTasks[indexPath] {
                task.cancel()
                imageTasks.removeValue(forKey: indexPath)
            }
        }
    }
}

// MARK: - SwipeableCellDelegate

extension ThreadTableViewController: SwipeableCellDelegate {
    
    // MARK: - Methods

    // MARK: SwipeableCellDelegate protocol methods

    func cellDidSwipe(cell: BoardsListTableViewCell) {
        let cell = cell as! PostTableViewCell
        let presentationModelVC = CreatePostModalViewController()
        presentationModelVC.boardId = boardId
        presentationModelVC.threadId = threadId
        presentationModelVC.postToReplyId = cell.postIdString
        presentationModelVC.postText.becomeFirstResponder()
        present(presentationModelVC, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension ThreadTableViewController {
    
    // MARK: - Methods
    
    // MARK: UIScrollViewDelegate protocol methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.bounds.height
        let adujustedInsetBottom = scrollView.adjustedContentInset.bottom
        
        guard contentSizeHeight > 0 else {
            return
        }
    
        if contentOffsetY + scrollViewHeight - adujustedInsetBottom >= contentSizeHeight {
            UIView.animate(withDuration: 0.2) {
                self.scrollToBottomButton.alpha = 0.0
            } completion: { isFinished in
                self.scrollToBottomButton.isHidden = true
            }
            if contentOffsetY + scrollViewHeight - adujustedInsetBottom - contentSizeHeight <= 80  {
                if !self.isDataSourceLoading {
                    self.fakeTableView.contentOffset.y = -(contentOffsetY + scrollViewHeight - adujustedInsetBottom - contentSizeHeight)
                }
            } else if !self.fakeTableView.refreshControl!.isRefreshing {
                print(contentOffsetY + scrollViewHeight - adujustedInsetBottom - contentSizeHeight)
                // make sure that finer still touching screen while dragging
                if !scrollView.isDecelerating {
                    self.fakeTableView.refreshControl?.beginRefreshing()
                }
                
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.scrollToBottomButton.alpha = 1.0
            } completion: { isFinished in
                self.scrollToBottomButton.isHidden = false

            }
        }
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let offset = scrollView.contentOffset
            let bounds = scrollView.bounds
            let size = scrollView.contentSize
            let inset = scrollView.contentInset

            let maxY = offset.y + bounds.size.height - inset.bottom

            let contentSizeHeight = size.height

            let reloadDistance = CGFloat(80.0)
            if maxY > contentSizeHeight + reloadDistance, !isDataSourceLoading {
                self.tableView.contentInset = UIEdgeInsets(
                    top: 0.0,
                    left: 0.0,
                    bottom: 60.0,
                    right: 0.0
                )
                savedLastIndex = self.postsArray.count - 1
                self.loadPosts()
                self.isDataSourceLoading = true
            } else {
                self.fakeTableView.refreshControl?.endRefreshing()
            }
    }
}

//extension ThreadTableViewController {
//    func fixHeader(in data: Data) -> Data {
//        let checkValue: UInt8 = data.withUnsafeBytes { p in
//            var result = p[5]
//            return result
//        }
////        let checkValue: UInt8 = data.withUnsafeBytes {
////            print($0[5])
////            return $0[5]
////            return ($0 + 5).pointee
////            var result = $0.baseAddress! + 5
////            return $0.baseAddress!.advanced(by: 5)
//
////        }
//
////        print(checkValue)
//
//        if checkValue != 14 {
//            return data
//        }
//
//        var data = data
//        data.removeSubrange(2..<18)
//
//        return data
//    }
//}
