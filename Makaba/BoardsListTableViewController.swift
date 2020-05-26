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

    let boards = [
        (
            "Favorites",
            [
                ["/pr", "Программирование"],
                ["/fag", "Фагготрия"],
                ["/mobi", "Мобильные устройста и приложения"],
                ["/wrk", "Работа и карьера"],
                ["/mov", "Фильмы"],
                ["/fiz", "Физкультура"],
                ["/s", "Программы"],
                ["/de", "Дизайн"]
            ]
        ),
        (
            "Техника и Софт",
            [
                ["/hw", "Компьютерное железо"],
                ["/s", "Программы"],
                ["/ra", "Радиотехника"],
                ["/t", "Техника"]
            ]
        ),
        (
            "Творчество",
            [
                ["/wrk", "Работа и карьера"],
                ["/diy", "Хобби"],
                ["/pa", "Живопись"],
                ["/mus", "Музыканты"],
                ["/di", "Столовая"]
            ]
        )
    ]
    
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
    }
    
    
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return boards.count
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return boards[section].1.count
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return boards[section].0
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
        cell!.accessoryType = .none
        cell!.textLabel?.text = boards[section].1[row][0]
        cell!.textLabel?.textColor = .systemOrange
        cell!.textLabel?.font = UIFont.systemFont(
            ofSize: cell!.textLabel!.font.pointSize,
            weight: UIFont.Weight.bold
        )
        cell!.detailTextLabel?.text = boards[section].1[row][1]
        print(boards[indexPath.section].0)
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
