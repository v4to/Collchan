//
//  HistoryViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 28.12.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem.title = "History"
//        tabBarItem.image = UIImage(named: "settings-tab-image")
//        tabBarItem.image = UIImage(systemName: "clock.fill")
        tabBarItem.image = Constants.Design.Image.iconThreadsHistory

//        tabBarItem.image = UIImage(systemName: "clock")

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
