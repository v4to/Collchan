//
//  BoardsTableViewController.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 22.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import CoreData

class BoardsListTableViewController: UITableViewController, UISearchResultsUpdating, SwipeableCellDelegate, UISearchControllerDelegate {
    // MARK: - SwipeableCellDelegate

    func cellDidSwipe(cell: BoardsListTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)!
        let chosenBoard = sectionsArray[indexPath.section].boards[indexPath.row]
        if favoriteCategory.boards.count == 0 {
            favoriteCategory.boards.append(chosenBoard)
            
            sectionsArray = generateSectionsFromArray(boardsCategories)
            
            if !isSearchFieldPresented { tableView.insertSections(IndexSet(integer: 0), with: .none) }
        } else {
            if !favoriteCategory.boards.contains(chosenBoard) {
                favoriteCategory.boards.append(chosenBoard)
                
                sectionsArray = generateSectionsFromArray(self.boardsCategories)
                
                if !isSearchFieldPresented {
                    let newIndexPath = IndexPath(row: sectionsArray[0].boards.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .none)
                }
            }
        }
    }
    
    // MARK: - Core Data
    var container: NSPersistentContainer!
    
    
    
    
    
    // MARK: - Instance Properties
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
    
    
    
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.isHidden = true
        
        navigationItem.title = "Boards"
        navigationItem.searchController = search
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.addSubview(spinner)
        
        spinner.startAnimating()
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

    
    
    
    
    // MARK: - Actions
    @objc func actionAdd(_ sender: UIBarButtonItem) {
        
    }

    
    
    
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    func didDismissSearchController(_ searchController: UISearchController) {
        isSearchFieldPresented = false
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

 
