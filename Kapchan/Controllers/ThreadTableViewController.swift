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
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        tableView.isUserInteractionEnabled = false
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
            equalToConstant: 400.0
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
        self.tableView.prefetchDataSource = self
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
    
    override func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let post = self.postsArray[indexPath.row]
        for file in post.files {
            if let task = self.imageTasks[file.thumbnail] {
                task.cancel()
                self.imageTasks.removeValue(forKey: file.thumbnail)
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
        /*
         When the table view initially appears, the images are all
         missing from the visible rows. That’s because the runtime
         calls tableView(_:prefetchRowsAt:) for future table rows,
         but not for the rows that are initially visible! Need to call
         prefetchRowsAt ourself
        */
        for file in post.files {
            if self.imageTasks[file.thumbnail] == nil && file.thumbnailImage == nil {
	            self.tableView(tableView, prefetchRowsAt: [indexPath])
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

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            var post = self.postsArray[indexPath.row]

            for (index, file) in post.files.enumerated() {
                if file.thumbnailImage == nil && !self.imageTasks.contains( where: { $0.key == file.thumbnail }) {
                    let thumbnailUrl = URL(string: BaseUrls.dvach + file.thumbnail)!
                    let task = URLSession.shared.dataTask(with: thumbnailUrl) { [weak self] (data, reponse, error) in
                        guard let self = self else {
                            return
                        }

                        if var data = data {
                            data = data.fixHeader()

                            if let image = UIImage(data: data)/*?.resized(to: CGSize(width: 90.0, height: 90.0))*/ {
                                post.files[index].thumbnailImage = image
                            } else {
                                post.files[index].thumbnailImage = UIImage(named: "placeholder")!
                            }
                            self.postsArray[indexPath.row] = post
                            
                            DispatchQueue.main.async {
                                if
                                    let cell = self.tableView.cellForRow(at: indexPath) as? PostTableViewCell,
                                   	cell.postIdString == "\(post.postId)" {
                                    cell.setupThumbnails(files: post.files)
                                }
                            }
                        }
                    }
                    self.imageTasks[file.thumbnail] = task
                    task.resume()
                }
            }
        }
    }
  
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let post = self.postsArray[indexPath.row]
            for file in post.files {
                if let task = self.imageTasks[file.thumbnail] {
                    task.cancel()
                    self.imageTasks.removeValue(forKey: file.thumbnail)
                }
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
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let visibleRowsIndexPaths = self.tableView.indexPathsForVisibleRows!
        self.tableView(self.tableView, prefetchRowsAt: visibleRowsIndexPaths)
        self.newPosts = []
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.bounds.height
        let adujustedInsetBottom = scrollView.adjustedContentInset.bottom
        let statusBarHeight = UIApplication.shared.keyWindow!.windowScene!.statusBarManager!.statusBarFrame.height

        guard contentSizeHeight > 0 else {
            return
        }

        if
            contentOffsetY.rounded(.up) > -(navigationController!.navigationBar.frame.height + statusBarHeight) &&
            contentOffsetY.rounded(.up) + scrollViewHeight - adujustedInsetBottom >= contentSizeHeight
        {
            UIView.animate(withDuration: 0.2) {
                self.scrollToBottomButton.alpha = 0.0
            } completion: { _ in
                self.scrollToBottomButton.isHidden = true
            }
            self.fakeTableView.refreshControl?.layer.opacity = 1.0

            if -((scrollViewHeight - adujustedInsetBottom - (navigationController!.navigationBar.frame.height + statusBarHeight)) - (contentOffsetY + scrollViewHeight - adujustedInsetBottom)) <= 110 {
                if !self.isDataSourceLoading {
                    self.fakeTableView.contentOffset.y =
                        (scrollViewHeight - adujustedInsetBottom -
                            (navigationController!.navigationBar.frame.height + statusBarHeight)) - (contentOffsetY + scrollViewHeight - adujustedInsetBottom - 30)
                }
            } else if contentOffsetY + scrollViewHeight - adujustedInsetBottom - contentSizeHeight <= 110 {
                if !self.isDataSourceLoading, !self.fakeTableView.refreshControl!.isRefreshing {
                    self.fakeTableView.contentOffset.y = -(contentOffsetY + scrollViewHeight - adujustedInsetBottom - contentSizeHeight)
                }
            } else if !self.fakeTableView.refreshControl!.isRefreshing {
                // make sure that finger still touching screen while dragging
                if !scrollView.isDecelerating {
                    self.fakeTableView.refreshControl?.beginRefreshing()
                }
            }
        } else {
    		// TODO: - TODO: add isLoading flag check
            if self.tableView.contentInset.bottom == 0.0 {
                self.fakeTableView.refreshControl?.layer.opacity = 0.0
            }
            if contentSizeHeight > scrollViewHeight && self.newPosts.count != 1 {
                UIView.animate(withDuration: 0.2) {
                    self.scrollToBottomButton.alpha = 1.0
                } completion: { _ in
                    self.scrollToBottomButton.isHidden = false
                }
            } else {
                self.scrollToBottomButton.alpha = 0.0
                self.scrollToBottomButton.isHidden = true
            }
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !self.isDataSourceLoading {
            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset = UIEdgeInsets(
                    top: 0.0,
                    left: 0.0,
                    bottom: 0.0,
                    right: 0.0
                )
            }
            self.fakeTableView.refreshControl?.endRefreshing()
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
