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
    var cellHeights = [IndexPath: CGFloat]()
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
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
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
        tableView.estimatedRowHeight = 172.0
//        tableView.rowHeight = 180.0
        tableView.prefetchDataSource = self
        // remove bottom separator when tableView is empty
        tableView.tableFooterView = UIView(frame: CGRect.zero)

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
    
    // TODO: - Refocator?
    /*
    func loadThumbnails() {
       
        for i in sectionsArray.indices {
            if let path = self.sectionsArray[i].thumbnailURL {
                let url = URL(string: BaseUrls.dvach + path)!
                let imageRequest = ImageRequest(url: url)
                
                self.imageRequests.append(imageRequest)
                
                imageRequest.load { (image: UIImage?) in
                    self.sectionsArray[i].image = image
                    self.tableView.reloadData()

                   }
            } else {
                self.sectionsArray[i].image = UIImage(named: "placeholder")
            }
        }
    }*/
    
    func generateIndexPathsToInsert(newItemsCount: Int) -> [IndexPath] {
        var result = [IndexPath]()
        let startIndex = sectionsArray.count - newItemsCount
        
        for i in startIndex..<sectionsArray.count {
            result.append(IndexPath(row: i, section: 0))
        }
        
        return result
    }
    
    func loadThreads() {
        guard isAllowedToLoadMore else {
            return
        }
        
        threadsService.getThreads(fromBoard: boardId, page: page) { result in

//        threadsService.getThreads(fromBoard: boardId) { result in
            
            guard let result = result else {
                return
            }
            
            
            if self.page == 0 {
                self.spinner.stopAnimating()
            }
            
            if result.isCurrentPageTheLast {
                self.isAllowedToLoadMore = false
            }
            
            self.sectionsArray += result.threads

            if self.page == 0 {
                self.tableView.reloadData()
            } else {
                self.tableView.insertRows(at: self.generateIndexPathsToInsert(newItemsCount: result.threads.count) , with: .fade)
            }
            self.page += 1
        }
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
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
//        print(indexPath)
        if indexPath.row == self.sectionsArray.count - 1 {
            loadThreads()
        }
        /*
        cell.threadThumbnail.image = sectionsArray[indexPath.row].image ?? UIImage(named: "placeholder")
        cell.heading.text = sectionsArray[indexPath.row].heading
        cell.postnumber.text = "#" + sectionsArray[indexPath.row].threadId
        cell.detailText.text = sectionsArray[indexPath.row].comment
        cell.filesCount.text = String(sectionsArray[indexPath.row].filesCount)
        cell.postsCount.text = String(sectionsArray[indexPath.row].postsCount)
        cell.date.text =  sectionsArray[indexPath.row].dateString
        */
//        print(sectionsArray[indexPath.row].image)
        
//        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//            cell.threadThumbnail.image = sectionsArray[indexPath.row].image ?? UIImage(named: "placeholder")
//        }
//        cell.threadThumbnail.image = UIImage(named: "placeholder")

        cell.heading.text = sectionsArray[indexPath.row].posts[0].subject
        cell.detailText.text = sectionsArray[indexPath.row].posts[0].comment
        cell.filesCount.text = String(sectionsArray[indexPath.row].filesCount)
        cell.postsCount.text = String(sectionsArray[indexPath.row].postsCount)
        cell.date.text =  sectionsArray[indexPath.row].posts[0].dateString
        return cell
    }
    

   
//     caching height to prevent scroll jump
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 172.0
    }
    
    
    func collectionView(_ tableView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
      print(indexPaths)
    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = tasks[indexPath] {
                continue
            }
            
            var thread = sectionsArray[indexPath.row]
            if let path = thread.thumbnailURL {
            
                let url = URL(string: BaseUrls.dvach + path)!
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   if let error = error {
                       print(error)
                   }
                   if let data = data {
                       let image = UIImage(data: data)
                       thread.image = image
                       self.sectionsArray[indexPath.row] = thread
                   }
                   
               }
               task.resume()
               tasks[indexPath] = task
            }
        }
    }
       
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dataTask = tasks[indexPath] {
            dataTask.cancel()
            print("removed")
            tasks.removeValue(forKey: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        guard let cell = cell as? ThreadCell else {
            return
        }
        var thread = sectionsArray[indexPath.row]
        if let image = thread.image {
            cell.threadThumbnail.image = image
            return
        }
        if let path = thread.thumbnailURL {
            if tasks[indexPath] != nil {
                if let image = thread.image {
                    cell.threadThumbnail.image = image
                    tasks.removeValue(forKey: indexPath)
                }
            } else {
                let url = URL(string: BaseUrls.dvach + path)!
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print(error)
                    }
                    if let data = data {
                        let image = UIImage(data: data)
                        thread.image = image
                        self.sectionsArray[indexPath.row] = thread
                        DispatchQueue.main.async {
                            
                            cell.threadThumbnail.image = image
                        }
                    }
                    
                }
                task.resume()
                tasks[indexPath] = task
            }
        }
    }
}
