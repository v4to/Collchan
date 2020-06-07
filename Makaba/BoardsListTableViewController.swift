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
    
    lazy var inputContainerView: UIView = {
        let view = UIView()
        view.frame = CGRect(
            x: 0,
            y: self.navigationController!.view.bounds.maxY,
            width: self.view.frame.width,
            height: 60
        )
        view.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        view.layer.cornerRadius = 10.0
        
        let textField = UITextField()
        textField.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 40)
        textField.placeholder = "Board"
        textField.layer.borderColor = #colorLiteral(red: 0.1921322048, green: 0.2078579366, blue: 0.2431031168, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.clearButtonMode = .always
        
        // Add left padding inside UITextView
        textField.leftView = UIView()
        textField.leftView?.frame = CGRect(x: 0, y: 0, width: 15.0, height: 40)
        textField.leftViewMode = .always
        
        view.addSubview(textField)
        return view
    }()
    
    // MARK: - Intialization
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        UITabBar.appearance().tintColor = .systemOrange
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupKeyBoardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        BoardsService().getBoards(
            onSuccess: { (boards) in
                self.boards = boards.dictionary
                
                self.tableView.reloadData()
            },
            onFailure: { (error) in
                print(error.localizedDescription)
            }
        )
    }
    
    // MARK: - Gestures
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print(sender)
        if let textField = inputContainerView.subviews[0] as? UITextField {
            textField.resignFirstResponder()
            
            inputContainerView.frame.origin.y = self.navigationController!.view.bounds.maxY
            inputContainerView.removeFromSuperview()
        }
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
            var frame = inputContainerView.frame
            frame.origin.y = keyboardFrame.origin.y - frame.height - 10
            inputContainerView.frame = frame
        }
    }
    
    // MARK: - Actions
    @objc func actionAdd(_ sender: UIBarButtonItem) {        
        navigationController?.view.addSubview(inputContainerView)

        if let textField = inputContainerView.subviews.first as? UITextField {
            textField.becomeFirstResponder()
        }
    }
    
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard boards != nil else { return 0 }
        return boards.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard boards != nil else { return 0 }

        let arrayOfKeys = Array(boards.keys)
        return boards[arrayOfKeys[section]]!.count
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        guard boards != nil else { return nil }

        let arrayOfKeys = Array(boards.keys)
        return arrayOfKeys[section]
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
            let arrayOfKeys = Array(boards.keys)
            let categoryName = arrayOfKeys[section]
            let boardName = boards[categoryName]![row].name
            let boardID = boards[categoryName]![row].id
            
            cell!.accessoryType = .none
            cell!.textLabel?.textColor = .systemOrange
            cell!.textLabel?.text = boardID
            cell!.textLabel?.font = UIFont.systemFont(
                ofSize: cell!.textLabel!.font.pointSize,
                weight: UIFont.Weight.bold
            )
            cell!.detailTextLabel?.text = boardName
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
