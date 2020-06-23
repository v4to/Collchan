//
//  ThreadsTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 21.06.2020.
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
        backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        
        
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



class ThreadsTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    // MARK: - Instance Properties
    private var threadsService = ThreadsService()
    
    private var imageRequests = [ImageRequest]()
    
    private var images = [UIImage?]()
    
    var threadId = ""
    
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
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "/" + threadId
        
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
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 200.0
    }
    
    func setUpPopGesture() {
        let popGestureRecognizer = navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")

            self.view.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.delegate = self
        }
    }
    
    var page = 0
    
    func loadThreads() {
//        print(threadId)
        
        
        threadsService.getThreads(
            from: threadId,
            completion: { result in
                
                
                print("Last Page Index - ", result?.lastPageIndex)
                print("Current Page Index - ", result?.currentPage)
                
                
                self.sectionsArray += result!.threads
                self.tableView.reloadData()
//                print("Sections Array count = ", self.sectionsArray.count)
                
                for section in self.sectionsArray {
                    let path = section.posts[0].files[0].thumbnail
                    let url = URL(string: BaseUrls.dvach + path)!
                    let imageRequest = ImageRequest(url: url)
                    self.imageRequests.append(imageRequest)
                }
                
                self.spinner.stopAnimating()
//                self.tableView.reloadData()
                
//                for i in self.sectionsArray.indices {
//                    self.tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
//                }
//                self.tableView.reloadSections([0], with: .automatic)
//                self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                var counter = self.sectionsArray.count
                for i in self.imageRequests.indices {

                    self.imageRequests[i].load { (image) in
                        counter -= 1

                        self.images.append(image)
//                        self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                        if counter == 0 {
                            self.spinner.stopAnimating()

                            self.tableView.backgroundColor = #colorLiteral(red: 0.04705037922, green: 0.0470642224, blue: 0.04704734683, alpha: 1)
                            
                            print("reload")
                            print("Sections Array count = ", self.sectionsArray.count)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
//                            self.isLoadingNew = false
//                            self.tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
//                            self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                        }
                    }
                }
            }
        )
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
        // #warning Incomplete implementation, return the number of rows
        return sectionsArray.count
    }
    
    var newLoadIndexPath = 10
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
//        print(indexPath.item)
        // Configure the cell...
        if images.count > 0 {
            cell.threadThumbnail.image = images[indexPath.row]
        }
        
        cell.heading.text = sectionsArray[indexPath.row].posts[0].subject
        cell.postnumber.text = "#" + sectionsArray[indexPath.row].threadNum
        cell.detailText.text = sectionsArray[indexPath.row].posts[0].comment
        cell.filesCount.text = String(sectionsArray[indexPath.row].filesCount)
        cell.postsCount.text = String(sectionsArray[indexPath.row].postsCount)
        cell.date.text =  sectionsArray[indexPath.row].posts[0].dateString
        
        return cell
    }
    

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

}
