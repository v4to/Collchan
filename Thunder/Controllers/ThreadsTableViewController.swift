//
//  ThreadsTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 21.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadsTableViewController: UITableViewController, UIGestureRecognizerDelegate, UITableViewDataSourcePrefetching {
   
    // MARK: - Instance Properties
    
    var page = 0
    var tasks = [IndexPath: URLSessionDataTask]()
    var cellHeights = [Int: CGFloat]()
    var isAllowedToLoadMore = true
    private var threadsService = ThreadsService()
    private var imageRequests = [ImageRequest]()
    private var images = [UIImage?]()
    var boardId = ""
    private let cellId = "cellId"
    private var sectionsArray = [Thread]()
    lazy var spinner: UIActivityIndicatorView = {
        let ativityIndicator = UIActivityIndicatorView()
        ativityIndicator.center = navigationController!.view.center
        return ativityIndicator
    }()
    var isLoadingThreads = false
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "/" + boardId
        navigationController?.view.addSubview(spinner)
        navigationController?.navigationBar.isTranslucent = false
        
        setupTableView()
        setUpPopGesture()
        spinner.startAnimating()
        loadThreads()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Instance Methods
    
    func setupTableView() {
        tableView.register(ThreadCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 0.0
//        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.prefetchDataSource = self
        
        // remove bottom separator when tableView is empty
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = UIView(frame: CGRect.zero)

//        tableView.showsVerticalScrollIndicator = false

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
    
    func generateIndexPathsToInsert(newItemsCount: Int) -> [IndexPath] {
        var result = [IndexPath]()
        let startIndex = sectionsArray.count - newItemsCount
        
        for i in startIndex..<sectionsArray.count {
            result.append(IndexPath(row: i, section: 0))
        }
        
        return result
    }

    // MARK: - UIGestureRecognizerDelegate
    
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

// MARK: - UITableViewDataSource

extension ThreadsTableViewController {
     override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return sectionsArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            print(indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
            
            
            
            let thread = sectionsArray[indexPath.row]
            cell.index = indexPath.row
            cell.configure(thread)
            return cell
        }
}


// MARK: - Network

extension ThreadsTableViewController {
        func loadThreads() {
            isLoadingThreads = true
            
            guard isAllowedToLoadMore else {
                return
            }
            
            threadsService.getThreads(fromBoard: boardId, onPage: page) { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoadingThreads = false
                
                if self.page == 0 {
                    self.spinner.stopAnimating()
                }
                
                let width = self.tableView.bounds.width
                DispatchQueue.global(qos: .userInteractive).async {
                    guard let result = result else {
                        return
                    }
                    
                    if result.isCurrentPageTheLast {
                        self.isAllowedToLoadMore = false
                    }
                    
                    self.sectionsArray += result.threads
                    
                    for i in self.sectionsArray.indices {
                        // very long text makes tableView flicker
                        let comment = String(self.sectionsArray[i].posts[0].comment.prefix(160))
                        self.sectionsArray[i].posts[0].comment = comment
                       
    //                    let thread = self.sectionsArray[i]
    //                    let height = ThreadCell.preferredHeightForThread(thread, andWidth: width)
    //                    self.cellHeights[i] = height
                    }
                    
                    for i in (self.sectionsArray.count - result.threads.count)..<self.sectionsArray.count {
                        let thread = self.sectionsArray[i]
                        let height = ThreadCell.preferredHeightForThread(thread, andWidth: width, index: i)
                        self.cellHeights[i] = height
                    }
                    
                    let indexPathsToInsert = self.generateIndexPathsToInsert(newItemsCount: result.threads.count)
                    DispatchQueue.main.async {
                        if self.page == 0 {
                            self.tableView.reloadData()
                        } else {
//                            UIView.performWithoutAnimation {
//                                self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
//                            }
                            self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
                        }
                        
                        self.page += 1
                    }
                }
            }
        }

}

// MARK: - UITableViewDelegate

extension ThreadsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]!
    }
    
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeights[indexPath.row] ?? 180.0
//    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dataTask = tasks[indexPath] {
            dataTask.cancel()
        
            tasks.removeValue(forKey: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cellHeights[indexPath.row] = cell.frame.height
        if indexPath.row == self.sectionsArray.count - 4 {
            if !isLoadingThreads {
                loadThreads()
            }
        }
        var thread = sectionsArray[indexPath.row]
        
        // already have image or task to loading image in progress
        if thread.image != nil || tasks[indexPath] != nil {
            return
        }
        
        // need to fetch on images on first load
        if let thumbnailURL = thread.thumbnailURL {
            let url = URL(string: BaseUrls.dvach + thumbnailURL)!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                   print(error)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    thread.image = image
                    self.sectionsArray[indexPath.row] = thread
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
           
            }
            task.resume()
            tasks[indexPath] = task
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ThreadsTableViewController {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            var thread = sectionsArray[indexPath.row]
            
            if thread.image != nil || tasks[indexPath] != nil {
                continue
            }
        
            if let thumbnailURL = thread.thumbnailURL {
                let url = URL(string: BaseUrls.dvach + thumbnailURL)!
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    if let data = data {
                        let image = UIImage(data: data)
                        thread.image = image
                        self?.sectionsArray[indexPath.row] = thread
                    }
                
                }
                task.resume()
                tasks[indexPath] = task
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let task = tasks[indexPath] {
                task.cancel()
                tasks.removeValue(forKey: indexPath)
            }
        }
    }
}
