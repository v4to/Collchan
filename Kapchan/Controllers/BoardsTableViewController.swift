//
//  BoardsTableViewController.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 22.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import CoreData
import Accelerate
import WebKit
import Fuzi
let kernelLength = 51

class BoardsTableViewController: UITableViewController, SwipeableCellDelegate, UISearchControllerDelegate, UIGestureRecognizerDelegate {
   
    // MARK: - Core Data
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    // MARK: - Instance Properties

    lazy var cookiesNavigationDelegate = CookiesWKNavigationDelegate {
        let cookies = WKWebsiteDataStore.default().httpCookieStore
        cookies.getAllCookies({ print($0) })
    }

    lazy var cookiesView: WKWebView = {
        let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.navigationDelegate = cookiesNavigationDelegate
        return view
    }()

    let cellReuseIdentifier = "board"
    var actionButtonsContainerBottomAnchorConstraint: NSLayoutConstraint?
    var isSearchFieldPresented = false
    var boardsCategories = [BoardCategory]()
    var favoriteBoards = [FavoriteBoard]()
    lazy var overlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlayGesture))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Design.Color.background
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Constants.Design.Color.gap.cgColor
        return view
    }()
    lazy var textFieldBoardId: UITextField = {
        let textField = createTextField(placeHolder: "Board Id")
        textField.addTarget(self, action: #selector(actionTextFieldIdDidChange(_:)), for: .editingChanged)
        return textField
    }()
    lazy var textFieldName: UITextField = {
        let textField = createTextField(placeHolder: "Name")
        textField.addTarget(self, action: #selector(actionTextFieldNameDidChange(_:)), for: .editingChanged)
        return textField
    }()
    let actionSheetButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.backgroundColor = Constants.Design.Color.background
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Constants.Design.Color.gap.cgColor
        view.clipsToBounds = true
        return view
    }()
    lazy var addToFavoriteButton: ActionSheetButton = {
        let button = ActionSheetButton(frame: CGRect.zero, title: "Favorite", textColor: #colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1))
        button.addBorder(side: .bottom, color: Constants.Design.Color.gap, width: 1.0)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(actionAddFavoriteBoard(_:)), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: ActionSheetButton = {
        let button = ActionSheetButton(frame: CGRect.zero, title: "Cancel", textColor: Constants.Design.Color.orange)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionCancelButton(_:)), for: .touchUpInside)
        return button
    }()

    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
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
//        tabBarItem.image = UIImage(named: "boards-tab-image")
//        tabBarItem.image = UIImage(systemName: "rectangle.stack.fill")
        tabBarItem.image = Constants.Design.Image.iconBoards
//        tabBarItem.image = UIImage(systemName: "rectangle.stack")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BoardsListTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = Constants.Design.Color.teritaryBackground
        
        navigationItem.title = "Boards"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .add,
//            target: self,
//            action: #selector(actionOpenAddFavoriteModal(_:))
//        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.Design.Image.iconAdd,
            style: .plain,
            target: self,
            action: #selector(actionOpenAddFavoriteModal(_:))
        )
//        navigationController?.navigationBar.barTintColor = .red

//        navigationController?.navigationBar.backgroundColor = UIColor.red
//        navigationController?.navigationBar.barStyle = .black
        
        
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = Constants.Design.Color.background
//        appearance.backgroundColor = .red

//        appearance.backgroundEffect = UIBlurEffect(style: .dark)
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.barTintColor = Constants.Design.Color.background
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.barTintColor = UIColor.red
       
//        appearance.configureWithDefaultBackground()
//        appearance.backgroundColor = UIColor.gray
//        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterialDark)
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.standardAppearance = appearance
//        UINavigationBar.appearance().isTranslucent = true

//        appearance.backgroundColor = Constants.Design.Color.background
        

        
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
//        navigationController?.navigationBar.
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        let navBar = navigationController!.navigationBar
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = Constants.Design.Color.background
//        navBar.standardAppearance = appearance
//        appearance.backgroundColor = Constants.Design.Color.background
//        navBar.scrollEdgeAppearance = appearance

//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.view.addSubview(spinner)
        setupViews()
        subscribeToKeyboardNotifications()
        spinner.startAnimating()
        loadBoards()
        self.cookiesView.loadCookies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Instance Methods

    func addBoardToFavoritesWithId(_ id: String, and name: String) {
        if !FavoriteBoard.checkIfFavoriteBoardExists(withId: id, in: container!.viewContext) {
            let newFavoriteBoard = FavoriteBoard.createFavoriteBoard(withId: id, andName: name, in: container!.viewContext)
            try? container!.viewContext.save()
            favoriteBoards.append(newFavoriteBoard)
        }
    }
    
    func deleteFavoriteBoardWithId(_ id: String, at row: Int) {
        FavoriteBoard.removeFavoriteBoardWithId(id, in: container!.viewContext)
        try? container!.viewContext.save()
        favoriteBoards.remove(at: row)
    }
    
    
    func setTextFieldName(_ name: String) {
        textFieldName.text = name
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func createTextField(placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeHolder
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = Constants.Design.Color.teritaryBackground
        textField.clearButtonMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: textField.bounds.height))
        textField.leftViewMode = .always
        return textField
    }
    
    func findFirstBoardWithMatchedId(_ id: String) -> String? {
        var matched = [Board]()
        
        // filtering to find all boards with mached id
        for category in boardsCategories {
            matched += category.boards.filter {
                return $0.id.hasPrefix(id)
            }
            
        }
        print(matched.count)
        
        // finding id with shortest characters
        if matched.count > 0 {
            let result = matched.reduce(matched[0]) { (boardWithShortestId, next) in
                return boardWithShortestId.id > next.id ? next : boardWithShortestId
            }
            return result.name
        } else {
            textFieldName.text = ""
        }
        
        return nil
    }
    
    func setupViews() {
        self.view.addSubview(self.cookiesView)

        actionSheetButtonsContainer.addSubview(addToFavoriteButton)
        actionSheetButtonsContainer.addSubview(cancelButton)
        
        textFieldContainer.addSubview(textFieldBoardId)
        textFieldContainer.addSubview(textFieldName)

        overlay.addSubview(textFieldContainer)
        overlay.addSubview(actionSheetButtonsContainer)
        overlay.alpha = 0.0
        
        navigationController?.view.addSubview(overlay)
        
        overlay.topAnchor.constraint(equalTo: navigationController!.view.topAnchor).isActive = true
        overlay.leftAnchor.constraint(equalTo: navigationController!.view.leftAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: navigationController!.view.rightAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: navigationController!.view.bottomAnchor ).isActive = true
                
        actionSheetButtonsContainer.leadingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        actionSheetButtonsContainer.trailingAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        actionButtonsContainerBottomAnchorConstraint = actionSheetButtonsContainer.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -10.0)
        actionButtonsContainerBottomAnchorConstraint!.isActive = true
        
        addToFavoriteButton.leadingAnchor.constraint(equalTo: actionSheetButtonsContainer.leadingAnchor).isActive = true
        addToFavoriteButton.trailingAnchor.constraint(equalTo: actionSheetButtonsContainer.trailingAnchor).isActive = true
        addToFavoriteButton.topAnchor.constraint(equalTo: actionSheetButtonsContainer.topAnchor).isActive = true
        addToFavoriteButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        addToFavoriteButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true

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
    
    func loadBoards() {
        NetworkService.shared.getBoards { (boardsCategories: BoardsWrapper?) in
            self.spinner.stopAnimating()
            
            let favoriteBoards = try! FavoriteBoard.findFavoriteBoards(in: self.container!.viewContext)
            self.favoriteBoards = favoriteBoards
            
            if let boardsCategories = boardsCategories {
                self.boardsCategories = boardsCategories.sortedArray
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Keyboard Notifications

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
    
    @objc func hideOverlayGesture() {
        self.overlay.subviews[0].removeFromSuperview()
        textFieldBoardId.resignFirstResponder()
        textFieldBoardId.text = nil
        textFieldName.text = nil

        if textFieldBoardId.isFirstResponder {
            textFieldBoardId.resignFirstResponder()
            
        }
        
        if textFieldName.isFirstResponder {
            textFieldName.resignFirstResponder()
            
        }
        
        addToFavoriteButton.setTitleColor(#colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1), for: .normal)
        addToFavoriteButton.isEnabled = false
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
    
    @objc func actionAddFavoriteBoard(_ sender: UIButton) {
        addBoardToFavoritesWithId(textFieldBoardId.text!, and:textFieldName.text!)
        tableView.reloadData()
        hideOverlayGesture()
    }
    
    @objc func actionCancelButton(_ sender: UIButton) {
        addToFavoriteButton.setTitleColor(#colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1), for: .normal)
        addToFavoriteButton.isEnabled = false
        hideOverlayGesture()
        
    }
    
    func setUpFavoriteButtonStateAccordingToText(_ text: String) {
        if text.count > 0 {
            addToFavoriteButton.setTitleColor(Constants.Design.Color.orange, for: .normal)
            addToFavoriteButton.isEnabled = true
        } else {
            addToFavoriteButton.setTitleColor(#colorLiteral(red: 0.1960576475, green: 0.1960917115, blue: 0.1960501969, alpha: 1), for: .normal)
            addToFavoriteButton.isEnabled = false
       }
    }
    
    @objc func actionTextFieldIdDidChange(_ sender: UITextField) {
        setUpFavoriteButtonStateAccordingToText(sender.text!)
        
        if let name = findFirstBoardWithMatchedId(sender.text!) {
            setTextFieldName(name)
        }
    }
    
    @objc func actionTextFieldNameDidChange(_ sender: UITextField) {
        setUpFavoriteButtonStateAccordingToText(sender.text!)
    }
    
    @objc func actionOpenAddFavoriteModal(_ sender: UIBarButtonItem) {
        let image = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds).image { _ in
            self.navigationController!.view.drawHierarchy(
                in: UIScreen.main.bounds,
                afterScreenUpdates: true
            )
        }
        if let ciImage = CIImage(image: image) {
            let filteredImage = ciImage.applyingFilter(
                "CIGaussianBlur",
                parameters: [
                    kCIInputRadiusKey: 10.0,
                    kCIInputImageKey: ciImage
                ]
            )
            let imageSizeDifference = -filteredImage.extent.origin.x
            let imageInset = filteredImage.extent.insetBy(
                dx: imageSizeDifference,
                dy: imageSizeDifference
            )
            let ciCtx = CIContext(options: nil)
            let blurredImage = ciCtx.createCGImage(filteredImage, from: imageInset)!
            let image = UIImage(cgImage: blurredImage)
            let screenShotView = UIImageView(image: image)
            screenShotView.frame = UIScreen.main.bounds
            self.overlay.addSubview(screenShotView)
            self.overlay.sendSubviewToBack(screenShotView)
        }
        textFieldBoardId.becomeFirstResponder()
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.Design.Color.teritaryBackground
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.5646546483, green: 0.5647388697, blue: 0.5724784732, alpha: 1)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let threadsTVC = ThreadsTableViewController(style: .plain)

        if indexPath.section == 0 && favoriteBoards.count > 0 {
            threadsTVC.boardId = favoriteBoards[indexPath.row].id!
        } else {
            threadsTVC.boardId = boardsCategories[indexPath.section - 1].boards[indexPath.row].id
        }

        navigationController!.pushViewController(threadsTVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return boardsCategories.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return favoriteBoards.count > 0 ? "Favorites" : nil
        }
        
        return boardsCategories[section - 1].name
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return favoriteBoards.count
        }
        
        return boardsCategories[section - 1].boards.count
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! BoardsListTableViewCell
        cell.isChosen = false
        let section = indexPath.section
        let row = indexPath.row
        var boardName: String
        var boardId: String
        
        if section == 0 && favoriteBoards.count > 0 {
            boardName = favoriteBoards[row].name!
            boardId = favoriteBoards[row].id!
            cell.isChosen = true
        } else {
            boardName = boardsCategories[section - 1].boards[row].name
            boardId =  boardsCategories[section - 1].boards[row].id
            
            let isInFavoriteBoards = favoriteBoards.contains { (fv) -> Bool in
                return fv.id == boardId
            }
        
            if isInFavoriteBoards {
                cell.isChosen = true
            }
        }
        
        cell.accessoryType = .none
//        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.textColor = Constants.Design.Color.orange

        cell.textLabel?.text = boardId
        cell.textLabel?.font = UIFont.systemFont(
            ofSize: cell.textLabel!.font.pointSize,
            weight: UIFont.Weight.bold
        )
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16.0)
        cell.detailTextLabel?.text = boardName
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(15.0)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - SwipeableCellDelegate
    
       func cellDidSwipe(cell: BoardsListTableViewCell) {
           let indexPath = self.tableView.indexPath(for: cell)!
           
           // if swiped cell in favorites section delete
           if indexPath.section == 0 && favoriteBoards.count > 0 {
               let id = favoriteBoards[indexPath.row].id!
               deleteFavoriteBoardWithId(id, at: indexPath.row)
               tableView.reloadData()
           } else {
                let board = boardsCategories[indexPath.section - 1].boards[indexPath.row]
                
                let isInFavoriteBoards = favoriteBoards.contains { (fv) -> Bool in
                    return fv.id == board.id
                }
                
                if !isInFavoriteBoards {
                    addBoardToFavoritesWithId(board.id, and: board.name)
                    tableView.reloadData()
                } else {
                    let index = favoriteBoards.firstIndex { (favoriteBoard) in
                        return favoriteBoard.id == board.id
                    }!
                    deleteFavoriteBoardWithId(board.id, at: index)
                    tableView.reloadData()
                }
            }
       }
}

 
