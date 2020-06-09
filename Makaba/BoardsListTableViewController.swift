//
//  BoardsTableViewController.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 22.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import CoreHaptics
import AudioToolbox

class BoardsListTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var boards: [String: [Board]]!
    var categories: [String]!
    
    lazy var addBoardView: AddBoardView = {
       let view = AddBoardView()
        view.frame = self.navigationController!.view.bounds
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    
    
    // MARK: - Intialization
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        tabBarItem.title = "Boards"
        tabBarItem.image = UIImage(named: "boards-tab-image")
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Boards"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(actionAdd(_:))
        )
        navigationItem.rightBarButtonItem = addButton
                
        setupKeyBoardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        BoardsService().getBoards(
            onSuccess: { (boards) in
                self.boards = boards.dictionary
                self.categories = Array(boards.dictionary.keys).sorted { $0 < $1 }
                self.tableView.reloadData()
            },
            onFailure: { (error) in
                print(error.localizedDescription)
            }
        )
    }
    
    
    
    // MARK: - Instance Methods
 

    
    
    // MARK: - Gestures
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
            case .ended:
                addBoardView.addBoardTextFieldView.resignFirstResponder()
                addBoardView.frame = self.navigationController!.view.bounds
                addBoardView.addBoardTextFieldView.text = ""
                addBoardView.removeFromSuperview()
            default:
                break
            }
    }

    
    
    // MARK: - Actions
    @objc func actionAdd(_ sender: UIBarButtonItem) {
        navigationController?.view.addSubview(addBoardView)
        addBoardView.addBoardTextFieldView.becomeFirstResponder()
    }
    
    
    
    // MARK: - Keyboard Observers
    func setupKeyBoardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    
    
    
    // MARK: - Keyboard Notifications
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            {
                if addBoardView.frame.intersects(keyboardFrame) {
                    addBoardView.frame.origin.y = addBoardView.frame.origin.y - keyboardFrame.height
                }
    
            }
    }
    
    
    
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard boards != nil else { return 0 }
        return boards.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard boards != nil else { return 0 }

        return boards[categories[section]]!.count

    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        guard boards != nil else { return nil }

        return categories[section]
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let identifier = "board"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = BoardsListTableViewCell(
                style: .subtitle,
                reuseIdentifier: identifier
            )
            cell?.translatesAutoresizingMaskIntoConstraints = false
        }

        let section = indexPath.section
        let row = indexPath.row
        
        if boards != nil {
            let categoryName = categories[section]
            let sortedBoard = boards[categoryName]!.sorted { $0.id < $1.id }
            let boardName = sortedBoard[row].name
            let boardID = sortedBoard[row].id
            
            cell!.accessoryType = .none
            cell!.textLabel?.textColor = .systemBlue
            cell!.textLabel?.text = boardID
            cell!.textLabel?.font = UIFont.systemFont(
                ofSize: cell!.textLabel!.font.pointSize,
                weight: UIFont.Weight.bold
            )
            cell!.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16.0)
            cell!.detailTextLabel?.text = boardName
            cell!.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        }
        return cell!
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
