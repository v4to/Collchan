//
//  BoardsTableViewController.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 22.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import CoreData

class BoardsListTableViewController: UITableViewController, UISearchResultsUpdating, SwipeableCellDelegate, UISearchControllerDelegate, UIGestureRecognizerDelegate {
    // MARK: - SwipeableCellDelegate
    func cellDidSwipe(cell: BoardsListTableViewCell) {
//        let indexPath = self.tableView.indexPath(for: cell)!
//        let chosenBoard = sectionsArray[indexPath.section].boards[indexPath.row]
//        if favoriteCategory.boards.count == 0 {
//            favoriteCategory.boards.append(chosenBoard)
//
//            sectionsArray = generateSectionsFromArray(boardsCategories)
//
//            if !isSearchFieldPresented { tableView.insertSections(IndexSet(integer: 0), with: .none) }
//        } else {
//            if !favoriteCategory.boards.contains(chosenBoard) {
//                favoriteCategory.boards.append(chosenBoard)
//
//                sectionsArray = generateSectionsFromArray(self.boardsCategories)
//
//                if !isSearchFieldPresented {
//                    let newIndexPath = IndexPath(row: sectionsArray[0].boards.count - 1, section: 0)
//                    tableView.insertRows(at: [newIndexPath], with: .none)
//                }
//            }
//        }
    }
    
    // MARK: - Core Data
    var container: NSPersistentContainer!

    // MARK: - Instance Properties
    var actionButtonsContainerBottomAnchorConstraint: NSLayoutConstraint?
    
    lazy var overlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.9)
        view.alpha = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlayGesture(_:)))
        tapGesture.delegate = self
        
        view.addGestureRecognizer(tapGesture)
    
        return view
    }()
    
    
    lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    
    
    lazy var textFieldBoardId: UITextField = {
        let textField = createTextField(placeHolder: "Board Id")
        textField.addTarget(self, action: #selector(actionTextFieldIdDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var textFieldName: UITextField = { return createTextField(placeHolder: "Name") }()
    
    let actionSheetButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.backgroundColor = #colorLiteral(red: 0.07841930538, green: 0.0823603943, blue: 0.09017961472, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    
    let addToFavoritesButton: ActionSheetButton = {
        let button = ActionSheetButton(frame: CGRect.zero, title: "Favorite", textColor: #colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1))
        button.addBorder(side: .bottom, color: #colorLiteral(red: 0.172529161, green: 0.1764830351, blue: 0.184286654, alpha: 1), width: 1.0)
        return button
    }()
    
    let cancelButton = ActionSheetButton(frame: CGRect.zero, title: "Cancel", textColor: #colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1))

    var isSearchFieldPresented = false
    
    var favoriteCategory = BoardCategory(name: "Favorites", boards: [])
        
    var boardsCategories = [BoardCategory]()
    
    var sectionsArray = [BoardCategory]()
    
    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        // dont block tableview from scrolling while searching
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Board"
        search.delegate = self
        return search
    }()

    lazy var spinner: UIActivityIndicatorView = {
        let ativityIndicator = UIActivityIndicatorView()
        ativityIndicator.center = navigationController!.view.center
        return ativityIndicator
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
    
    // MARK: - Instance Methods
    func setTextFieldName(_ name: String) {
        textFieldName.text = name
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func createTextField(placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeHolder
        textField.layer.borderColor = #colorLiteral(red: 0.1921322048, green: 0.2078579366, blue: 0.2431031168, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.clearButtonMode = .always
        
        textField.leftView = UIView()
        textField.leftView?.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        return textField
    }
    
    func findFirstBoardWithMatchedId(_ id: String) -> String? {
        for category in boardsCategories {
            for board in category.boards {
                if board.id.hasPrefix(id) {
                    return board.name
                }
            }
        }
        
        return nil
    }
    
    func generateSectionsFromArray(
        _ array: [BoardCategory],
        withFilter filterString: String = ""
    ) -> [BoardCategory] {
        var sectionsArray = array
        
        // dont filter if no string or string is empty
        guard filterString.count > 0 else {
            if favoriteCategory.boards.count > 0 { sectionsArray.insert(favoriteCategory, at: 0) }
            return sectionsArray
        }

        
        for i in sectionsArray.indices {
            sectionsArray[i].boards = sectionsArray[i].boards.filter {
                return
                    $0.id.range(of: filterString, options: .caseInsensitive) != nil ||
                    $0.name.range(of: filterString, options: .caseInsensitive) != nil
            }
        }
        
        sectionsArray = sectionsArray.filter { $0.boards.count > 0 }
        
        return sectionsArray
    }
    
    func setupViews() {
        actionSheetButtonsContainer.addSubview(addToFavoritesButton)
        actionSheetButtonsContainer.addSubview(cancelButton)
        
        textFieldContainer.addSubview(textFieldBoardId)
        textFieldContainer.addSubview(textFieldName)
                
        overlay.addSubview(textFieldContainer)
        overlay.addSubview(actionSheetButtonsContainer)
        overlay.alpha = 0.0
        
        navigationController?.view.addSubview(overlay)
        
        overlay.widthAnchor.constraint(equalTo: navigationController!.view.widthAnchor).isActive = true
        overlay.heightAnchor.constraint(equalTo: navigationController!.view.heightAnchor).isActive = true
                
        actionSheetButtonsContainer.leadingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        actionSheetButtonsContainer.trailingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        actionButtonsContainerBottomAnchorConstraint = actionSheetButtonsContainer.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -10.0)
        actionButtonsContainerBottomAnchorConstraint!.isActive = true
        
        addToFavoritesButton.leadingAnchor.constraint(equalTo: actionSheetButtonsContainer.leadingAnchor).isActive = true
        addToFavoritesButton.trailingAnchor.constraint(equalTo: actionSheetButtonsContainer.trailingAnchor).isActive = true
        addToFavoritesButton.topAnchor.constraint(equalTo: actionSheetButtonsContainer.topAnchor).isActive = true
        addToFavoritesButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        addToFavoritesButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true

        cancelButton.leadingAnchor.constraint(equalTo: actionSheetButtonsContainer.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: actionSheetButtonsContainer.trailingAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: actionSheetButtonsContainer.bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        
        textFieldContainer.leadingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        textFieldContainer.trailingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        textFieldContainer.bottomAnchor.constraint(equalTo: actionSheetButtonsContainer.topAnchor, constant: -10.0).isActive = true
        
        textFieldBoardId.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 10).isActive = true
        textFieldBoardId.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -10).isActive = true
        textFieldBoardId.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 10).isActive = true
        textFieldBoardId.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        textFieldBoardId.leftView?.widthAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        textFieldName.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 10).isActive = true
        textFieldName.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -10).isActive = true
        textFieldName.topAnchor.constraint(equalTo: textFieldBoardId.bottomAnchor, constant: 10).isActive = true
        textFieldName.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -10).isActive = true
        textFieldName.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        textFieldName.leftView?.widthAnchor.constraint(equalToConstant: 15.0).isActive = true
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.isHidden = true
        
        navigationItem.title = "Boards"
        navigationItem.searchController = search
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(actionBoardAdd(_:))
        )
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.addSubview(spinner)
        
        spinner.startAnimating()
        
        setupViews()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        BoardsService().getBoards(
            onSuccess: { (boardsCategories) in
                self.spinner.stopAnimating()
                self.boardsCategories = boardsCategories.array
                
                print( self.navigationItem.searchController!.searchBar.text!.count)
                self.sectionsArray = self.generateSectionsFromArray(
                    self.boardsCategories,
                    withFilter: self.navigationItem.searchController!.searchBar.text!
                )
                
                self.tableView.isHidden = false
                self.tableView.reloadData()
            },
            onFailure: { (error) in
                print(error.localizedDescription)
            }
        )
    }
    
    // MARK: - Keyboard Notifications
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]! as! Double
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if textFieldBoardId.isFirstResponder {
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as! CGRect
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]! as! Double
        
            actionButtonsContainerBottomAnchorConstraint?.constant = -keyboardFrame.height - 10.0

            // to override inherited animation arguments from keybard specify .overrideInheritedDuration, .overrideInheritedCurve in animatin options
            UIView.animate(withDuration: duration, animations: {
                self.overlay.alpha = 1.0
                self.overlay.layoutIfNeeded()
            })
        }
        
    }
    
    // MARK: - Gestures
    @objc func hideOverlayGesture(_ sender: UITapGestureRecognizer) {
        textFieldBoardId.resignFirstResponder()
        textFieldBoardId.text = nil
        textFieldName.text = nil
        if textFieldBoardId.isFirstResponder { textFieldBoardId.resignFirstResponder() }
        if textFieldName.isFirstResponder { textFieldName.resignFirstResponder() }
        
        actionButtonsContainerBottomAnchorConstraint?.constant = 0.0
        
        // to override inherited animation arguments from keybard specify .overrideInheritedDuration, .overrideInheritedCurve in animatin options
        UIView.animate(withDuration: 0.3, animations: {
            self.overlay.alpha = 0.0
            self.overlay.layoutIfNeeded()
        })
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == overlay
    }
    
    
    // MARK: - Actions
    @objc func actionTextFieldIdDidChange(_ sender: UITextField) {
        if let name = findFirstBoardWithMatchedId(sender.text!) {
            setTextFieldName(name)
        }
    }
    
    @objc func actionBoardAdd(_ sender: UIBarButtonItem) {
        textFieldBoardId.becomeFirstResponder()
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let threadsCVC = ThreadsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        threadsCVC.threadId = sectionsArray[indexPath.section].boards[indexPath.row].id

        navigationController!.pushViewController(threadsCVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].boards.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "board"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if tableView === self.tableView {
                cell = BoardsListTableViewCell(
                    style: .subtitle,
                    reuseIdentifier: identifier
                )
            }
        }
        
        let section = indexPath.section
        let row = indexPath.row
      
        let boardName = sectionsArray[section].boards[row].name
        let boardId =  sectionsArray[section].boards[row].id
  
        cell!.accessoryType = .none
        cell!.textLabel?.textColor = .systemBlue
        cell!.textLabel?.text = boardId
        cell!.textLabel?.font = UIFont.systemFont(
            ofSize: cell!.textLabel!.font.pointSize,
            weight: UIFont.Weight.bold
        )
        cell!.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16.0)
        cell!.detailTextLabel?.text = boardName
        cell!.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        
        if let cell = cell as? BoardsListTableViewCell {
            cell.delegate = self
        }
        
        return cell!
    }
    
    
    
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        self.sectionsArray = self.generateSectionsFromArray(self.boardsCategories, withFilter: text)

        tableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        isSearchFieldPresented = true
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

 
