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
//        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Heading with awesome text fdsfds fsdfdskfjas fa dfdsjf safsdf"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20.0)
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
        label.text = "A table view tracks the height of rows separately from the cells that represent them. UITableView provides default sizes for rows, but you can override the default height by assigning"
//         label.text = "A table view tracks the height"
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        return label
    }()
    
    let postnumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#1647485"
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(13.0)
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
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
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(13.0)
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
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(13.0)
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
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(13.0)
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
        var image = UIImage(systemName: "heart.fill", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
    
    
    func setupViews() {
        backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        
        
        contentView.addSubview(heading)
        heading.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        heading.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        heading.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        
        
        contentView.addSubview(threadThumbnail)
        threadThumbnail.widthAnchor.constraint(equalToConstant: 83.0).isActive = true
        threadThumbnail.heightAnchor.constraint(equalToConstant: 83.0).isActive = true
        threadThumbnail.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10.0).isActive = true
        threadThumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        threadThumbnail.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15.0).isActive = true
        
        contentView.addSubview(detail)
        detail.topAnchor.constraint(equalTo: threadThumbnail.topAnchor).isActive = true
        detail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
        detail.leftAnchor.constraint(equalTo: threadThumbnail.rightAnchor, constant: 20.0).isActive = true
        detail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        
        detail.addSubview(detailText)
        detailText.topAnchor.constraint(equalTo: detail.topAnchor).isActive = true
        detailText.leftAnchor.constraint(equalTo: detail.leftAnchor).isActive = true
        detailText.rightAnchor.constraint(equalTo: detail.rightAnchor).isActive = true

        detail.addSubview(postnumber)
        postnumber.topAnchor.constraint(equalTo: detailText.bottomAnchor, constant: 10.0).isActive = true
        postnumber.leftAnchor.constraint(equalTo: detailText.leftAnchor).isActive = true

        detail.addSubview(fileImage)
        fileImage.centerYAnchor.constraint(equalTo: postnumber.centerYAnchor).isActive = true
        fileImage.leftAnchor.constraint(equalTo: postnumber.rightAnchor, constant: 10.0).isActive = true

        detail.addSubview(filesCount)
        filesCount.centerYAnchor.constraint(equalTo: postnumber.centerYAnchor).isActive = true
        filesCount.leftAnchor.constraint(equalTo: fileImage.rightAnchor, constant: 3.0).isActive = true

        detail.addSubview(commentImage)
        commentImage.centerYAnchor.constraint(equalTo: postnumber.centerYAnchor).isActive = true
        commentImage.leftAnchor.constraint(equalTo: filesCount.rightAnchor, constant: 10.0).isActive = true

        detail.addSubview(postsCount)
        postsCount.centerYAnchor.constraint(equalTo: postnumber.centerYAnchor).isActive = true
        postsCount.leftAnchor.constraint(equalTo: commentImage.rightAnchor, constant: 3.0).isActive = true

        detail.addSubview(clockImage)
        clockImage.topAnchor.constraint(equalTo: postnumber.bottomAnchor, constant: 10.0).isActive = true
        clockImage.leftAnchor.constraint(equalTo: detail.leftAnchor).isActive = true

        detail.addSubview(date)
        date.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
        date.leftAnchor.constraint(equalTo: clockImage.rightAnchor, constant: 3.0).isActive = true
        date.bottomAnchor.constraint(equalTo: detail.bottomAnchor).isActive = true
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
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        
        
        tableView.register(ThreadCell.self, forCellReuseIdentifier: cellId)
        
        navigationController?.view.addSubview(spinner)
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(threadId)
        threadsService.getThreads(
            from: threadId,
            completion: { result in
                
                self.sectionsArray = result!.threads
                
                print(self.sectionsArray)
                for section in self.sectionsArray {
                    let path = section.posts[0].files[0].thumbnail
                    let url = URL(string: BaseUrls.dvach + path)!
                    let imageRequest = ImageRequest(url: url)
                    self.imageRequests.append(imageRequest)
                }
                
                var counter = self.sectionsArray.count
                for imageRequest in self.imageRequests {
                    
                    imageRequest.load { (image) in
                        counter -= 1
                        
                        self.images.append(image)
                        
                        if counter == 0 {
                            self.spinner.stopAnimating()

                            self.tableView.backgroundColor = #colorLiteral(red: 0.04705037922, green: 0.0470642224, blue: 0.04704734683, alpha: 1)
                            
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        )
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return sectionsArray.isEmpty ?
//        return sectionsArray.count
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionsArray.count
//        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThreadCell
        
        // Configure the cell...
        if images.count > 0 {
            cell.threadThumbnail.image = images[indexPath.row]
        }
        
        cell.filesCount.text = String(sectionsArray[indexPath.row].filesCount)
        cell.postsCount.text = String(sectionsArray[indexPath.row].postsCount)
        
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
