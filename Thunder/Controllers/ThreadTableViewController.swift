//
//  ThreadTableViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 02.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class PostCell: BoardsListTableViewCell {
    // MARK: - Instance Propeties
    
    override var actionViewBackgroundColor: UIColor {
        return #colorLiteral(red: 0, green: 0.5098509789, blue: 0.9645856023, alpha: 1)
    }
    lazy var postId = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .headline).withSize(12.0))
    lazy var date = createHeaderLabelWithFont(UIFont.preferredFont(forTextStyle: .footnote).withSize(12.0))
    
    let comment: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body).withSize(14.0)
        label.textColor = #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
        return label
    }()
    
    func createHeaderLabelWithFont(_ font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = #colorLiteral(red: 0.5960256457, green: 0.5921916366, blue: 0.6116896868, alpha: 1)
        return label
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSwipeIcon()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    func setupViews() {
        contentView.addSubview(postId)
        contentView.addSubview(date)
        contentView.addSubview(comment)
        
        let padding: CGFloat = 15.0
        let margin: CGFloat = 10.0
        
        postId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        postId.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        
        date.centerYAnchor.constraint(equalTo: postId.centerYAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
        
        comment.topAnchor.constraint(equalTo: postId.bottomAnchor, constant: margin).isActive = true
        comment.leftAnchor.constraint(equalTo: postId.leftAnchor).isActive = true
        comment.rightAnchor.constraint(equalTo: date.rightAnchor).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

    }
    
    func configure(_ post: Post) {
        postId.text = "#" + post.postId
        date.text = post.dateString
        comment.text = post.comment
    }
    
    
    func setupSwipeIcon() {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "arrowshape.turn.up.left.circle", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        starImage.image = image
    }
}


class ThreadTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    // MARK: - Instance Methods
    
    var boardId: String?
    var threadId: String?
    var postsArray = [Post]()
    var cellId = "postCell"
    
    // MARK: - Initialization
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupTableView()
        setUpPopGesture()
        loadPosts()
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
            tableView.register(PostCell.self, forCellReuseIdentifier: cellId)

            // remove bottom separator when tableView is empty
            tableView.tableFooterView = UIView(frame: CGRect.zero)
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

}


// MARK: - Network

extension ThreadTableViewController {
    func loadPosts() {
        guard let boardId = boardId, let threadId = threadId else {
            return
        }
           
        NetworkService.shared.getPostsFrom(boardId: boardId, threadId: threadId) { [weak self] (posts: [Post]?) in
            guard let self = self, let posts = posts else {
                return
            }
            
            self.postsArray = posts
            self.tableView.reloadData()
//            print(posts.count)
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        
        let post = postsArray[indexPath.row]
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
