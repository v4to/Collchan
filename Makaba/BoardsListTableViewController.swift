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

class BoardsListTableViewController: UITableViewController, UIGestureRecognizerDelegate, UISearchResultsUpdating {
    
    // MARK: - Instance Properties
    var favorites = [Board]()
    
    var boardsCategories = [BoardCategory]()
    
    var sectionsArray = [BoardCategory]()
    
    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        // dont block tableview from scrolling while searching
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Board"
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
        withFilter filterString: String
    ) -> [BoardCategory] {
        var sectionsArray = array
        
        guard filterString.count > 0 else { return sectionsArray }

        
        for i in sectionsArray.indices {
            sectionsArray[i].boards = sectionsArray[i].boards.filter {
                return
                    $0.id.range(of: filterString, options: .caseInsensitive) != nil ||
                    $0.name.range(of: filterString, options: .caseInsensitive) != nil
            }

        }
    
        return sectionsArray.filter { $0.boards.count > 0 }
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
//        guard let sectionsArray = sectionsArray else { return 0 }
        return sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard boardsCategories != nil else { return 0 }
        
        return sectionsArray[section].boards.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard boardsCategories != nil else { return nil }

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
           
//            cell?.translatesAutoresizingMaskIntoConstraints = false
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
        
        
        
        return cell!
    }
    
    
    
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        self.sectionsArray = self.generateSectionsFromArray(self.boardsCategories, withFilter: text)

        tableView.reloadData()
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

 
