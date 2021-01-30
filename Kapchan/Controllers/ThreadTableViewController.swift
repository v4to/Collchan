//
//  ThreadTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 02.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadTableViewController: UITableViewController, UIGestureRecognizerDelegate, SwipeableCellDelegate, UIToolbarDelegate {
    func cellDidSwipe(cell: BoardsListTableViewCell) {
        var cell = cell as! PostTableViewCell
        let presentationModelVC = CreatePostModalViewController()
        presentationModelVC.boardId = boardId
        presentationModelVC.threadId = threadId
        presentationModelVC.postToReplyId = cell.postIdString
        presentationModelVC.postText.becomeFirstResponder()
//        presentationModelVC.modalPresentationStyle = .overFullScreen
        present(presentationModelVC, animated: true, completion: nil)
    }
    
    @objc func actionOpenRepliesModel(_ sender: UIButton) {
        let postRepliesVC = PostRepliesViewController()
//        postRepliesVC.modalPresentationStyle = .over
        present(postRepliesVC, animated: true, completion: nil)

//        presentationModelVC.boardId = boardId
//        presentationModelVC.threadId = threadId
//        print("touch")
    }
    // MARK: - Instance Methods
    lazy var scrollToBottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(scrollToLastRow(_:)), for: .touchUpInside)
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
    
    var spinnerRefresh = UIActivityIndicatorView()

    var isDataSourceLoading = true
    
    var cellHeights = [Int: CGFloat]()
    var boardId: String?
    var threadId: String?
    var threadName: String?
//    var postsArray = [Post]()
    var postsArray = [PostWithIntId]()

    var cellId = "postCell"
//    var cellHeights = [IndexPath: CGFloat]()
    lazy var spinner: UIActivityIndicatorView = {
        let ativityIndicator = UIActivityIndicatorView(style: .medium)
        ativityIndicator.center = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.center
        return ativityIndicator
    }()

    
    var threadActions: UIToolbar = {
        var toolBar = UIToolbar()
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let baButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: nil, action: nil)
        toolBar.setItems([baButton], animated: true)
        toolBar.sizeToFit()

        return toolBar
    }()
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .bottom
    }
    // MARK: - Initialization
    
//    override init(style: UITableView.Style) {
//        super.init(style: style)
//
////        extendedLayoutIncludesOpaqueBars = true
////        setToo
////         let baButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: nil, action: nil)
////        //        hidesBottomBarWhenPushed = true
////                setToolbarItems([baButton], animated: true)
////                navigationController?.setToolbarHidden(false, animated: false)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Actions
    @objc func createNewPostAction(_ sender: UIBarButtonItem) {
        let presentationModelVC = CreatePostModalViewController()
        presentationModelVC.boardId = boardId
        presentationModelVC.threadId = threadId
        presentationModelVC.postText.becomeFirstResponder()
        //        presentationModelVC.modalPresentationStyle = .overFullScreen
        present(presentationModelVC, animated: true, completion: nil)
    }
    
    @objc func scrollToLastRow(_ sender: UIButton) {
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: self.postsArray.count - 1, section: 0) , at: .bottom , animated: true)
        }
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = threadName
//        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
        
        let gap = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        fixedSpace.width = -10
        
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: nil, action: nil)
//        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        let scrollToBottomButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down"), style: .plain, target: self, action: #selector(scrollToLastRow(_:)))
        let newPostButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewPostAction(_:)))
        
        
//        navigationItem.rightBarButtonItems = [shareButton, scrollToBottomButton]
        navigationItem.rightBarButtonItem = shareButton

        
        extendedLayoutIncludesOpaqueBars = true
        
        
        
//        let gap = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let baButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(scrollToLastRow(_:)))
        let baButton1 = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewPostAction(_:)))
        
        let baButton2 = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: nil, action: nil)
        let baButton3 = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: nil, action: nil)
        let baButton4 = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: nil, action: nil)


//        setToolbarItems([baButton, gap, baButton1, gap, baButton4, gap, baButton3, gap, baButton2], animated: true)
        //        navigationController?.toolbar.barStyle = .black
        
//        navigationController?.toolbar.isOpaque = true
        
        
//        view.addSubview(threadActions)
//        threadActions.delegate = self
//        navigationController?.view.addSubview(threadActions)
//        threadActions.bottomAnchor.constraint(equalTo: navigationController!.view.layoutMarginsGuide.bottomAnchor).isActive = true
//        threadActions.leftAnchor.constraint(equalTo: navigationController!.view.leftAnchor).isActive = true
//        threadActions.rightAnchor.constraint(equalTo: navigationController!.view.rightAnchor).isActive = true
//        threadActions.heightAnchor.constraint(equalTo: navigationController!.tabBarController!.tabBar.heightAnchor).isActive = true
//        threadActions.topAnchor.constraint(equalTo: navigationController!.tabBarController!.tabBar.topAnchor
//).isActive = true
        
//        hidesBottomBarWhenPushed = true
//        tabBarController?.tabBar.isHidden = true
        
//        navigationController?.toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        hidesBottomBarWhenPushed = true
//        let baButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: nil, action: nil)
//        setToolbarItems([baButton], animated: true)
////        navigationController?.toolbar.isHidden = false
//        navigationController?.setToolbarHidden(false, animated: false)
//        navigationController?.toolbar.isTranslucent = false
//        navigationController?.toolbar.translatesAutoresizingMaskIntoConstraints = false
//        navigationController?.toolbar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        tableView.addSubview(spinner)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(spinner)
        spinner.startAnimating()
        setupTableView()
        setUpPopGesture()
        loadPosts()
        setupViews()
        
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews --- \(tableView.contentSize.height)")

    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews --- \(tableView.contentSize.height)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear --- \(tableView.contentSize.height)")
    
    func setupViews() {
        self.tableView.addSubview(self.scrollToBottomButton)
        self.scrollToBottomButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.scrollToBottomButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.scrollToBottomButton.bottomAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.bottomAnchor, constant: -15.0).isActive = true
        self.scrollToBottomButton.trailingAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
        
        self.tableView.addSubview(self.spinnerRefresh)
        self.spinnerRefresh.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("contentInset = \(tableView.adjustedContentInset)")
        print("viewDidAppear --- \(tableView.contentSize.height)")
        print("viewDidAppear --- \(tableView.frame.size.height)")


       
//         navigationController?.toolbar.isTranslucent = false
//         navigationController?.setToolbarHidden(false, animated: false)

//        edgesForExtendedLayout = UIRectEdge.bottom
        
                
                
               
        //        navigationController?.toolbar.barTintColor = .systemBlue

                
//        self.tabBarController?.tabBar.isHidden = true
//                navigationController?.toolbar.isHidden = false
        //        self.extendedLayoutIncludesOpaqueBars = true;
        //        self.edgesForExtendedLayout = .bottom;
                
//        UIView.performWithoutAnimation {

//        }

        
        //        navigationController?.toolbar.isHidden = false
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            tabBarController?.tabBar.isHidden = true
//            edgesForExtendedLayout = UIRectEdge.bottom
//            extendedLayoutIncludesOpaqueBars = true
//        }
//        navigationController?.setToolbarHidden(false, animated: false)
    }

    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("scrollViewWillEndDragging")
    }
    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        <#code#>
//    }
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
////        let offset = scrollView.contentOffset
////        let bounds = scrollView.bounds
////        let size = scrollView.contentSize
////        let inset = scrollView.contentInset
////
////        let y = offset.y + bounds.size.height - inset.bottom
////        let h = size.height
////
////        let reloadDistance = CGFloat(60.0)
////        if y > h + reloadDistance {
////            tableView.tableFooterView = spinnerRefresh
//////                spinnerRefresh.frame.size.height = 60.0
//////                tableView.tableFooterView?.isHidden = false
////            spinnerRefresh.startAnimating()
////            print("fetch more data")
////            let timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] timer in
////                self?.spinnerRefresh.stopAnimating()
//////                    self?.tableView.tableFooterView = nil
////                self?.tableView.scrollToRow(at: IndexPath(row: self!.postsArray.count - 1, section: 0) , at: .bottom , animated: true)
//////                    self?.tableView.tableFooterView = UIView(frame: .zero)
//////                    self?.tableView.tableFooterView?.isHidden = true
////
////                print("Timer fired!")
////
////            }
//////                spinnerRefresh.startAnimating()
////        }
//    }
    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        let bounds = scrollView.bounds
//        let size = scrollView.contentSize
//        let inset = scrollView.contentInset
//
//        let y = offset.y + bounds.size.height - inset.bottom
//        let h = size.height
//
//        let reloadDistance = CGFloat(60.0)
//        if y > h + reloadDistance {
//            print("scrollViewDidEndDecelerating")
//        }
//    }
    
    var savedLastIndex = 0
    
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

            let reloadDistance = CGFloat(120.0)

            if maxY > contentSizeHeight + reloadDistance, !isDataSourceLoading {
                spinnerRefresh.startAnimating()
                
                self.spinnerRefresh.frame = CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60.0)

                self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.spinnerRefresh.frame.height, right: 0.0)

                savedLastIndex = self.postsArray.count - 1


                self.loadPosts()
                self.isDataSourceLoading = true
            }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        threadActions.isHidden = true

    }
    
    // MARK: - Instance Methods
    func setUpPopGesture() {
        let popGestureRecognizer = navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            view.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.delegate = self
        }
    }
    
    func setupTableView() {
        self.refreshControl = UIRefreshControl()
        tableView.prefetchDataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.allowsSelection = false
        // remove bottom separator when tableView is empty
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
//        tableView.backgroundColor = Constants.Design.Color.background
        tableView.backgroundColor = Constants.Design.Color.gap
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.reloadData()
        }

    
    /*
    
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let width = self.tableView.bounds.width
////        DispatchQueue.global().async {
//            for index in self.postsArray.indices {
//                self.cellHeights[index] = PostTableViewCell.preferredHeightForThread(self.postsArray[index], andWidth: width, index: index)
//            }
////        }
//
//    }
    var imageTasks = [IndexPath: URLSessionDataTask]()
    
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


// MARK: - Network

extension ThreadTableViewController {
    
    
    func loadPosts() {
        guard let boardId = boardId, let threadId = threadId else {
            return
        }
        NetworkService.shared.getPostsFrom(boardId: boardId, threadId: threadId) { [weak self] (wrapper: PostsWrapper?) in

//        NetworkService.shared.getPostsFrom(boardId: boardId, threadId: threadId) { [weak self] (posts: [Post]?) in
            
            guard let self = self, let wrapper = wrapper else {
                return
            }

//            guard let self = self, let posts = posts else {
//                return
//            }
            
            self.postsArray = wrapper.posts
            
            let width = self.tableView.bounds.width
            DispatchQueue.global().async {
                self.setupReplies()
                for index in self.postsArray.indices {
                }
                
                DispatchQueue.main.async {
                    if self.spinnerRefresh.isAnimating {
                        self.spinnerRefresh.stopAnimating()
                        
                        self.tableView.reloadData()
                        UIView.animate(withDuration: 0.3) {
                            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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
}



// MARK: - UITableViewDelegate
extension ThreadTableViewController {
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
//        cellHeights[indexPath] = cell.frame.size.height
        var post = postsArray[indexPath.row]

        if post.images.count > 0 || imageTasks[indexPath] != nil {
            return
        }
//
        let cell = cell as! PostTableViewCell
//        cell.index = indexPath.row
//        cell.configure(post)
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostTableViewCell
        
        let post = postsArray[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.configure(post)
        
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ThreadTableViewController {
    
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

extension ThreadTableViewController: UITableViewDataSourcePrefetching {
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
                                data = self.fixHeader(in: data)
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

extension ThreadTableViewController {
    func fixHeader(in data: Data) -> Data {
        let checkValue: UInt8 = data.withUnsafeBytes { p in
            var result = p[5]
            return result
        }
//        let checkValue: UInt8 = data.withUnsafeBytes {
//            print($0[5])
//            return $0[5]
//            return ($0 + 5).pointee
//            var result = $0.baseAddress! + 5
//            return $0.baseAddress!.advanced(by: 5)
            
//        }
        
//        print(checkValue)

        if checkValue != 14 {
            return data
        }
        
        var data = data
        data.removeSubrange(2..<18)
        
        return data
    }
}
