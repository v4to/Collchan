//
//  ThreadsTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 21.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class ThreadsTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    // MARK: - Instance Properties
    
    var page = 0
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
        tableView.estimatedRowHeight = 200.0
        
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
        
    func loadThumbnails() {
        var counter = self.sectionsArray.count
        for i in self.sectionsArray.indices {
            let path = self.sectionsArray[i].thumbnailURL
            let url = URL(string: BaseUrls.dvach + path)!
            let imageRequest = ImageRequest(url: url)
            
            self.imageRequests.append(imageRequest)
            
            imageRequest.load { (image: UIImage?) in
                counter -= 1
                self.sectionsArray[i].image = image
                
                if counter == 0 {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()

               }
            }
        }
    }
    
    
    func loadThreads() {
        guard isAllowedToLoadMore else {
            return
        }
        
        threadsService.getThreads(fromBoard: boardId, onPage: page) { result in
            self.spinner.stopAnimating()
            
            guard let result = result else {
                return
            }
            
            if self.page == 0 {
                self.spinner.stopAnimating()
            }
            
            if result.isCurrentPageTheLast {
                self.isAllowedToLoadMore = false
            }
            
            self.page += 1
            self.sectionsArray += result.threads
            self.loadThumbnails()
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
        if indexPath.row == self.sectionsArray.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
            loadThreads()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
        cell.threadThumbnail.image = sectionsArray[indexPath.row].image
        cell.heading.text = sectionsArray[indexPath.row].posts[0].subject
        cell.postnumber.text = "#" + sectionsArray[indexPath.row].threadId
        cell.detailText.text = sectionsArray[indexPath.row].posts[0].comment
        cell.filesCount.text = String(sectionsArray[indexPath.row].filesCount)
        cell.postsCount.text = String(sectionsArray[indexPath.row].postsCount)
        cell.date.text =  sectionsArray[indexPath.row].posts[0].dateString
        return cell
    }
}
