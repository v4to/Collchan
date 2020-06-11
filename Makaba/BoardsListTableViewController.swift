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

class BoardsListTableViewController: UITableViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    var boards: [String: [Board]]!
    
    var categories: [String]!
    
    var autoSuggestions = [Board]()
    
    var keyboardHeight: CGFloat!
    
    lazy var statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    
    lazy var addBoardView: AddBoardView = {
       let view = AddBoardView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    lazy var autoSuggestionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(
            x: 6,
            y: view.bounds.maxY,
            width: view.bounds.width - 12,
            height: 0
        )

        tableView.estimatedRowHeight = 0
        tableView.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        tableView.layer.cornerRadius = 10.0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        
        addBoardView.cancelButton.addTarget(
            self, action:
            #selector(actionCancel(_:)),
            for: .touchUpInside
        )
        
        addBoardView.addBoardTextFieldView.delegate = self
        addBoardView.addBoardTextFieldView.addTarget(
            self,
            action: #selector(actionTextFieldDidChange(_:)),
            for: .editingChanged
        )
        addBoardView.addSubview(autoSuggestionsTableView)
        addBoardView.sendSubviewToBack(autoSuggestionsTableView)
        navigationController?.view.addSubview(addBoardView)
        addBoardView.isHidden = true
        
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
    
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Reseting text color just before textfield  is asked to resign the first responder status
        let addButton = addBoardView.addButton
        addButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        addButton.isEnabled = false
        return true
    }
    
    
    // MARK: - Instance Methods
 

    
    
    // MARK: - Gestures
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
            case .ended:
                addBoardView.endEditing(true)
                addBoardView.frame = self.navigationController!.view.bounds
                addBoardView.addBoardTextFieldView.text = ""
                addBoardView.isHidden = true
                autoSuggestions = []
            default:
                break
            }
    }

    
    
    // MARK: - Actions
    @objc func actionCancel(_ sender: ActionSheetButton) {
        addBoardView.endEditing(true)
        addBoardView.frame = self.navigationController!.view.bounds
        addBoardView.addBoardTextFieldView.text = ""
        addBoardView.isHidden = true
        autoSuggestions = []
    }
    
    @objc func actionAdd(_ sender: UIBarButtonItem) {
        addBoardView.isHidden = false
        addBoardView.addBoardTextFieldView.becomeFirstResponder()
    }
    
    @objc func actionTextFieldDidChange(_ textField: UITextField) {
        let addButton = addBoardView.addButton
        if textField.text! == "" {
            addButton.isEnabled = false
            addButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        } else {
            addButton.isEnabled = true
            addButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        }
        
        autoSuggestions = []
        for boards in boards.values {
            boards.forEach {
                if
                    $0.id.hasPrefix(textField.text!.lowercased()) ||
                    $0.name.lowercased().hasPrefix(textField.text!.lowercased())
                {
                    autoSuggestions += [$0]
                    
                }
                
            }
        }

        autoSuggestionsTableView.reloadData()
        let contentSize = autoSuggestionsTableView.contentSize
        
        let textField = addBoardView.textFieldContainerView
        
        let offsetForTableAutosuggestionOrigin =
            addBoardView.bounds.minY + keyboardHeight + statusBarHeight! + 30

        let rectContentSize = CGRect(
            origin: CGPoint(x: 6, y: addBoardView.bounds.midY),
            size: contentSize
        )
        
        // Check if contentSize of autoSuggestionTable overlaps textFieldContainerView
        // Is yes  autoSuggestionTable
        if textField.frame.intersects(rectContentSize) {
            autoSuggestionsTableView.frame.size.height =
                textField.frame.minY - offsetForTableAutosuggestionOrigin - 10
        } else {
            autoSuggestionsTableView.sizeToFit()
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
                self.keyboardHeight = keyboardFrame.height
                if addBoardView.frame.intersects(keyboardFrame) {
                    addBoardView.frame.origin.y = addBoardView.frame.origin.y - keyboardFrame.height

                    let offsetForTableAutosuggestionOrigin =
                        addBoardView.bounds.minY + keyboardHeight + statusBarHeight! + 30

                    
                    autoSuggestionsTableView.frame.origin.y = offsetForTableAutosuggestionOrigin
                    autoSuggestionsTableView.frame.size.height =
                        addBoardView.textFieldContainerView.frame.minY -
                        offsetForTableAutosuggestionOrigin - 10

                    autoSuggestionsTableView.reloadData()
                }
    
            }
    }
    
    
    
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.tableView {
            guard boards != nil else { return 0 }
            return boards.count
        }
        
        if tableView === autoSuggestionsTableView {
            return 1
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            guard boards != nil else { return 0 }
            
            return boards[categories[section]]!.count
        }
        
        if tableView === autoSuggestionsTableView {
            guard boards != nil else { return 0 }
            
            // if no suggestion found and textfield is empty show placeholder list
            if autoSuggestions.count == 0 && addBoardView.addBoardTextFieldView.text!.count == 0 {
                return boards[categories[section]]!.count
            }
            
            return autoSuggestions.count
        }
        
        return 0
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        if tableView === self.tableView {
            guard boards != nil else { return nil }

            return categories[section]
        }
            
        if tableView === autoSuggestionsTableView {
            return nil
        }
        
        return nil
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let identifier = "board"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if tableView === self.tableView {
                cell = BoardsListTableViewCell(
                    style: .subtitle,
                    reuseIdentifier: identifier
                )
            }
            if tableView === autoSuggestionsTableView {
                cell = UITableViewCell(
                    style: .default,
                   reuseIdentifier: identifier
                )
            }
            
            cell?.translatesAutoresizingMaskIntoConstraints = false
        }
        let section = indexPath.section
        let row = indexPath.row
        
        if tableView === self.tableView {
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
            
        }
        
        if tableView === autoSuggestionsTableView {
            cell!.separatorInset = UIEdgeInsets.zero
            cell!.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
            cell!.accessoryType = .none
            
            if autoSuggestions.count == 0 {
                let categoryName = categories[section]
                let sortedBoard = boards[categoryName]!.sorted { $0.id < $1.id }
                cell!.textLabel?.text = sortedBoard[row].name
            } else {
                cell!.textLabel?.text = autoSuggestions[row].name

            }

            cell!.textLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(15)
            
            if indexPath.row == autoSuggestions.count - 1 {
                cell!.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: UIScreen.main.bounds.width

                )
            }
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
